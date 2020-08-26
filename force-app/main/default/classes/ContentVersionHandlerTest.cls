@IsTest
private class ContentVersionHandlerTest {
    
    static testMethod void testNewFile(){
    	
		List<ContentVersion> cvs = new List<ContentVersion>();
		for(Integer i=0;i<50;i++) {

			ContentVersion cont = new ContentVersion();

			cont.Title = 'Title for this contentVersion';
			cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.txt';
			cont.VersionData = Blob.valueOf('My Content in file_' + Datetime.now().getTime() + '.txt');
			cont.Origin = 'H';
			cvs.add(cont);
		}
		insert cvs;
		List <ScannedItem__c> items = [Select perceptionpoint__FileName__c, Name 
                                       From perceptionpoint__ScannedItem__c where perceptionpoint__FileName__c ='Title for this contentVersion'];
	    system.assertEquals(items.size(), 50, 'Sync Failed');  
		//system.debug(items.size());
    }
}