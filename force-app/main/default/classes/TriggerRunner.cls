public virtual with sharing class TriggerRunner {
    

    public void run(List<SObject> records, Map<Id, SObject> oldMap, TriggerOperation operation) {
        if (operation == TriggerOperation.BEFORE_INSERT) {
            beforeInsert(records);
        } else if (operation == TriggerOperation.BEFORE_UPDATE) {
            beforeUpdate(records, oldMap);
        } else if (operation == TriggerOperation.BEFORE_DELETE) {
            beforeDelete(records);
        } else if (operation == TriggerOperation.AFTER_INSERT) {
            afterInsert(records);
        } else if (operation == TriggerOperation.AFTER_UPDATE) {
            afterUpdate(records, oldMap);
        } else if (operation == TriggerOperation.AFTER_DELETE) {
            afterDelete(records);
        }
    }

    public virtual void beforeInsert(List<SObject> records) {}
    public virtual void beforeUpdate(List<SObject> records, Map<Id, SObject> oldMap) {}
    public virtual void beforeDelete(List<SObject> records) {}
    public virtual void afterInsert(List<SObject> records) {}
    public virtual void afterUpdate(List<SObject> records, Map<Id, SObject> oldMap) {}
    public virtual void afterDelete(List<SObject> records) {}


}