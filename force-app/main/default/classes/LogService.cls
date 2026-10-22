public with sharing class LogService {
    

    public static void insertTrace(String logName, String key, String status, String body){

        Log__c log = new Log__c();
        log.Name = logName;
        log.Type__c = 'TRACE';
        log.Status__c = status;
        log.Body__c = body;
        log.Key__c = key;
        Database.insert(log, AccessLevel.USER_MODE);

    }


}