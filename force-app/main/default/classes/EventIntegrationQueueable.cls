public with sharing class EventIntegrationQueueable implements Queueable, Database.AllowsCallouts {
    
    private Set<Id> eventsIds;

    public EventIntegrationQueueable(Set<Id> eventsIds) {
        this.eventsIds = eventsIds;
    }

    public void execute(QueueableContext context) {
        List<Event> events = [
            SELECT Subject, Description, IsAllDayEvent, StartDateTime, EndDateTime
            FROM Event
            WHERE Id IN :eventsIds
        ];
        
        EventIntegrationService.syncToGCalendar(events);
    }
}