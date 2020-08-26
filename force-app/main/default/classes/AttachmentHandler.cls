public with sharing class AttachmentHandler {

	static String [] scannedItemFields = new String [] {'perceptionpoint__FileName__c','perceptionpoint__FileSize__c','perceptionpoint__FileType__c','perceptionpoint__RecordId__c','perceptionpoint__syncresponse__c','perceptionpoint__syncstatus__c','perceptionpoint__Type__c','perceptionpoint__Verdict__c'};

    public static void createScannedItem (List<Attachment> triggerNew){
    	Boolean isCreateableObject = ScannedItem__c.sObjectType.getDescribe().isCreateable();
		Boolean VerifCreateableFields = FLSUtils.checkUpdatableFields(scannedItemFields);
    	List<ScannedItem__c> items = new List<ScannedItem__c>();
    	for(Attachment attach :triggerNew){ 
    		String fileType = 'attachment';
    		items.add (ScannedItemHandler.createScannedItem (fileType,attach.Id,attach.ContentType, attach.BodyLength, attach.Name));
    	}
    	
    	//iscreatable on all fields
    	
    	if(isCreateableObject && VerifCreateableFields)
		{
			insert items;
		}
    }
    
}