@isTest
private class Test_ImportOppsController
{
	@testSetup static void setUpData()
	{
		List<Account> testAccounts = new List<Account>();

		// Create some test accounts.
		for (Integer i = 0; i < 5; i++)
		{
			Account tempAccount = new Account(
				Name = 'Some account' + i,
				Type = 'Prospect'
			);

			testAccounts.add(tempAccount);
		}

		// Rename three of them to match the test data
		testAccounts[0].Name = 'Kovacek Inc';
		testAccounts[1].Name = 'Yundt, Robel and Beier';
		testAccounts[2].Name = 'Walter, Schultz and Prohaska';

		insert testAccounts;
	}

	@isTest static void testCallout()
	{
		// Create the json fakeresponse string
		String jsonTestString = '' +
			'[' +
			  	'{' +
			    	'"amount": 9719437418,' +
			    	'"created_at": "2016-04-06 18:24:12.69409",' +
			    	'"description": "Odio fugiat quia unde quia nesciunt dolor consequuntur.' +
					'temporibus. Molestiae sed vel distinctio facere dolores.",' +
			    	'"expectedrevenue": 8316657792,' +
			    	'"forecastcategoryname": "Pipeline",' +
			    	'"id": 3,' +
			    	'"leadsource": "Web",' +
			    	'"name": "Kovacek Inc",' +
			    	'"nextstep": "Seamless multimedia array",' +
			    	'"probabliity": 73,' +
			    	'"quote": 76446,' +
			    	'"stagename": "Needs Analysis",' +
			    	'"type": "New Customer",' +
			    	'"updated_at": "2016-04-06 18:24:12.694091"' +
			  	'},' +
			  	'{' +
			    	'"amount": 8377807456,' +
			    	'"created_at": "2016-04-06 18:24:12.697731",' +
			    	'"description": "Voluptatem numquam harum omnis libero eius. Omnis distinc' + 'ullam et illo optio quia et. Perferendis ab ea impedit est. Libero nesciu' + 'facilis eum illum neque sed rerum.",' +
			    	'"expectedrevenue": 5095214310,' +
			    	'"forecastcategoryname": "Pipeline",' +
			    	'"id": 14,' +
			    	'"leadsource": "Phone Inquiry",' +
			    	'"name": "Yundt, Robel and Beier",' +
			    	'"nextstep": "Intuitive content-based secured line",' +
			    	'"probabliity": 41,' +
			    	'"quote": 21860,' +
			    	'"stagename": "Qualification",' +
			    	'"type": "New Customer",' +
			    	'"updated_at": "2016-04-06 18:24:12.697733"' +
			  	'},' +
			  	'{' +
			    	'"amount": 1278274971,' +
			    	'"created_at": "2016-04-06 18:24:12.698017",' +
			    	'"description": "Dolor dolores blanditiis. Hic modi exercitationem vel iste' + 'sit. Animi nostrum velit explicabo doloremque. Excepturi ratione sint pro' + 'repudiandae recusandae. Dignissimos vel non.",' +
			    	'"expectedrevenue": 8382971873,' +
			    	'"forecastcategoryname": "Commit",' +
			    	'"id": 15,' +
			    	'"leadsource": "Phone Inquiry",' +
			    	'"name": "Walter, Schultz and Prohaska",' +
			    	'"nextstep": "Sharable directional definition",' +
			    	'"probabliity": 81,' +
			    	'"quote": 17465,' +
			    	'"stagename": "Needs Analysis",' +
			    	'"type": "New Customer",' +
			    	'"updated_at": "2016-04-06 18:24:12.698019"' +
			  	'}' +
			']';

		SingleRequestMock fakeResponse = new SingleRequestMock(
			200,
			'Complete',
			jsonTestString,
			null
		);

		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();

		ImportOppsController ioc = new ImportOppsController();
		ioc.getOppsFromServer();

		Test.stopTest();

		// Check Kovacek Inc quote based off jsonString test data
		Decimal kovacekQuote = 76446;
		// Discount original quote manually for assert
		kovacekQuote = (kovacekQuote * .80);

		List<Opportunity> oppList = [
			SELECT Id, Quote__c
			FROM Opportunity
		];

		List<Opportunity> kovacek = [
			SELECT Id, Quote__c
			FROM Opportunity
			WHERE Name = 'Kovacek Inc'
		];

		List<Apexpages.Message> msgs = ApexPages.getMessages();
		Boolean isPresent = false;

		for (Apexpages.Message msg : msgs)
		{
		    if (msg.getDetail().contains('<div class="alert alert-success">Successfully'))
			{
				isPresent = true;
			}
		}

		System.assert(isPresent);
		System.assertEquals(oppList.size(), 3);
		System.assertEquals(kovacekQuote, kovacek[0].Quote__c);
	}
}
