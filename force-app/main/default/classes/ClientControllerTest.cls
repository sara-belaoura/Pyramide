@isTest
public class ClientControllerTest {
    @isTest
    static void testGetClients() {
        // Create test data
        Batiment__c[] batiments = Test_Utils.createBatiments(1,true);

        
        Client__c client1 = new Client__c(
            Name = 'Client 1',
            Numero_appartement_Achete__c =  12,
            Batiment__c = batiments[0].Id,
            Date_achat__c = Date.today(),
            Somme_payee__c = 100.00
        );
        
        Client__c client2 = new Client__c(
            Name = 'Client 2',
            Numero_appartement_Achete__c = 13,
            Batiment__c = batiments[0].Id,
            Date_achat__c = Date.today().addDays(-1),
            Somme_payee__c = 200.00
        );
        
        insert new List<Client__c>{client1, client2};
        
        // Call the method to test
        Test.startTest();
        List<Client__c> clients = ClientController.getClients();
        Test.stopTest();
        
        // Verify the results
        System.assertEquals(2, clients.size(), 'Two clients should be returned');
    }
}