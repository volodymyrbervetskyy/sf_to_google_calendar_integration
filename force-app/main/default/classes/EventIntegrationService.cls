public with sharing class EventIntegrationService {
    
    public static void syncToGCalendar(List<Event> newEvents){
        for(Event event : newEvents){
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:GoogleCalendarDemoNamedCredential/calendar/v3/calendars/primary/events');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            
            String requestBody = serializeEvent(event);
            req.setBody(requestBody);

            new Http().send(req);
        }
    }

    private static String serializeEvent(Event e){
        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('summary', e.Subject);
        jsonMap.put('description', e.Description);

        Map<String, Object> startMap = new Map<String, Object>();
        Map<String, Object> endMap = new Map<String, Object>();
        
        if(e.IsAllDayEvent == TRUE){
            startMap.put('date', e.StartDateTime.date());
            endMap.put('date', e.StartDateTime.date().addDays(1));
        } else {
            startMap.put('dateTime', e.StartDateTime);
            startMap.put('timeZone', UserInfo.getTimeZone().getID());

            endMap.put('dateTime', e.EndDateTime);
            endMap.put('timeZone', UserInfo.getTimeZone().getID());            
        }

        jsonMap.put('start', startMap);
        jsonMap.put('end', endMap);

        return JSON.serialize(jsonMap);
    }

    public static void enqueueEventsForSyncToGCalendar(List<Event> newEvents){
        System.enqueueJob(
            new EventIntegrationQueueable( 
                new Map<Id, Event>(newEvents).keySet()
            )
        );
    }

}