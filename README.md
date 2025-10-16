# delaware sitemaps

## Overview

The **Embedded Site Discovery Service**  is a tool designed to create sitemaps for any Optimizely project. It helps **improve SEO** by generating XML sitemaps that search engines can use to index your site(s) more effectively.

## Optimizely NuGet feed

Packages for the Optimizely NuGet feed are currently built against a private version of this repo. A final move to this repo is on the roadmap.

## Features

- Automatically pre-generates XML sitemaps
- Iterates all pages and blocks for configured sites
- Add external or dynamic content
- Configurable settings for including/excluding specific content
- Easy integration with existing Optimizely projects

## Installation

Install the NuGet package, currently available from the Platina feed:

    Install-Package Delaware.Optimizely.Sitemap

## Configuration

## Startup

Add the following line to your service configuration setup:

    services
        .AddSitemap(Configuration /* IConfiguration */)

... with the optional registration of dynamic content processors (for more details, see __Dynamic content__)

    services
        .AddSingleton<IDynamicContentRootProcessor, CustomDynamicContentRootProcessor>();

... and the following line to the Middleware setup:

    app
        .ConfigureSitemap();

This enables the Sitemap code. The next section shows how to configure this per site.

## Site configuration

The Sitemap can be enabled per site instance. Add this for each site to enable Sitemap, where _site_ is a site definition:

    serviceProvider
        .AddEmbeddedSitemapCatalog(site, new[]{"nl","nl-be","en"}, catalog => catalog.WithDefaults());

This configures the site catalog with all defaults.

### Customizations

If the default settings don't cover all required Sitemap scenarios, the defaults to pick from in code are:

    serviceProvider
        .AddSitemapCatalog(site, new [] { /* languages for site */ "en", "nl-be" }
             catalog => catalog
            .WithDefaultBlocks()
            .WithDefaultMapping()
            .WithBlockRoots(BlockRoots)
            .WithDefaultFilters()
            .WithDefaultPageProvider())
        .WithEmbeddedSitemap(site, languages);

#### WithDefaultBlocks

The configuration method **.WithDefaultBlocks()** can be extended with (or replaced by) the following configuration methods:

    .WithBlockRoots( /* list of content references to block containers */)
    .WithBlockFilter(/* Filter(SiteCatalogItem item, IOperationContext context) */)

Block roots: a list of content references to block folders to index for this site.
With filter: specify custom filtering. 

By default, the indexing will happen on the _For this site_ folder for the site.

### WithDefaultMapping

**WithDefaultMapping** registers a service which maps Optimizely content to localized _ISiteCatalogEntry_ items. To customize this, register a custom _ISiteCatalogEntryMapper_ implementation instead:

    WithCustomMapping(ISiteCatalogEntryMapper customEntryMapper)

### WithDefaultFilters

**WithDefaultFilters** makes sure content which is marked with the _IExcludeFromSitemap_ interface is excluded from sitemap indexing and blocks of a derived type of type _MediaData_ are excluded.

This can be extended (or replaced) by:

    WithPageFilter(/* Filter(SiteCatalogItem item, IOperationContext context) */)
    WithBlockFilter(/* Filter(SiteCatalogItem item, IOperationContext context) */)

### WithDefaultPageProvider

**WithDefaultPageProvider** registers a default implementation for retrieving localized variants of the content. To customize this, register a custom _ISiteCatalogPageProvider_ implementation instead:

    WithPageProvider(ISiteCatalogPageProvider pageProvider)

## Exclude content

Exclude content of a given content type from being processed, is achieved by marking that content type
with interface _IExcludeFromSitemap_.

## Dynamic content

Content pages can also be the base for resolving dynamic content (inside or outside Optimizely) with partial routers.

To add such dynamic content to the sitemap, create an implementation for **IDynamicContentRootProcessor**. 
This extension point gives the opportunity per page object, to determine the custom processor can process:
    
    IAsyncEnumerable<DynamicContentProcessingResult?> ExpandForPageAsync(
        ContentReference pageId,        // The page currently being processed.
        ContentReference contentTypeId, // The content type of the page currently being processed.
        string[] languages);            // The languages of the configured site catalog, currently being processed.
    
Tip: check if the processor can handle this combination as soon as possible. If not, quit the method as soon as possible.

> **What should an _IDynamicContentRootProcessor_ implementation return?**
>
> A **stream of DynamicContentProcessingResult** objects.
>
> This stream is async and will be awaited for, this is particularly useful when dealing with externally stored dynamic content.
>
> The order in which result items are returned, is not important. You can opt for different strategies:
> * Iterate dynamic content language per language
> * Iterate dynamic content item per item
> * ...
>
> The stream is aggregated and grouped by the _DynamicContentSourceId_ property. 
> This property should hold the ID which makes the dynamic content item unique - e.g.: product ID, employee number.


## Sitemap path

In case there is a need to have a different entry path than /sitemap.xml, configure the following app setting:

      "Delaware": {
        "Sitemaps":{
            "SitemapEntryPath": "/sitemap.xml"
        }
      }

This would allow to validate and test the Embedded Sitemap next to an existing setup.

## Usage

By default, enabling Sitemap registers **3 scheduled jobs**:

* A **full indexing job** which only publishes the site catalogs - disabled by default. Enable this job with using the full setup of Sitemap, not the embedded!
* A **full indexing job with sitemap generation** which does the same as the above but adds generated sitemap.xml files on top. Enabled by default.
* A **delta processing job** (for embedded Sitemap) which creates sitemap pages for updates since the last full indexing job ran. This job runs hourly by default.

When adjusting the time interval for these jobs, make sure the interval for the delta job is smaller than the interval for the full indexing job.

When a **lot of content has changed** (e.g. due to a massive manual upload of a package), please **run the full job** manually to create clean sitemap pages.