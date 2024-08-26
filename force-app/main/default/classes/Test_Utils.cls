public with sharing class Test_Utils {
    /**
     * Helper method to create test data for Batiment and Account (engineer).
     */
    public static List<Batiment__c> createBatiments(Integer numberOfBatiments, Boolean avecIngenieur) {
        List <Village__c> villages = new List<Village__c>();
        for (Integer i = 0; i < numberOfBatiments; i++) {
            Village__c ville = new Village__c(Name='Village '+i);
            villages.add(ville);
        }
        insert villages;

        List<Batiment__c> batiments = new List<Batiment__c>();
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Account ingenieur = new Account(LastName = 'Existing Ingenieur', RecordTypeId = personAccountRecordTypeId);
      
        if(avecIngenieur==true){
             insert ingenieur;
        }
        // Create buildings without engineers attached
        for (Integer i = 0; i < numberOfBatiments; i++) {
            Batiment__c batiment = new Batiment__c(Village_Associe__c = villages[i].Id);
            if(avecIngenieur==true){
                batiment.Ingenieur_de_Realisation__c = ingenieur.Id;
            }
            batiments.add(batiment);
        }
        insert batiments;


        return batiments;
    }
    public static List<Account> createIngenieurs(Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account acc = new Account(LastName = 'Ingenieur ' + i, RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(), Disponible__c =true);
            accounts.add(acc);
        }
        insert accounts;
        return accounts;
    }

    public static List<Contact> createTestContacts(Integer numberOfContacts) {
        Id profileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id;

        // Create a list of test contacts
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < numberOfContacts; i++) {
            contacts.add(new Contact(
                FirstName = 'First' + i,
                LastName = 'Last' + i,
                Date_de_fin_du_Contrat__c = Date.today().addMonths(12)
            ));
        }
        insert contacts;
        System.debug('inserted these contacts' + contacts);

        return contacts;
    }

}