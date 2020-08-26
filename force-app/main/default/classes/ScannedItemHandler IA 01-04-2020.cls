public with sharing class ScannedItemHandler {
    
    static String [] scannedItemFields = new String [] {'perceptionpoint__syncstatus__c','perceptionpoint__syncresponse__c'};

    public static ScannedItem__c createScannedItem (String fileType, String recordId,String contentType, Integer fileSize, String fileName){
        
        //iscreatable or on the ContentVersionHandler
        ScannedItem__c item = new ScannedItem__c();
        item.SyncStatus__c = 'New';
        item.Type__c = fileType;
        item.RecordId__c = recordId;
        item.FileSize__c = fileSize;
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
        perceptionpoint__Config__mdt testinEndpointUrl = [select Id, Label, perceptionpoint__endPointUrl__c from perceptionpoint__Config__mdt where Label ='Testing Endpoint Url'];
        Boolean isUpdatable = FLSUtils.checkUpdatableFields(scannedItemFields);
        Httprequest req = new Httprequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        perceptionpoint__endPoint__c endPointUrl = [select Id, perceptionpoint__endPointUrl__c from perceptionpoint__endPoint__c];
        //req.setEndpoint('https://webhook.site/9c92f8e9-afaf-48aa-9a97-40f402df561e');
        req.setEndpoint(testinEndpointUrl.perceptionpoint__endPointUrl__c);
        String body = Json.serialize(items);
        String key = 'key';
        Blob data = crypto.generateMac('HmacSHA256', Blob.valueOf(body), Blob.valueOf(key));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-PerceptionPoint-HMAC', EncodingUtil.base64Encode(data));
        req.setBody(body);
        req.setMethod('POST');
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
}