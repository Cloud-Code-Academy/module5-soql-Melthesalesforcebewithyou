/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Melissa Villanueva
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
      List<Lead> leads = [
        SELECT 
            Id, 
            LastName, 
            Company, 
            Phone, 
            Email 
        FROM Lead
        ];

      return leads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName (String firstName) {
        List<Contact> contacts = [
            SELECT FirstName, LastName
            FROM Contact
            WHERE FirstName = :firstName
        ];
      return contacts;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName () {
      List<Contact> contacts = [
        SELECT Id, LastName
        FROM Contact
        WHERE LastName IN ('Smith', 'Jones')
      ];
      List<Id> idsForSmithOrJones = new List<Id>();
      for (Contact c : contacts){
        idsForSmithOrJones.add(c.Id);
      }
      return idsForSmithOrJones;
      }
      

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount (Id accountId) {
      //body of method
      List<Opportunity> closedWonOpp = [
        SELECT Name, StageName, CloseDate, AccountId, Amount
        FROM Opportunity
        WHERE AccountId = :accountId AND StageName = 'Closed Won'
      ];
      //return list of Opportunities
        return closedWonOpp;
    } 

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount () {
        //Body of method, return Count of Account records using COUNT() in SOQL query via Aggregrate Result 
        List<AggregateResult> results = [
        SELECT COUNT(Id) totalCount
        FROM Account
        ];
        Integer countOfAccounts = (Integer) results[0].get('totalCount');
        //Return list with summation of Account records 
        return countOfAccounts; 
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek () {
      // Variable to hold date range
      Date today = Date.today(); 
      Date endDate = today.addDays(7);  
      //SOQL query to retrieve Task records due within the next 7 days 
      List<Task> tasksDueNextWeekList = [
        SELECT Id, Subject, ActivityDate
        FROM Task
        WHERE ActivityDate >= :today AND ActivityDate <= :endDate
      ];
      //Initialize map to hold store Task Ids and Task records 
      Map<Id, Task> taskMap = new Map<Id, Task>(); 
      //For each in the List, add to the Map 
      for (Task t : tasksDueNextWeekList) {
        taskMap.put(t.Id, t);
      }
      //Return the populated  Map<Id, Task> key value pair 
      return taskMap; 
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain () {
      //SOQL query to retrieve Contact records WHERE filter based on email address containing 'example.com' domain 
      List<Contact> contactsByEmailDomain = [
        SELECT Name, Email
        FROM Contact
        WHERE Email LIKE '%example.com'
      ];
      //Return list of Contact records 
      return contactsByEmailDomain;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        //List of Opp + SOQL query WHERE Name contains the keyword concantenated 
        String keywordHolder = '%' + keyword + '%';
        List<Opportunity> oppWithKeywordList = [
            SELECT Name, StageName, CloseDate, AccountId
            FROM Opportunity
            WHERE Name LIKE :keywordHolder
        ];
        //return List of Opp 
        return oppWithKeywordList; 
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        //SOQL query to retrieve Cases WHERE Case Origin != Web, Email, or null/blank
        List<Case> filteredCaseList = [
            SELECT Status, AccountId, Origin
            FROM Case
            WHERE Origin NOT IN('Web', 'Email') AND Origin != NULL
        ];
        //return List of Cases 
        return filteredCaseList; 
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String keyword) {
      //Define method parameter keyword's format for SOQL
      String keywordHolder = '%' + keyword + '%';
      //Retrieve Leads with specified Lead Source OR contains keyword in their Title 
      List<Lead> leadSourceOrTitleList = [
        SELECT LastName, Company, Phone, Email, LeadSource, Title
        FROM Lead
        WHERE LeadSource = :leadSource OR Title LIKE :keywordHolder
      ];
      //return List of Leads
      return leadSourceOrTitleList;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();

        // Query the Contacts
        List<Contact> contacts = [
            SELECT LastName
            FROM Contact
            WHERE AccountId = :accountId
        ];

        // Loop through each Contact and add the LastName to the list
        for (Contact c : contacts) {
            contactLastNames.add(c.LastName);
        }
        // Return the list of Contact LastNames
        return contactLastNames;
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        //Initialize a variable to store the total revenue 
        Decimal totalRevenue = 0;
        // Use AggregateQuery to get the total revenue via SOQL query SUM(Amount) filter StageName OR Amount > 10000
        AggregateResult[] groupedResults = [
            SELECT SUM(Amount) totalRevenue
            FROM Opportunity
            WHERE StageName = :stage OR Amount > 10000
        ];
        //Extract total revenue from the query result 
        if (!groupedResults.isEmpty()) {
            totalRevenue = (Decimal) groupedResults[0].get('totalRevenue');
        }
        // Return the total revenue
        return totalRevenue;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        //SOQL query to return Accounts ORDER BY Name AND LIMIT  10 
        List<Account> firstTenAccountsByName = [
            SELECT Name
            FROM Account
            ORDER BY Name
            LIMIT 10
        ];
        //return List of Accounts
        return firstTenAccountsByName; 
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        //SOQL query for Opportunities with Amount > 100000 ORDER BY CloseDate LIMIT 5
        List<Opportunity> highValueOpportunitiesByCloseDate = [
            SELECT Name, AccountId, CloseDate, StageName, Amount
            FROM Opportunity
            WHERE Amount > 100000
            ORDER BY CloseDate
            LIMIT 5
        ];
        return highValueOpportunitiesByCloseDate; 
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        //SOQL query for Contact with Birthdate <TODAY ORDER BY DESC LIMIT 3
        List<Contact> contactsWithRecentBirthdates = [
            SELECT LastName, Birthdate
            FROM Contact
            ORDER BY Birthdate DESC
            LIMIT 3
        ];
        return contactsWithRecentBirthdates;
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        //SOQL query for Cases where Status = Open ORDER BY CreatedDate LIMIT 10 OFFSET 5
        List<Case> casesWithOpenStatus = [
            SELECT Subject, Status, CreatedDate
            FROM Case
            WHERE Status = 'Open'
            ORDER BY CreatedDate
            LIMIT 10 OFFSET 5
        ];
        //return List of Cases w Open Status
        return casesWithOpenStatus; 
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
         //Create a set to hold the Case Ids
         Set<Id> caseIdsSet = new Set<Id>();
         //Query the Cases
        List<Case> cases = [
            SELECT Id
            FROM Case
            WHERE AccountId = :accountId
        ];
         //Loop through each Case and add the Id to the set
        for (Case c : cases) {
            caseIdsSet.add(c.Id);
        }

        return caseIdsSet; 
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
    
        // Query the Accounts for Id, Names, Country != country
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE BillingCountry != :country
        ];
        // Loop through each Account and add the Id and Name to the map
        for (Account a : accounts) {
            accountIdsToNames.put(a.Id, a.Name);
        }
        //return map of AccountIds to Account Names 
        return accountIdsToNames; 
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        //SOQL query for Account Name given the Contact Id
        String accountName;
        List <Contact> contacts = [
            SELECT Account.Name
            FROM Contact
            WHERE Id = :contactId
        ];
        accountName = contacts[0].Account.Name;
        //return Account Name of Contact
        return accountName; 
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        Account accountWithOpp;
        List<Account> accountList = [
            SELECT Id, Name, (SELECT Id, Name FROM Opportunities)
            FROM Account 
            WHERE Id = :accountId
        ];
        //Check if any Account record was returned 
        if (!accountList.isEmpty()) {
            accountWithOpp = accountList[0];
        } else {
            accountWithOpp = new Account ();
        }
        return accountWithOpp;
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        List<Contact> contacts = new List<Contact>();
        // Query the Account
        List<Account> accounts = [
            SELECT Id, Name, BillingState
            FROM Account
            WHERE Id = :accountId
        ];
        // Store the Account's BillingState
        String accountBillingState = accounts[0].BillingState;
        // Query the Contacts
        contacts = [
            SELECT Id, LastName, MailingState
            FROM Contact
            WHERE MailingState = :accountBillingState
        ];
        //Return list of Contacts where Contact.Mailing State = Account.Billing State based on param Account Id
        return contacts; 
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads

        // Create a set of email domains from the Leads

        // Loop through each Lead

            // Get the email from the Lead

            // Check if the email is not null

                // Add the email domain to the set

        
        // Query the Accounts
        return null; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items

        // Create a list to hold the new line items

        // Generate a random number between 1 and 3

        // Loop through each cloned Opportunity Id

            // Loop through each original line item

                // Clone the original line item and add the random number to the quantity

        // Insert the new line items
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return null; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities

        // Create a set of Account Ids from the Opportunities

        // Query the Contacts

        // Loop through each Contact and add the Account Id and Contact to the map
        
        // Loop through each Opportunity

                // Update the Opportunity primary contact from accountToContactMap

        // Update the Opportunities
    }
}