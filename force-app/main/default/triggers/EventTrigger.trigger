trigger EventTrigger on Event (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            EventIntegrationService.enqueueEventsForSyncToGCalendar(Trigger.new);
        }
    }
}