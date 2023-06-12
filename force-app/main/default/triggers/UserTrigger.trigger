trigger UserTrigger on User (after insert, after Update) {
    new UserTriggerHelper().process();
}