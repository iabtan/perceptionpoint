@IsTest
private class ContentVersionHandlerTest {
    
    static testMethod void testNewFile(){
    	
		
		
		ContentVersion cont = new ContentVersion();

		cont.Title = 'Title for this contentVersion';
	    cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.txt';
	    cont.VersionData = Blob.valueOf('My Content in file_' + Datetime.now().getTime() + '.txt');
	    cont.Origin = 'H';
		insert cont;
    }
    
    
    
}