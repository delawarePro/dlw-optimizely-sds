using System.Security.Principal;
using EPiServer.Security;

namespace Dlw.Optimizely.Sds.Publishing.Filters;

/// <summary>
/// Filters out content for which an anonymous user has no read access.
/// </summary>
public class HasAccessSiteCatalogFilter : ISiteCatalogFilter
{
    public bool Filter(SiteCatalogItem item, IOperationContext context)
    {
        if (item.Content is not ISecurable securableContent)
        {
            // Non-securable content is not filtered out.
            return true;
        }

        var visitorPrinciple = new GenericPrincipal(new GenericIdentity("visitor"), ["Everyone"]);

        return securableContent.GetSecurityDescriptor().HasAccess(visitorPrinciple, AccessLevel.Read);
    }
}