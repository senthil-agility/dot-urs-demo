/**
 * A basic controller for the FMSCA Portal
 */
public with sharing class FmscaPortalController {

    public class FormDataWrapper {
        @AuraEnabled
        public Case caseData;
        @AuraEnabled
        public OmniScriptSavedSession sesh;
    }

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

    @AuraEnabled
    public static List<FormDataWrapper> fetchApplicationData(){
        try {
            String contactId = [SELECT Id, ContactId FROM User WHERE Id = :UserInfo.getUserId() WITH USER_MODE LIMIT 1].ContactId;
            List<Case> caseList = [
                SELECT
                    Id,
                    CaseNumber,
                    Status,
                    Owner.Name,
                    OwnerId,
                    New_Entrant__c,
                    Insurance_Required__c
                FROM Case
                WHERE ContactId = :contactId
                WITH USER_MODE
            ];
            List<FormDataWrapper> tempList = new List<FormDataWrapper>();
            // Map<Id, FormDataWrapper> formResumeMapper = new Map<Id, FormDataWrapper>();
            for (Case element : caseList) {
                FormDataWrapper newWrapper = new FormDataWrapper();
                newWrapper.caseData = element;
                // if (element.Forms_007_008__r != null && element.Forms_007_008__r.size() > 0) {
                //     formResumeMapper.put(element.Forms_007_008__r[0].Id, newWrapper);
                //     continue;
                // }
                tempList.add(newWrapper);
                System.debug('$templist: ' + tempList);
            }

            return tempList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Case> fetchCaseData(){
        try {
            return [
                SELECT
                    Id,
                    CaseNumber,
                    Status,
                    Owner.Name,
                    OwnerId
                FROM Case
                WHERE OwnerId = :UserInfo.getUserId()
                WITH USER_MODE
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}