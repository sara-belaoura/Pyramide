public without sharing class AP01_Ouvrier {
    public static void envoyerEmail(Contact[] ouvriers, Map<Id, Contact> oldOuvriers) {
        // Map to hold OwnerId to User email mapping
        Map<Id, String> ownerEmailMap = new Map<Id, String>();

        // Set to collect unique OwnerIds
        Set<Id> ownerIds = new Set<Id>();

        // Collect OwnerIds from the contacts
        for (Contact ouvrier : ouvriers) {
            if (oldOuvriers.size() > 0) { // Coming from an update
                System.debug('Coming from update');
                if (ouvrier.Date_de_fin_du_Contrat__c != oldOuvriers.get(ouvrier.Id).Date_de_fin_du_Contrat__c) {
                    // if there is a change in date field
                    System.debug('There is a change in date field');
                    ownerIds.add(ouvrier.OwnerId);
                }
            }
            // Coming from an insert
            else if (ouvrier.Date_de_fin_du_Contrat__c != null) { 
                System.debug('Coming from insert and date field is filled');
                ownerIds.add(ouvrier.OwnerId);
            } else {
                // Handle cases where the Date_de_fin_du_Contrat__c field is not populated on insert
                System.debug('Date_de_fin_du_Contrat__c field is not populated for inserted contact');
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

        // Base URL of the Salesforce organization
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();

        // Create email messages for each owner
        for (Contact ouvrier : ouvriers) {
            String ownerEmail = ownerEmailMap.get(ouvrier.OwnerId);
            if (ownerEmail != null) {
                if (oldOuvriers.containsKey(ouvrier.Id) && 
                    ouvrier.Date_de_fin_du_Contrat__c != oldOuvriers.get(ouvrier.Id).Date_de_fin_du_Contrat__c) {
                    // Handle updated contacts
                    String recordLink = baseUrl + '/' + ouvrier.Id;
                    
                    // Create the email body with worker details
                    String emailBody = 'Bonjour,<br/><br/>' +
                    'La Date de Fin du Contrat pour l\'ouvrier suivant a été modifiée :<br/><br/>' +
                    'Nom de l\'ouvrier : <a href="' + recordLink + '">' + ouvrier.FirstName + ' ' + ouvrier.LastName + '</a><br/>' +
                    'Nouvelle Date de Fin du Contrat : ' + ouvrier.Date_de_fin_du_Contrat__c + '<br/><br/>' +
                    'Cordialement,<br/>Votre système Salesforce';

                    // Create the email
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { ownerEmail });
                    email.setSubject('Notification de changement de la Date de Fin du Contrat');
                    email.setHTMLBody(emailBody);
                    emailsToSend.add(email);

                } else if (!oldOuvriers.containsKey(ouvrier.Id) && 
                           ouvrier.Date_de_fin_du_Contrat__c != null) {
                    // Handle inserted contacts with populated Date_de_fin_du_Contrat__c
                    String recordLink = baseUrl + '/' + ouvrier.Id;
                    
                    // Create the email body with worker details
                    String emailBody = 'Bonjour,<br/><br/>' +
                    'La Date de Fin du Contrat pour l\'ouvrier suivant a été renseignée :<br/><br/>' +
                    'Nom de l\'ouvrier : <a href="' + recordLink + '">' + ouvrier.FirstName + ' ' + ouvrier.LastName + '</a><br/>' +
                    'Date de Fin du Contrat : ' + ouvrier.Date_de_fin_du_Contrat__c + '<br/><br/>' +
                    'Cordialement,<br/>Votre système Salesforce';

                    // Create the email
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { ownerEmail });
                    email.setSubject('Notification de renseignement de la Date de Fin du Contrat');
                    email.setHTMLBody(emailBody);
                    emailsToSend.add(email);
                } else if (ouvrier.Date_de_fin_du_Contrat__c == null) {
                    System.debug('Date de fin du contrat non renseignée pour l\'ouvrier avec ID : ' + ouvrier.Id);
                } else {
                    System.debug('Le propriétaire avec l\'ID ' + ouvrier.OwnerId + ' n\'a pas d\'adresse email ou aucun changement de date.');
                }
            }
        }

        try {
            // Send all emails
            if (!emailsToSend.isEmpty()) {
                System.debug('Envoi des emails...');
                Messaging.sendEmail(emailsToSend);
            }
        } catch (System.EmailException ex) {
            System.debug('Erreur d\'envoi du mail : ' + ex.getMessage());
        }
    }
}
