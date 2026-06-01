using System.IO.Compression;
using System.Xml.Linq;
using Alloy;
using Delaware.Optimizely.Sitemap.Jobs;
using Delaware.Optimizely.Testing;  
using Dlw.EpiBase.IntegrationTests;
using EPiServer.DataAbstraction;
using EPiServer.Scheduler;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests.TestSite;

[TestClass]
public class AlloyTests : TestClassBase
{
    private TestWebApp<Program> WebApp { get; set; } = null!;

    private HttpClient HttpClient { get; set; } = null!;

    [TestInitialize]
    public async Task TestInitialize()
    {
        // Create CMS test app.
        WebApp = await TestInfra.CreateOptimizelyCmsTestWebApp(shared: true);

        // Create a test client.
        HttpClient = WebApp.CreateTestClient(TestInfra.Logger);
        HttpClient.BaseAddress = new Uri("https://localhost:5000");

        // The Alloy templates site is initialized on the first request, see DefaultApplicationFirstRequestInitializer and DefaultSiteContent.episerverdata.
        // Before attempting to generate a sitemap we should make sure the demo content is in place.
        var warmup = await HttpClient.GetAsync("/");
        Assert.IsTrue(warmup.IsSuccessStatusCode);
    }

    [TestMethod]
    public async Task CanPublishAndGenerateSitemap()
    {
        var repo = WebApp.Services.GetService<IScheduledJobRepository>();
        var scheduler = WebApp.Services.GetService<IScheduledJobExecutor>();

        // Trigger sitemap generation through the scheduled job.
        var fullSiteCatalogJob = repo!.Get(Guid.Parse(FullSiteCatalogWithSitemapGenerationJob.JobId));

        var jobResult = await scheduler.StartAsync(fullSiteCatalogJob, new JobExecutionOptions() { Trigger = ScheduledJobTrigger.Scheduler });

        Assert.AreEqual(ScheduledJobExecutionStatus.Succeeded, jobResult.Status);
        Assert.AreEqual("[Sitemap] 'FullSiteCatalogJob' finished.", jobResult.Message);

        // Request the sitemap index and verify it exposes a single sitemap entry.
        var response = await HttpClient.GetAsync("/sitemap.xml");

        Assert.IsTrue(response.IsSuccessStatusCode);
        Assert.AreEqual("application/xml", response.Content.Headers.ContentType?.MediaType);

        var content = await response.Content.ReadAsStringAsync();
        var document = XDocument.Parse(content);
        XNamespace sitemapNamespace = "http://www.sitemaps.org/schemas/sitemap/0.9";
        XNamespace xhtmlNamespace = "http://www.w3.org/1999/xhtml";

        Assert.IsNotNull(document.Root);
        Assert.AreEqual("sitemapindex", document.Root.Name.LocalName);
        Assert.AreEqual(sitemapNamespace.NamespaceName, document.Root.Name.NamespaceName);

        var sitemapElements = document.Root.Elements(sitemapNamespace + "sitemap").ToList();
        Assert.AreEqual(1, sitemapElements.Count);

        var loc = sitemapElements[0].Element(sitemapNamespace + "loc");
        Assert.IsNotNull(loc);
        Assert.IsTrue(Uri.TryCreate(loc.Value, UriKind.Absolute, out var sitemapUri));

        // Follow the linked sitemap file and decompress the XML payload.
        var sitemapResponse = await HttpClient.GetAsync(sitemapUri.PathAndQuery);

        Assert.IsTrue(sitemapResponse.IsSuccessStatusCode);
        Assert.AreEqual("application/xml", sitemapResponse.Content.Headers.ContentType?.MediaType);
        Assert.Contains("gzip", sitemapResponse.Content.Headers.ContentEncoding, StringComparer.OrdinalIgnoreCase);

        using var sitemapStream = await sitemapResponse.Content.ReadAsStreamAsync();
        using var xmlStream = new GZipStream(sitemapStream, CompressionMode.Decompress);
        var sitemapDocument = XDocument.Load(xmlStream);

        Assert.IsNotNull(sitemapDocument.Root);
        Assert.AreEqual("urlset", sitemapDocument.Root.Name.LocalName);
        Assert.AreEqual(sitemapNamespace.NamespaceName, sitemapDocument.Root.Name.NamespaceName);

        const string expectedUrl = "https://localhost:5000/en/about-us/news-events/press-releases/alloy-meet-acclaimed-for-top-collaboration-technology/";
        const string expectedSvUrl = "https://localhost:5000/sv/about-us/news-events/press-releases/alloy-meet-acclaimed-for-top-collaboration-technology/";

        // Verify the expected page entry and its alternate language links.
        var urlElement = sitemapDocument.Root
            .Elements(sitemapNamespace + "url")
            .FirstOrDefault(x => x.Element(sitemapNamespace + "loc")?.Value == expectedUrl);

        Assert.IsNotNull(urlElement);

        var alternateLinks = urlElement.Elements(xhtmlNamespace + "link").ToList();
        Assert.HasCount(3, alternateLinks);
        Assert.Contains(x =>
            x.Attribute("rel")?.Value == "alternate" &&
            x.Attribute("hreflang")?.Value == "en" &&
            x.Attribute("href")?.Value == expectedUrl, alternateLinks);
        Assert.Contains(x =>
            x.Attribute("rel")?.Value == "alternate" &&
            x.Attribute("hreflang")?.Value == "sv" &&
            x.Attribute("href")?.Value == expectedSvUrl, alternateLinks);
        Assert.Contains(x =>
            x.Attribute("rel")?.Value == "alternate" &&
            x.Attribute("hreflang")?.Value == "x-default" &&
            x.Attribute("href")?.Value == expectedUrl, alternateLinks);
    }
}