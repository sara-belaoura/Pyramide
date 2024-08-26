trigger BatimentTrigger on Batiment__c (before insert, before update) {
    if(Trigger.isUpdate || Trigger.isInsert)
    {
        AP01_Batiment.attacherIngenieur(Trigger.new);
    }
}