@IsTest
public class AP01_Ouvrier_Test {

    // Helper method to create test data
    @IsTest
    static void testEnvoyerEmailCreation() {
        // Start test
        Test.startTest();
        Integer initialEmailInvocations = Limits.getEmailInvocations();
        Test_Utils.createTestContacts(1);   //this method fill the field date de fin du contrat            
        Test.stopTest();
        // Verify email was sent
        Integer emailInvocations = Limits.getEmailInvocations() - initialEmailInvocations;
        System.assertEquals(1, emailInvocations, 'One email should have been sent on insert.');
    }
   
    @IsTest
    static void testEnvoyerEmailModification() {
        // Create test data
        List<Contact> contacts = Test_Utils.createTestContacts(1);     
        contacts[0].Date_de_fin_du_Contrat__c = System.today().addDays(10);
        // Start test
        Test.startTest();
        Integer initialEmailInvocations = Limits.getEmailInvocations();
        UPDATE contacts[0];
        Test.stopTest();
        // Verify email was sent
        // Verify that the trigger executed and an email was sent
        Integer emailInvocations = Limits.getEmailInvocations() - initialEmailInvocations;
        System.assertEquals(1, emailInvocations, 'One email should have been sent on update.');
    }

}



