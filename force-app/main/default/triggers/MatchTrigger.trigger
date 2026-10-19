trigger MatchTrigger on Match__c (before insert) {

    TriggerRunner runner = new MatchTriggerImp();
    runner.run(Trigger.new, Trigger.oldMap, Trigger.operationType);

}