public with sharing class MatchUtils {
    
    public static String getMatchByCode(String matchCode){

        SObjectAccessDecision securityDecision =
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id
                FROM Match__c
                WHERE UID__c = :matchCode
            ]);

        if(securityDecision.getRecords().size() > 0){
            return ((Match__c)securityDecision.getRecords()[0]).Id;
        }

        return 'NO RECORD FOUND';
    }



}