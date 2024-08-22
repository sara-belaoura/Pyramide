public without sharing class AP01_Batiment {
    public static void attacherIngenieur(Batiment__c[] batiments) {
        Batiment__c[] batimentsValides = new List<Batiment__c>();
            
           for(Batiment__c batiment : batiments)
            {
                // Vérifier si le bâtiment est déjà rattaché à un ingénieur
                if (batiment.Ingenieur_de_Realisation__c == null) {
                    batimentsValides.add(batiment);
                }           
            }
            Map<Id,Account> mapBatimentToIngenieur = new Map<Id,Account>();
           
            if(batimentsValides.size()>0){
                 //Récupérer le RecordTypeId du compte personnel
                Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
                Integer i=0;
                for(Batiment__c batiment : batimentsValides){
                    // Créer un nouvel ingénieur
                    Account nouvelIngenieur = new Account(LastName='Ingenieur'+i,RecordTypeId=personAccountRecordTypeId);
                    mapBatimentToIngenieur.put(batiment.id,nouvelIngenieur);
                    i++;
                }
                insert mapBatimentToIngenieur.values();
                System.debug('Ingenieurs insérés : '+mapBatimentToIngenieur.values());
    
                 // Attacher les ingénieurs au bâtiments
                for(Batiment__c batiment : batimentsValides){
                    System.debug(batiment.Ingenieur_de_Realisation__c);
                    batiment.Ingenieur_de_Realisation__c = mapBatimentToIngenieur.get(batiment.id).Id;
                }
               
                
                
                
                
    
                
                
            }

    }

}