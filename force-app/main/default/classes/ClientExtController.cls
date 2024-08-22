public with sharing class ClientExtController {
    public Decimal total{get; set;}
  
    public ClientExtController(ApexPages.StandardSetController controller) {
        List<AggregateResult> result = [SELECT SUM(Somme_payee__c) total FROM Client__c];
        this.total = (Decimal) result[0].get('total');

    }
}