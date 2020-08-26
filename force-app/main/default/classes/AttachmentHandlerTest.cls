@IsTest
private class AttachmentHandlerTest {
    static testMethod void testNewAttachment(){
		List<Attachment> attachments = new List<Attachment>();
	    Account acc = new Account(Name= 'Test');
		insert acc;
		for(Integer i=0;i<200;i++)
		{
			Attachment att = new Attachment ();
			att.ParentId  = acc.Id;
			att.Name = 'Title for this attachment';
			att.Body = Blob.valueOf('My Content in file_' + Datetime.now().getTime() + '.txt');
			attachments.add(att);
		}
		insert attachments;
		List <ScannedItem__c> items = [Select perceptionpoint__FileName__c, Name From perceptionpoint__ScannedItem__c where perceptionpoint__FileName__c ='Title for this attachment'];
	    system.assertEquals(items.size(), 200, 'Sync items Failed');  
		//system.debug(items.size() +'comptes crées');
    }
}