public with sharing class UserTriggerHelper {
    public void process() {
        Set<Id> profileIdSet = new Set<Id>();
        Map<String,Id> profileIdMap = new Map<String, Id>();
        for (User usr : (List<User>)Trigger.new) {
            profileIdSet.add(usr.ProfileId);
        }
        for (Profile profs : [SELECT Id, Name FROM Profile WHERE Id IN :profileIdSet]) {
            profileIdMap.put(profs.Name, profs.Id);
        }
        updateContactsActivation(JSON.serialize(Trigger.new), profileIdMap);
    }

    @future
    private static void updateContactsActivation(String userIdListJson, Map<String,Id> profileIdMap) {
        List<User> userIdList = (List<User>)JSON.deserialize(userIdListJson, List<User>.class);
        List<Contact> ctUpdateList = new List<Contact>();
        List<User_Contact_Sync__e> contactUpdateList = new List<User_Contact_Sync__e>();

        for (User usr : userIdList) { //[Select Id, ContactId, IsActive from User where Profile.Name = 'OPIC External User' and Id in :userIdList]) {
            if (!String.isBlank(usr.ContactId)) {
                if (profileIdMap.get(JITUserProvisioningHandler.COMMUNITY_PROFILE_NAME) != null && profileIdMap.get(JITUserProvisioningHandler.COMMUNITY_PROFILE_NAME).equals(usr.ProfileId)) {
                    User_Contact_Sync__e toUpdate = new User_Contact_Sync__e();
                    toUpdate.ContactId__c = usr.ContactId;
                    toUpdate.Phone__c = usr.Phone;
                    toUpdate.FirstName__c = usr.FirstName;
                    toUpdate.LastName__c = usr.LastName;
                    toUpdate.CompanyName__c = usr.CompanyName;
                    contactUpdateList.add(toUpdate);
                }
            }
        }
        Eventbus.publish(contactUpdateList);
    }
}