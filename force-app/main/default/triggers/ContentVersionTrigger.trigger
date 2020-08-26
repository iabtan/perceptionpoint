trigger ContentVersionTrigger on ContentVersion (after insert) {
    
    ContentVersionHandler.createScannedItem(trigger.new); 
}