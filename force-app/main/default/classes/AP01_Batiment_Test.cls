@IsTest
public class AP01_Batiment_Test {    


    @IsTest
    static void testAttacherIngenieur() {
        Test_Utils.createIngenieurs(3);
        // Call the method under test
        Test.startTest();
        List<Batiment__c> batiments = Test_Utils.createBatiments(3,false);
        Test.stopTest();
        
        // Verify that engineers have been attached to the buildings
        batiments = [SELECT Id, Ingenieur_de_Realisation__c FROM Batiment__c WHERE Id IN :batiments];
        for (Batiment__c batiment : batiments) {
            System.assertNotEquals(null, batiment.Ingenieur_de_Realisation__c, 'Un ingenieur doit etre attaché au batiment');
        }
    }


    @IsTest
    static void testNoActionForAlreadyAttached() {
        
        Test.startTest();
        List<Batiment__c> batiments = Test_Utils.createBatiments(1,true);
        Test.stopTest();
        
        // Verify that the existing engineer has not been changed
        Batiment__c[] batimentApres = [SELECT Ingenieur_de_Realisation__c FROM Batiment__c WHERE Id = :batiments[0].Id];
        System.assertEquals(batiments[0].Ingenieur_de_Realisation__c, batimentApres[0].Ingenieur_de_Realisation__c, 'Ingenieur ne doit pas etre modifié');
    }


    
}





