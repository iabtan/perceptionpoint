public with sharing class ContentDocumentLinkHandler {
    public static void createScannedItem(List<ContentDocumentLink> triggerNew) {
        List<String> ScannedItemsIds = new List<String>();
        for(ContentDocumentLink doc :triggerNew){
            ScannedItemsIds.add(doc.ContentDocumentId);
        }
        List<ScannedItem__c> items = [select Id from ScannedItem__c where Id in :ScannedItemsIds];
        List<ContentVersion> cvs = [select Id,Title,FileType from ContentVersion where Id in :ScannedItemsIds];
        if(items.size() == 0){
            for(ContentVersion cv :cvs){
                items.add(ScannedItemHandler.createScannedItem (cv.FileType,cv.Id, cv.FileType, cv.ContentSize, cv.Title));
            }
        }
        else{
            for(ScannedItem__c item : items){
                for(ContentVersion cv : cvs){
                    if(cv.Title != item.Name) {
                        items.add (ScannedItemHandler.createScannedItem (cv.FileType,cv.Id, cv.FileType, cv.ContentSize, cv.Title));
                    }
                }
            }
        }
        insert items;
    }
}