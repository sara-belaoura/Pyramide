@IsTest
public class AP01_Ouvrier_Test {

    // Helper method to create test data
    
    @IsTest
    static void testEnvoyerEmailCreation() {
        // Start test
        Test.startTest();
        Test_Utils.createTestContacts(1);   //this method fill the field date de fin du contrat    
        
        Test.stopTest();

        // Verify email was sent
        System.assertEquals(1, Limits.getEmailInvocations(), 'Email should have been sent.');
    }

    
    @IsTest
    static void testEnvoyerEmailModification() {
        // Create test data
        List<Contact> contacts = Test_Utils.createTestContacts(1);        
        
        // Start test
        Test.startTest();
        contacts[0].Date_de_fin_du_Contrat__c = System.today().addDays(10);
        UPDATE contacts[0];
        Test.stopTest();

        // Verify email was sent
        System.assertEquals(1, Limits.getEmailInvocations(), 'Email should have been sent.');
    }

}



