trigger OuvrierTrigger on Contact (after insert, after update) {

    if(Trigger.isInsert)
    {
        AP01_Ouvrier.envoyerEmail(Trigger.new, new Map<Id,Contact>());

    }
    if (Trigger.isUpdate) {
        
        AP01_Ouvrier.envoyerEmail(Trigger.new, Trigger.oldMap);
    }
    

}