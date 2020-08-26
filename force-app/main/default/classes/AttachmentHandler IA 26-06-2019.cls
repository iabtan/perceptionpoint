public with sharing class AttachmentHandler {

    public static void createScannedItem (List<Attachment> triggerNew){
    	
    	List<ScannedItem__c> items = new List<ScannedItem__c>();
    	for(Attachment attach :triggerNew){ 
    		String fileType = 'attachment';
    		items.add (ScannedItemHandler.createScannedItem (fileType,attach.Id,attach.ContentType, attach.BodyLength, attach.Name));
    	}
    	
    	//iscreatable on all fields
    	
    	if(ScannedItem__c.sObjectType.getDescribe().isCreateable())
		{
			insert items;
		}
    }
    
}