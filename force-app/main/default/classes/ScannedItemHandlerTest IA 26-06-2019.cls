@isTest
private class ScannedItemHandlerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<ScannedItem__c> items = new List<ScannedItem__c>();
        for(Integer i=0;i<200;i++) {
            ScannedItem__c item = new ScannedItem__c();
            item.SyncStatus__c = 'New';
            item.Type__c = 'File';
            item.RecordId__c = '';
            item.FileSize__c = 100;
            item.FileType__c = 'pdf';
            items.add(item);
        }
        insert items;
    
    }
}