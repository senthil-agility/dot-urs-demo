trigger UserContactSyncTrigger on User_Contact_Sync__e (after insert) {
    List<Contact> contacts = new List<Contact>();
    for (User_Contact_Sync__e event : Trigger.new) {
        Contact toUpdate = new Contact();
        toUpdate.Id = event.ContactId__c;
        toUpdate.Phone = event.Phone__c;
        toUpdate.FirstName = event.FirstName__c;
        toUpdate.LastName = event.LastName__c;
        contacts.add(toUpdate);
    }
    update contacts;
}