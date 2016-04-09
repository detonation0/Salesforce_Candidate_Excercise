# Salesforce_Excercise

#### Mat's Notes
Just some FYI's for my submission:
* There are 7 duplicate Account names in the provided .csv. I'm assuming that they were meant to be unique to match the Opportunities exactly. So as of now, there are only 493 Opportunities being imported.
* The code checks the current database for Opportunities that already exist, this prevents a user from clicking the button multiple times and creating duplicate Opportunities for each Account.
  * There is also a check in there that prevents any duplicate Opportunities from being added to the List for insertion (handling for problem in first bullet).
* The web service returns the 'probability' key as 'probabliity'. So I've adjusted my code for that just so it imports correctly.

Included Files:
* `ImportOppsController.cls`
* `SingleRequestMock.cls`
* `Test_ImportOppsController.cls`
* `importOpps.page`
* `OpportunityTrigger.trigger`

Code Coverage:
* `Test_ImportOppsController.cls` - 90%
* `OpportunityTrigger.trigger` - 100%

This document will explain the requirements and all relevant to complete the salesforce programming exercise you have been given

#### Rules
> The rules for this challenge are as follows. Have fun. Read the user story and create a solution the meets the acceptance criteria. It's preferable that you create a new developer org. Your code will need to be submitted through github. Other than that the entire challenge design is up to you.

### Background
> I am a sales member of Kryptonite LLC and we are just acquired ExtremeSupermanCaves LLC. As a company we are looking to migrate all of their accounts and sales opportunities to our Salesforce Platform. ExtremeSupermanCaves have provided us with a CSV that includes all of their accounts. However, due to compliance issues they cannot provide us a file of the sales opportunities associated with those accounts. They have exposed a web service for us to consume that allows us to get the associated opportunities based on account name. Their opportunities have a quote attribute that our opportunities do not have; we will need to account for that.Their opportunities have a price attribute that our opportunities do not have. In addition, we want to give the Opportunities a discount on their existing quote of 20%.


### User Story
> As a sales user I need to import these accounts using the salesforce import utility and have a page that I can go get all the associated opportunities and links to the account using the account Name and then apply the discount. Once they are imported I would like them to show up on the page with The Account Name, Opportunity Name, Location, and Price.

### Acceptance Criteria
> * All 500 accounts will be imported (via supplied challengeAccounts.csv)
* Every account will have to have an associated opportunity retrieved from the supplier (via supplied REST API)
* Using a trigger when a new opportunity is created a discount of 20% should be applied to the quote amount
* A new field will be added to the opportunity that will contain the quote
* This functionality must be able to be deployed to production with test coverage done
* Submit your code through github

### Api Documentation
[Rest Api Documentation](SalesforceRestApi.md)
