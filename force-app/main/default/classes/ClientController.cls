public with sharing class ClientController {
    @AuraEnabled(cacheable=true)
        public static List<Client__c> getClients() {
        return [SELECT Id, Name, Numero_appartement_Achete__c, Batiment__r.Name, Batiment__r.Id,
        Date_achat__c, Somme_payee__c FROM Client__c];
        }
}