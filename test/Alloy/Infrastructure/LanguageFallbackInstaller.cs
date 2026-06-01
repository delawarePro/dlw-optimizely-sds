using EPiServer.Applications;
using EPiServer.Web;

namespace Alloy.Infrastructure;

/// <summary>
/// Configures language fallback settings for the Alloy site on the first request, 
/// after <see cref="DefaultApplicationFirstRequestInitializer"/> has seeded the site content.
/// </summary>
public class LanguageFallbackInstaller(
    IApplicationRepository applicationRepository,
    ContentLanguageSettingRepository contentLanguageSettingRepository,
    IContentLanguageSettingsHandler contentLanguageSettingsHandler) : IBlockingFirstRequestInitializer
{
    public bool CanRunInParallel => false;

    public Task InitializeAsync(HttpContext httpContext)
    {
        var alloyWebsite = applicationRepository.Get<InProcessWebsite>("alloy")
            ?? throw new InvalidOperationException("Alloy website not found. Ensure the site content has been seeded before this initializer runs.");

        var settings = contentLanguageSettingsHandler.Get(alloyWebsite.EntryPoint, "sv")
            ?.CreateWritableClone()
            ?? new ContentLanguageSetting(alloyWebsite.EntryPoint, "sv");

        settings.LanguageBranchFallback = ["en"];

        contentLanguageSettingRepository.Save(settings);

        return Task.CompletedTask;
    }
}