
public without sharing class AP01_Ouvrier {
    public static void envoyerEmail(Contact[] ouvriers, Map<Id,Contact> oldOuvriers) {
        // Map to hold OwnerId to User email mapping
        Map<Id, String> ownerEmailMap = new Map<Id, String>();
        
        // Set to collect unique OwnerIds
        Set<Id> ownerIds = new Set<Id>();
        
        // Collect OwnerIds from the contacts
        for (Contact ouvrier : ouvriers) {
            if (oldOuvriers.size()>0) { // Coming from an update
                System.debug('Coming from update');
                if(ouvrier.Date_de_fin_du_Contrat__c != oldOuvriers.get(ouvrier.Id).Date_de_fin_du_Contrat__c ){
                    //if there is a change in date field
                    System.debug('There is a change in date field');
                    ownerIds.add(ouvrier.OwnerId);

                }
            }
            //Coming from an insert
            else if(ouvrier.Date_de_fin_du_Contrat__c!=null){ 
                System.debug('Coming from insert and date field is filled');
                    ownerIds.add(ouvrier.OwnerId);
                }                
            
        }
        
        // Query to get the emails of the owners
        List<User> owners = [SELECT Id, Email FROM User WHERE Id IN :ownerIds];
        
        // Populate the map with OwnerId and Email
        for (User owner : owners) {
            ownerEmailMap.put(owner.Id, owner.Email);
        }
        
        // List to collect emails to be sent
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        // Create email messages for each owner
        for (Id ownerId : ownerEmailMap.keySet()) {
            String ownerEmail = ownerEmailMap.get(ownerId);
            if (ownerEmail != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { ownerEmail });
                email.setSubject('Notification de changement de la Date de Fin du Contrat');
                email.setPlainTextBody('La Date de Fin du Contrat pour l\'ouvrier a été modifiée.');
                emailsToSend.add(email);
            } else {
                System.debug('Le propriétaire avec l\'ID ' + ownerId + ' n\'a pas d\'adresse email.');
            }
        }
        try {
            // Send all emails in one go
            if (!emailsToSend.isEmpty()) {
                System.debug('Sending the email ...');
                Messaging.sendEmail(emailsToSend);
            }
            
        } catch (System.EmailException ex) {
            System.debug('Erreur d\'envoi du mail: ' + ex.getMessage());
        
            
        }
    }
    
   

    
}