/**
 * A basic controller for the FMSCA Portal
 */
public with sharing class FmscaPortalController {

    /**
     * Perform two SOQL queries to determine all the children NavigationMenuItems
     * belonging to the provided menuName and publishedState.
     * 
     * NavigationLinkSet contains both Draft and Live Status values of the NavigationMenuItems.
     *
     * Referential integrity assumes API name of the Nav Link Set (DeveloperName field)
     * won't change.
     * 
     * param 'menuName' => NavigationLinkSet.DeveloperName
     * param 'publishedState' => NavigationMenuItem.Status enum
     */
    @AuraEnabled(cacheable=true)
    public static List<NavigationMenuItem> getNavigationMenuItems(
        String menuName,
        String publishedState
    ) {
        if (String.isEmpty(menuName)) {
            return new List<NavigationMenuItem>();
        }

        // fetch Link Sets belonging to current portal context at runtime only
        String networkId = Network.getNetworkId();

        // False positive PMD warning - still unable to detect 'WITH [access_modifier]' in SOQL queries
        @SuppressWarnings('PMD.ApexCRUDViolation') 
        List<NavigationLinkSet> linkSets = [
            SELECT Id
            FROM NavigationLinkSet
            WHERE DeveloperName = :menuName AND NetworkId = :networkId
            WITH USER_MODE
        ];

        Id linkSetId = linkSets.get(0).Id;

        // value of Status field is either Draft or Live
        return [
            SELECT
                Label,
                Target,
                Type,
                DefaultListViewId,
                AccessRestriction,
                ParentId,
                Position,
                Status,
                TargetPrefs
            FROM NavigationMenuItem
            WHERE NavigationLinkSetId = :linkSetId AND Status = :publishedState
            WITH USER_MODE
            ORDER BY Position
        ];
    }
}