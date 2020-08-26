trigger AttachmentTrigger on Attachment (after insert) {

	AttachmentHandler.createScannedItem(trigger.new);
}