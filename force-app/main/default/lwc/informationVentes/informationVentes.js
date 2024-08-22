import { LightningElement } from 'lwc';
import getClients from '@salesforce/apex/ClientController.getClients';
import { wire, track } from 'lwc';

export default class InformationVentes extends LightningElement {

    @track clients = [];
    @track total =0;
    @track columns;
    @wire(getClients) wiredClients({data,error}){
        if (data) {
            this.columns = [
                { label: 'Numéro d\'appartement acheté', fieldName: 'Numero_appartement_Achete__c' },
                { label: 'Bâtiment', fieldName: 'Batiment__r_Url', type: 'url', typeAttributes: { label: { fieldName: 'Batiment__r_Name' }, target: '_blank' } },
                { label: 'Nom de l\'acheteur', fieldName: 'NameUrl', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } },
                { label: 'Date d\'achat', fieldName: 'Date_achat__c' },
                { label: 'Somme payée', fieldName: 'Somme_payee__c' }
            ];
           
              for (const record of data) {
                this.clients.push({
                    Numero_appartement_Achete__c: record.Numero_appartement_Achete__c,
                    Batiment__r_Name: record.Batiment__r.Name,
                    Batiment__r_Url: `/${record.Batiment__r.Id}`,
                    Name: record.Name,
                    NameUrl : `/${record.Id}`,
                    Date_achat__c: record.Date_achat__c,
                    Somme_payee__c: record.Somme_payee__c
                });
                this.total += record.Somme_payee__c;
            }
        } else if (error) {
         console.log(error);
        
        }
    }

 
    

}