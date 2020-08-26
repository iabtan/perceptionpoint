public with sharing class ContentVersionHandler {

    public static void createScannedItem (List<ContentVersion> triggerNew){
    	
    	List<ScannedItem__c> items = new List<ScannedItem__c>();
		Boolean isCreateableObject = ScannedItem__c.sObjectType.getDescribe().isCreateable();
    	for(ContentVersion cv :triggerNew){ 
    		String fileType = 'File';
    		items.add (ScannedItemHandler.createScannedItem (fileType,cv.Id , cv.FileType, cv.ContentSize, cv.Title));
    	}
    	//iscreatable + all fields
		if(isCreateableObject){
			insert items;
		}
    	
    }
    
}