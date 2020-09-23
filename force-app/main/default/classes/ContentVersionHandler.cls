public with sharing class ContentVersionHandler {
	
	static String [] scannedItemFields = new String [] {'perceptionpoint__FileName__c','perceptionpoint__FileSize__c','perceptionpoint__FileType__c','perceptionpoint__RecordId__c','perceptionpoint__syncresponse__c','perceptionpoint__syncstatus__c','perceptionpoint__Type__c','perceptionpoint__Verdict__c'};
	
    
	public static void createScannedItem (List<ContentVersion> triggerNew){
    	Boolean isCreateableObject = ScannedItem__c.sObjectType.getDescribe().isCreateable();
		Boolean verifCreateableFields = FLSUtils.checkUpdatableFields(scannedItemFields);
		/*
		if(!isCreateableObject || !verifCreateableFields){
			return;
		}
		*/
		List<ScannedItem__c> items = new List<ScannedItem__c>();
		List<String> ContentVersionsIds = new List<String>();
		String fileType = 'File';
    	for(ContentVersion cv :triggerNew){ 
			ContentVersionsIds.add(cv.Id);
    		//items.add (ScannedItemHandler.createScannedItem (fileType,cv.Id , cv.FileType, cv.ContentSize, cv.Title));
		}
		items = [select Id, perceptionpoint__RecordId__c from ScannedItem__c where perceptionpoint__RecordId__c in :ContentVersionsIds];
		List<ScannedItem__c> itemsToInsert = new List<ScannedItem__c>();
		if(items.size() == 0){
            for(ContentVersion cv : triggerNew){
                itemsToInsert.add(ScannedItemHandler.createScannedItem (fileType,cv.Id, cv.FileType, cv.ContentSize, cv.Title));
            }
		}
		else{
			for(ScannedItem__c item : items){
                for(ContentVersion cv : triggerNew){
                    if(cv.Id != item.perceptionpoint__RecordId__c) {
                        itemsToInsert.add(ScannedItemHandler.createScannedItem (fileType,cv.Id, cv.FileType, cv.ContentSize, cv.Title));
                    }
                }
            }
		}

		if(itemsToInsert.size()>0){
			insert itemsToInsert;
		}
		
    }
    
}