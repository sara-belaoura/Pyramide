public without sharing class AP01_Batiment {
    public static void attacherIngenieur(Batiment__c[] batiments) {
        List<Batiment__c> batimentsValides = new List<Batiment__c>();            
        // Collecte des bâtiments sans ingénieur assigné
        for(Batiment__c batiment : batiments) {
            if (batiment.Ingenieur_de_Realisation__c == null) {
                batimentsValides.add(batiment);
            }           
        }
        
        if (batimentsValides.size() > 0) {
            // Récupérer tous les ingénieurs disponibles
            List<Account> ingenieursDisponibles = [
                SELECT Id, Disponible__c 
                FROM Account 
                WHERE Disponible__c = true 
                LIMIT :batimentsValides.size()
            ];
            
            if (ingenieursDisponibles.size() == 0) {
                // Aucun ingénieur disponible
                System.debug('Aucun ingénieur disponible.');
                return;
            }
            
            // Mapper les ingénieurs disponibles aux bâtiments
            for (Integer i = 0; i < batimentsValides.size() && i < ingenieursDisponibles.size(); i++) {
                
                // Attacher l'ingénieur au bâtiment
                batimentsValides[i].Ingenieur_de_Realisation__c = ingenieursDisponibles[i].Id;
                
                // Marquer l'ingénieur comme non disponible
                ingenieursDisponibles[i].Disponible__c = false;
            }
            
            
            // Mettre à jour les ingénieurs pour les marquer comme non disponibles
            update ingenieursDisponibles;
            
            System.debug('Les ingénieurs ont été assignés et mis à jour.');
        }
    }
}
