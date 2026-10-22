public with sharing class PickBanPhaseUtils {


    public static List<String> getWinCon(String winCon){

        SObjectAccessDecision securityDecision = 
            Security.stripInaccessible(AccessType.READABLE, [
                SELECT Id,Setup__c
                FROM WinConSetup__c
                WHERE WinCondition__c = :winCon
            ]);
        
        if(securityDecision.getRecords().size() > 0){
            return ((WinConSetup__c)securityDecision.getRecords()[0]).Setup__c.split(',');
        }

        return new List<String>();

    }

}