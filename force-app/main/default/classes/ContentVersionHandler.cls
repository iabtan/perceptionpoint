public with sharing class ContentVersionHandler {
	
	static String [] scannedItemFields = new String [] {'perceptionpoint__FileName__c','perceptionpoint__FileSize__c','perceptionpoint__FileType__c','perceptionpoint__RecordId__c','perceptionpoint__syncresponse__c','perceptionpoint__syncstatus__c','perceptionpoint__Type__c','perceptionpoint__Verdict__c'};
	
    
	public static void createScannedItem (List<ContentVersion> triggerNew){
    	Boolean isCreateableObject = ScannedItem__c.sObjectType.getDescribe().isCreateable();
		Boolean verifCreateableFields = FLSUtils.checkUpdatableFields(scannedItemFields);

		if(!isCreateableObject || !verifCreateableFields){
			return;
		}
    	List<ScannedItem__c> items = new List<ScannedItem__c>();
    	for(ContentVersion cv :triggerNew){ 
    		String fileType = 'File';
    		items.add (ScannedItemHandler.createScannedItem (fileType,cv.Id , cv.FileType, cv.ContentSize, cv.Title));
    	}
    	insert items;
    }
    
}