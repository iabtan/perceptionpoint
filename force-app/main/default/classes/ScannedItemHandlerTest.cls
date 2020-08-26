@isTest
private class ScannedItemHandlerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<ScannedItem__c> items = new List<ScannedItem__c>();
        Set<String> itemIds = new Set<String>();
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
        for(ScannedItem__c item :items){
            itemIds.add(item.Id);
        }
        Test.setMock(HttpCalloutMock.class, new ScannedItemWSMock());
        Test.startTest();
        ScannedItemHandler.notifySystemOnNewFile(itemIds);
        Test.stopTest();
        List <ScannedItem__c> scItems = [Select perceptionpoint__FileName__c, Name From perceptionpoint__ScannedItem__c where perceptionpoint__SyncStatus__c ='Sent to Scan'];
	    system.assertEquals(scItems.size(), 200, 'Sync items Failed');  
    }
}