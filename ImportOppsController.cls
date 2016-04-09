public class ImportOppsController
{
	private Map<String, Id> accountMap;
	private List<Account> accounts;
	private Set<String> currentOpps;
	public List<Opportunity> oppys { get; set; }

	public ImportOppsController()
	{
		// On page load, get all accounts.
		accounts = [
			SELECT Id, Name, Trade_Style__c, Year_Started__c, Photo_URL__c, Website,
				BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
			FROM Account
			ORDER BY Name ASC
		];

		populateAccountMap();
		populateOpportunities();
	}

	public void populateAccountMap()
	{
		// Add account Ids to a map to get later for oppys
		accountMap = new Map<String, Id>();

		for (Account ac : accounts)
		{
			if (!accountMap.containsKey(ac.Name))
			{
				accountMap.put(ac.Name, ac.Id);
			}
		}
	}

	public void populateOpportunities()
	{
		oppys = new List<Opportunity>();
		currentOpps = new Set<String>();

		oppys = [
			SELECT Id, Account.Name, Account.Id, Name,
				Account.BillingStreet, Account.BillingCity,
				Account.BillingState, Account.BillingPostalCode,
				Amount, AccountId, Quote__c
			FROM Opportunity
			ORDER BY Name ASC
		];

		for (Opportunity opp : oppys)
		{
			currentOpps.add(opp.Name);
		}
	}

	public void getOppsFromServer()
	{
		Opportunity tempOpp = new Opportunity();
		List<Opportunity> oppsToInsert = new List<Opportunity>();
		String baseURL = 'https://superman-caves.herokuapp.com/opportunities';

    	Http http = new Http();
    	HttpRequest req = new HttpRequest();
    	req.setEndpoint(baseURL);
    	req.setMethod('GET');

    	HttpResponse res = http.send(req);

		if (res.getBody() != '')
		{
			Set<String> dupeNameSet = new Set<String>();
			JSONParser parser = JSON.createParser(res.getBody());

	        while (parser.nextToken() != null)
			{
		        if (parser.getCurrentToken() == JSONToken.START_ARRAY)
				{
		            while (parser.nextToken() != null)
					{
		                if (parser.getCurrentToken() == JSONToken.START_OBJECT)
						{
							tempOpp = new Opportunity();
							parser.nextToken();

							while (parser.getCurrentToken() == JSONToken.FIELD_NAME)
							{
								String key = parser.getText();
								parser.nextToken();
								String value = parser.getText();

								if (key == 'amount')
								{
									tempOpp.Amount = Decimal.valueOf(value);
								}
								else if (key == 'description')
								{
									tempOpp.Description = value;
								}
								else if (key == 'forecastcategoryname')
								{
									tempOpp.ForecastCategoryName = value;
								}
								else if (key == 'leadsource')
								{
									tempOpp.LeadSource = value;
								}
								else if (key == 'name')
								{
									tempOpp.Name = value.replace('\n', '');
								}
								else if (key == 'nextstep')
								{
									tempOpp.NextStep = value;
								}
								else if (key == 'probabliity')
								{
									tempOpp.Probability = Decimal.valueOf(value);
								}
								else if (key == 'quote')
								{
									tempOpp.Quote__c = Decimal.valueOf(value);
								}
								else if (key == 'stagename')
								{
									tempOpp.StageName = value;
								}
								else if (key == 'type')
								{
									tempOpp.Type = value;
								}

								parser.nextToken();

								if (parser.getCurrentToken() == JSONToken.END_OBJECT)
								{
									// Check if opp is not already in db or list to insert.
									if (!dupeNameSet.contains(tempOpp.Name)
										&& !currentOpps.contains(tempOpp.Name))
									{
										// Add name to set for dupe checking later
										dupeNameSet.add(tempOpp.Name);

										tempOpp.AccountId = accountMap.get(tempOpp.Name);
										tempOpp.CloseDate = Date.Today() + 365;

										oppsToInsert.add(tempOpp);
									}
								}
							}
		                }
		            }
		        }
		    }

			if (oppsToInsert.size() > 0)
			{
				try
				{
					insert oppsToInsert;
				}
				catch (Exception e)
				{
					ApexPages.addMessage(
						new ApexPages.Message(
							ApexPages.severity.INFO,
							'<div class="alert alert-danger">' + e.getMessage() + '</div>'
						)
					);
				}

				// After insertion re-query for opps to display on page.
				populateOpportunities();

				ApexPages.addMessage(
					new ApexPages.Message(
						ApexPages.severity.INFO,
						'<div class="alert alert-success">' +
							'Successfully imported ' + oppsToInsert.size() + ' opportunities.' +
						'</div>'
					)
				);
			}
			else
			{
				ApexPages.addMessage(
					new ApexPages.Message(
						ApexPages.severity.INFO,
						'<div class="alert alert-info">No new opportunities found to import.</div>'
					)
				);
			}
		}
	}
}
