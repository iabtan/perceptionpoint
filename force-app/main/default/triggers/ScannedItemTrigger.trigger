trigger ScannedItemTrigger on ScannedItem__c (after insert, after update) {
    
	ScannedItemHandler.notifySystemOnNewFiles(trigger.new, trigger.oldMap);
}