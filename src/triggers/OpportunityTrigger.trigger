trigger OpportunityTrigger on Opportunity (before insert)
{
    // Apply 20 percent discount to new Opps
    for (Opportunity opp : Trigger.New)
    {
        if (opp.Quote__c != null)
        {
            opp.Quote__c = (opp.Quote__c * .80);
        }
    }
}
