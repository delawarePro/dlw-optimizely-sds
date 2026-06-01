using Alloy.Extensions;
using Alloy.Infrastructure;
using Alloy.Infrastructure.LocalDb.Builders;
using Delaware.Optimizely.Sitemap;
using EPiServer.Applications;
using EPiServer.Cms.UI.AspNetIdentity;
using EPiServer.Data;
using EPiServer.DependencyInjection;
using EPiServer.Scheduler;
using EPiServer.Web;
using EPiServer.Web.Routing;

namespace Alloy;

public class Startup(IConfiguration configuration, IWebHostEnvironment webHostingEnvironment)
{
    public void ConfigureServices(IServiceCollection services)
    {
        if (webHostingEnvironment.IsDevOrAutomatedTest())
        {
            AppDomain.CurrentDomain.SetData("DataDirectory", Path.Combine(webHostingEnvironment.ContentRootPath, "App_Data"));

            services.Configure<SchedulerOptions>(options => options.Enabled = false);

            // Wire local db for development and automated testing
            services.AddLocalDbHost(configuration);
        }

        services.Configure<DataAccessOptions>(o => o.UpdateDatabaseCompatibilityLevel = true);

        services
            .AddCmsAspNetIdentity<ApplicationUser>()
            .AddCms()
            .AddAlloy()
            //.AddAdminUserRegistration() disabled for automated testing.
            .AddSitemap(configuration)
            .AddEmbeddedLocalization<Startup>();

        // Configures language fallback on the Alloy site, which is required for the sitemap tests.
        // Depends on DefaultApplicationFirstRequestInitializer, registered by AddCms(), to have run first.
        services.AddSingleton<IFirstRequestInitializer, LanguageFallbackInstaller>();

        // Required by Wangkanai.Detection
        services.AddDetection();

        services.AddSession(options =>
        {
            options.IdleTimeout = TimeSpan.FromSeconds(10);
            options.Cookie.HttpOnly = true;
            options.Cookie.IsEssential = true;
        });
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }

        // Required by Wangkanai.Detection
        app.UseDetection();
        app.UseSession();

        app.UseStaticFiles();
        app.UseRouting();
        app.UseAuthentication();
        app.UseAuthorization();

        app.ConfigureSitemap();

        // In a typical production setup, sites and their content already exist when the application starts,
        // so AddEmbeddedSitemapCatalog can be called directly during startup (see BuilderExtensions).
        //
        // In this test setup, the database is seeded on the first request via DefaultApplicationFirstRequestInitializer,
        // meaning the 'alloy' site does not exist yet at startup time. We therefore defer catalog registration
        // until the first request has completed that initialization.
        var registerSitemapCatalog = new Lazy<bool>(() =>
        {
            var alloyWebsite = app.ApplicationServices.GetRequiredService<IApplicationRepository>()?.Get<InProcessWebsite>("alloy");
            if (alloyWebsite is not null)
            {
                app.ApplicationServices.AddEmbeddedSitemapCatalog(alloyWebsite, ["en", "sv"], catalog =>
                    catalog
                        .WithDefaultFilters()
                        .WithDefaultMapping()
                        .WithDefaultPageProvider());
            }

            return true;
        });

        app.Use(async (context, next) =>
        {
            // Trigger deferred catalog registration on the first request, then becomes a no-op.
            _ = registerSitemapCatalog.Value;
            await next();
        });

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapContent();
        });
    }
}
