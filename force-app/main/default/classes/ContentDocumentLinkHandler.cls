public with sharing class ContentDocumentLinkHandler {
    public static void createScannedItem(List<ContentDocumentLink> triggerNew) {
        List<String> ContentDocumentLinksIds = new List<String>();
        List<String> ContentVersionsIds  = new List<String>();
        String fileType = 'File';
        for(ContentDocumentLink doc :triggerNew){
            ContentDocumentLinksIds.add(doc.ContentDocumentId);
        }
        List<ScannedItem__c> itemsToInsert = new List<ScannedItem__c>();
        List<ContentVersion> cvs = [select Id,Title,FileType, ContentSize from ContentVersion where ContentDocumentId in :ContentDocumentLinksIds];
        system.debug(cvs);
        for(ContentVersion cv :cvs){
            ContentVersionsIds.add(cv.Id);
        }

        system.debug(ContentVersionsIds);
        List<ScannedItem__c> items = [select Id, perceptionpoint__RecordId__c from ScannedItem__c where perceptionpoint__RecordId__c in :ContentVersionsIds];
        system.debug(items);
        if(items.size() == 0){
            for(ContentVersion cv : cvs){
                itemsToInsert.add(ScannedItemHandler.createScannedItem (fileType,cv.Id, cv.FileType, cv.ContentSize, cv.Title));
            }
        }
        else{
            for(ScannedItem__c item : items){
                for(ContentVersion cv : cvs){
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