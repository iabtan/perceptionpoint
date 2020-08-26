public with sharing class FLSUtils {
    
    static Map<String,Schema.SObjectField> scannedItemFieldsMap = Schema.SObjectType.ScannedItem__c.fields.getMap();

    public static Boolean checkUpdatableFields(String [] fields){
		for (String fieldToCheck : fields)  {
			if (!scannedItemFieldsMap.get(fieldToCheck).getDescribe().isUpdateable())   {
        		return false;
            }
        }
        return true;
	}

  public static Boolean checkCreatableFields(String [] fields){
		for (String fieldToCheck : fields)  {
			if (!scannedItemFieldsMap.get(fieldToCheck).getDescribe().isCreateable())   {
            System.debug(fieldToCheck);
        		return false;
            }
        }
        return true;
	}
}