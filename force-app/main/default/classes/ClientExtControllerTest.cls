@isTest
public class ClientExtControllerTest {
    @isTest
    static void testClientExtController() {
        // Create test data
        Client__c client1 = new Client__c(Name ='test1', Somme_payee__c = 100.00);
        Client__c client2 = new Client__c(Name ='test2',Somme_payee__c = 200.00);
        insert new List<Client__c>{client1, client2};

        // Set up a StandardSetController for the test
        List<Client__c> clients = [SELECT Id FROM Client__c];
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(clients);

        // Instantiate the controller
        ClientExtController controller = new ClientExtController(stdSetController);

        // Verify the total calculation
        Decimal expectedTotal = 300.00;
        System.assertEquals(expectedTotal, controller.total, 'The total sum of Somme_payee__c should be 300.00');
    }
}