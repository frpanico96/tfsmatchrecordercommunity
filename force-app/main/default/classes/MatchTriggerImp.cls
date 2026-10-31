public with sharing class MatchTriggerImp extends TriggerRunner {
    public override void beforeInsert(List<SObject> records) {
        
        for(Match__c match : (List<Match__c>)records) {
            match.Uid__c = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            match.Status__c = 'New';
        }

    }

}