public with sharing class ScannedItemHandler {
	
	
    public static ScannedItem__c createScannedItem (String fileType, String recordId,String contentType, Integer fileSize, String fileName){
    	
    	//iscreatable or on the ContentVersionHandler
		ScannedItem__c item = new ScannedItem__c();
		item.SyncStatus__c = 'New';
		item.Type__c = fileType;
		item.RecordId__c = recordId;
		
		//if(Schema.getGlobalDescribe().get('ScannedItem__c').getDescribe().fields.getMap().get('FileSize__c').getDescribe().isCreateable()){
		if (!Schema.sObjectType.ScannedItem__c.fields.FileSize__c.isUpdateable()){
			item.FileSize__c = fileSize;
		}
		item.FileType__c = contentType;
		item.FileName__c = fileName;
	
		return item;
    }
    
    public static void notifySystemOnNewFiles(List<ScannedItem__c> items, Map<Id,ScannedItem__c> oldMap){
        Set<String> itemsIds = new  Set<String>();
     	for(ScannedItem__c item :items){
    		if (oldMap == null || (oldMap.get(item.Id).SyncStatus__c !=  'New' && item.SyncStatus__c ==  'New')){
                itemsIds.add(item.Id);
    		}
    	}

		if(itemsIds.size()>0) {
    		notifySystemOnNewFile(itemsIds);
		}
		
    }
    
    @future(callout=true)
    public static void notifySystemOnNewFile(Set<String> itemIds){
    	
    	//isaccessible
    	List<ScannedItem__c> items = [select Id,RecordId__c,FileSize__c,FileType__c,Type__c,SyncStatus__c,OrgId__c from ScannedItem__c where Id in :itemIds];
		Boolean isUpdatable = false; 
        Httprequest req = new Httprequest();
	 	HttpResponse res = new HttpResponse();
	 	Http http = new Http();
	              
	        req.setEndpoint('https://webhook.site/9c92f8e9-afaf-48aa-9a97-40f402df561e');
	        String body = Json.serialize(items);
			String key = 'key';
			Blob data = crypto.generateMac('HmacSHA256', Blob.valueOf(body), Blob.valueOf(key));
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('X-PerceptionPoint-HMAC', EncodingUtil.base64Encode(data));
	        req.setBody(body);
	        req.setMethod('POST');
			String [] contactUpdateFields = new String [] {'perceptionpoint__syncstatus__c','perceptionpoint__syncresponse__c'};
			Map<String,Schema.SObjectField> m = Schema.SObjectType.ScannedItem__c.fields.getMap();
			isUpdatable = ObjectUpdateable(contactUpdateFields , m);
	        try {
	            res = http.send(req);
				
				if (res.getStatusCode() == 200){
					if(isUpdatable){
                        for (ScannedItem__c item : items) {
                        
							item.SyncStatus__c = 'Sent to Scan';
	                        item.SyncResponse__c = res.getBody();
						}
					}
					else {
						if(isUpdatable){
	                        for (ScannedItem__c item : items) {
	                            item.SyncStatus__c = 'Sync Failed';
	                       		item.SyncResponse__c = res.getBody();
	                        }
						}
						
					}
	        	}
            }
	        catch(Exception ex){
	            if(isUpdatable) {
                     	for (ScannedItem__c item : items)  {
							item.SyncStatus__c = 'Sync Failed';
                       	 	item.SyncResponse__c = ex.getMessage();
                        }		
                }
	        }
	        finally {
	        	update items;
	        }
    }

	public static Boolean ObjectUpdateable(String [] contactUpdateFields, Map<String,Schema.SObjectField> m){
		for (String fieldToCheck : contactUpdateFields)  {
			if (!m.get(fieldToCheck).getDescribe().isUpdateable())   {
        		return false;
            }
        }
        return true;
	}
}