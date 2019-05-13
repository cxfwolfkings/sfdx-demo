@isTest
public with sharing class ApexDemo01 {
    public ApexDemo01() {

    }

    /**
     * sObject抽象类型来表示任何对象，其变量表示一行数据
     */
    @isTest
    public static void test1() {
        Account a = new Account(Name = 'Acme', BillingCity = 'San Francisco');
        insert a;
        sObject s = [SELECT Id, Name, BillingCity FROM Account WHERE Name = 'Acme' LIMIT 1];
        // This is allowed
        ID id = s.Id;
        // The following line results in an error when you try to save
        // String x = s.Name;
        // This line results in an error when you try to save using API version 26.0 or earlier
        // s.Id = [SELECT Id FROM Account WHERE Name = 'Acme' LIMIT 1].Id;
        try {    
            Account convertedAccount = (Account)s;
            convertedAccount.name = 'Acme2';
            // Update the billing city.
            convertedAccount.BillingCity = 'New York';
            update convertedAccount;

            // Verify that the billing city was updated to New York.
            Account afterUpdate = [SELECT BillingCity FROM Account WHERE Id=:convertedAccount.Id];
            System.assertEquals('New York', afterUpdate.BillingCity);
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    public static void convertType(Integer phoneNumber) {
        List<Contact> contacts;
        List<Lead> leads;
        List<Account> accounts;
        List<List<sObject>> results = [FIND '4155557000' 
                         IN Phone FIELDS 
                         RETURNING Contact(Id, Phone, FirstName, LastName), 
                         Lead(Id, Phone, FirstName, LastName), Account(Id, Phone, Name)];
        sObject[] records = ((List<sObject>)results[0]);
    
        if (!records.isEmpty()) {
            for (Integer i = 0; i < records.size(); i++) {
              sObject record = records[i];
              if (record.getSObjectType() == Contact.sObjectType) {
                contacts.add((Contact) record);
              } else if (record.getSObjectType() == Lead.sObjectType){
                leads.add((Lead) record);
              } else if (record.getSObjectType() == Account.sObjectType) {
                accounts.add((Account) record);
              }
            }
        }  
    }

    /**
     * 建议执行批量DML操作，因为它有助于避免达到调控器限制，例如每个Apex事务的150个语句的DML限制。
     * 此限制适用于确保对Lightning平台中的共享资源的公平访问。
     * 对sObject列表执行DML操作计为一个DML语句，而不是每个sObject的一个语句。
     * 另一个DML调控器限制是单个事务中DML操作可以处理的总行数，即10,000。由同一事务中的所有DML调用处理的所有行将逐渐增加到此限制。
     * 例如，如果您在同一事务中插入100个联系人并更新50个联系人，则您处理的DML总行数为150.您还剩下9,850行（10,000 - 150）。
     */
    public static void test2() {
        // List to hold the new contacts to update.
        List<Contact> updatedList = new List<Contact>();
        List<Contact> conList = [Select Department , Description from Contact];
        for(Contact con : conList) {
            if (con.Department == 'Finance') {
                con.Description = 'New description';
                // Add updated contact sObject to the list.
                updatedList.add(con);
            }
        }
        // Call update on the list of contacts.
        // This results in one DML call for the entire list.
        update updatedList;
    }

    @isTest
    public static void test3() {
        Account a1 = new Account(Name='Account Example');
        insert a1;
        // Query existing account.
        Account a2 = [SELECT Name,Industry 
               FROM Account 
               WHERE Name='Account Example' LIMIT 1];
        // Write the old values the debug log before updating them.
        System.debug('Account Name before update: ' + a2.Name); // Name is Account Example
        System.debug('Account Industry before update: ' + a2.Industry);// Industry is not set
        // Modify the two fields on the sObject.
        a2.Name = 'Account of the Day';
        a2.Industry = 'Technology';
        // Persist the changes.
        update a2;
        // Get a new copy of the account from the database with the two fields.
        Account a3 = [SELECT Name,Industry 
             FROM Account 
             WHERE Name='Account of the Day' LIMIT 1];
        // Verify that updated field values were persisted.
        System.assertEquals('Account of the Day', a3.Name);
        System.assertEquals('Technology', a3.Industry);
    }

    /**
     * Apex提供了两种执行DML操作的方法
     * 1. DML：简单
     * 2. Database：自由
     * 通过使用Database类方法，您可以指定是否允许在遇到错误时进行部分记录处理。您可以通过传递第二个布尔参数来设置。
     * 设置为false，如果记录失败，剩余的DML操作仍然会执行。此外，返回结果是一个对象数组（或者如果只传入一个sObject，则返回一个结果对象）而不是异常，
     * 其中包含每个操作的状态以及遇到的错误。默认情况下，此可选参数为true，这意味着如果有一个sObject无法处理，则所有剩余的sObject都不处理，
     * 并且会为抛出异常。
     */
    @isTest
    public static void test4() {
        // 第一种方法
        // Create the list of sObjects to insert
        List<Account> acctList1 = new List<Account>();
        acctList1.add(new Account(Name='Acme1'));
        acctList1.add(new Account(Name='Acme2'));
        // DML statement
        insert acctList1;

        // 第二种方法
        // Create the list of sObjects to insert
        List<Account> acctList2 = new List<Account>();
        acctList2.add(new Account(Name='Acme3'));
        acctList2.add(new Account(Name='Acme4'));
        // DML statement
        Database.SaveResult[] srList = Database.insert(acctList2, false);
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            } else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }

    /**
     * 插入相关记录
     */
    @isTest
    public static void test5() {
        try {
            Account acct = new Account(Name='SFDC Account');
            insert acct;
            // Once the account is inserted, the sObject will be populated with an ID.
            // Get this ID.
            ID acctID = acct.ID;
            // Add a contact to this account.
            Contact con = new Contact(
                FirstName='Joe',
                LastName='Smith',
                Phone='415.555.1212',
                AccountId=acctID);
            insert con;
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    /**
     * 更新相关记录
     */
    @isTest
    public static void test6() {
        try {
            // Query for the contact, which has been associated with an account.
            Contact queriedContact = [SELECT Account.Name 
                                    FROM Contact 
                                    WHERE FirstName = 'Joe' AND LastName='Smith'
                                    LIMIT 1];
            // Update the contact's phone number
            queriedContact.Phone = '415.555.1213';
            // Update the related account industry
            queriedContact.Account.Industry = 'Technology';
            // Make two separate calls 
            // 1. This call is to update the contact's phone.
            update queriedContact;
            // 2. This call is to update the related account's Industry field.
            update queriedContact.Account; 
        } catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    /**
     * 使用外部Id关联
     * 1、Account对象有一个外部ID字段，类型：text，名称：MyExtID
     * 2、MyExtID__c='SAP111111'对应的Account已经存在
     */
    @isTest
    public static void test7() {
        Opportunity newOpportunity = new Opportunity(
            Name='OpportunityWithAccountInsert',
            StageName='Prospecting',
            CloseDate=Date.today().addDays(7));
        // Create the parent record reference.
        // An account with external ID = 'SAP111111' already exists.
        // This sObject is used only for foreign key reference
        // and doesn't contain any other fields.
        Account accountReference = new Account(MyExtID__c='SAP111111');                
        // Add the account sObject to the opportunity.
        newOpportunity.Account = accountReference;
        // Create the opportunity.
        Database.SaveResult results = Database.insert(newOpportunity);
    }

    /**
     * 使用外键在单个语句中创建父记录和子记录
     * 您可以创建最多10级深度的相关记录。此外，在单个调用中创建的相关记录必须具有不同的sObject类型。
     * 此示例需要Account对象上有外部ID文本字段MyExtID。
     */
    @isTest
    public static void test8() {
        Date dt = Date.today();
        dt = dt.addDays(7);
        Opportunity newOpportunity = new Opportunity(
            Name='OpportunityWithAccountInsert',
            StageName='Prospecting',
            CloseDate=dt);
        
        // Create the parent reference.
        // Used only for foreign key reference and doesn't contain any other fields.
        Account accountReference = new Account(MyExtID__c='SAP111111');                
        newOpportunity.Account = accountReference;
        
        // Create the Account object to insert.
        // Same as above but has Name field.
        // Used for the insert.
        Account parentAccount = new Account(
            Name='Hallie',
            MyExtID__c='SAP111111');      
        
        // Create the account and the opportunity.
        Database.SaveResult[] results = Database.insert(new SObject[] {
            parentAccount, newOpportunity });
        
        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Successfully created ID: ' + results[i].getId());
            } else {
                System.debug('Error: could not create sobject ' + 'for array element ' + i + '.');
                System.debug('   The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n');
            }
        }
    }

    /**
     * 使用 UPSERT 操作，您可以在一次调用中插入或更新现有记录。
     */
    @isTest
    public static void test9() {
        Account[] acctsList = [SELECT Id, Name, BillingCity
                                FROM Account WHERE BillingCity = 'Bombay'];
        for (Account a : acctsList) {
            a.BillingCity = 'Mumbai';
        }
        Account newAcct = new Account(Name = 'Acme', BillingCity = 'San Francisco');
        acctsList.add(newAcct);
        try {
            upsert acctsList;
        } catch (DmlException e) {
            // Process exception here
        }
    }

    /**
     * This method accepts a collection of lead records and creates a task for the owner(s) of any leads that were created as new, 
     * that is, not updated as a result of the upsert operation 
     */
    public static List<Database.upsertResult> upsertLeads(List<Lead> leads)  {
        /* 
         * Perform the upsert. 
         * In this case the unique identifier for the insert or update decision is the Salesforce record ID. 
         * If the record ID is null the row will be inserted, otherwise an update will be attempted. 
         */
        List<Database.upsertResult> uResults = Database.upsert(leads,false);
        /* 
         * This is the list for new tasks that will be inserted when new leads are created. 
         */
        List<Task> tasks = new List<Task>();
        for(Database.upsertResult result:uResults) {
            if (result.isSuccess() && result.isCreated()) 
                tasks.add(new Task(Subject = 'Follow-up', WhoId = result.getId()));
        }

        /* If there are tasks to be inserted, insert them */
        Database.insert(tasks);
        return uResults;
    }

    public static testMethod void testUpsertLeads() {
        /* We only need to test the insert side of upsert */
        List<Lead> leads = new List<Lead>();
        /* Create a set of leads for testing */
        for(Integer i = 0;i < 100; i++) {
            leads.add(new Lead(LastName = 'testLead', Company = 'testCompany'));
        }
        /* Switch to the runtime limit context */
        Test.startTest();
        /* Exercise the method */
        List<Database.upsertResult> results = upsertLeads(leads);
        /* Switch back to the test context for limits */
        Test.stopTest();
        /* ID set for asserting the tasks were created as expected */
        Set<Id> ids = new Set<Id>();
        /* 
         * Iterate over the results, 
         * asserting success and adding the new ID to the set for use in the comprehensive assertion phase below. 
         */
        for(Database.upsertResult result:results) {
            System.assert(result.isSuccess());
            ids.add(result.getId());
        }
        /* Assert that exactly one task exists for each lead that was inserted. */
        for(Lead l:[SELECT Id, (SELECT Subject FROM Tasks) FROM Lead WHERE Id IN :ids]) {
            System.assertEquals(1,l.tasks.size());
        }
    }

    /**
     * 使用 UPSERT 和外部 ID 字段 Line_Item_Id__c 在 Asset 对象上维护 Asset 和 OpportunityLineItem 之间的一对一关系
     */
    public void upsertExample() {
        Opportunity opp = [SELECT Id, Name, AccountId, 
                              (SELECT Id, PricebookEntry.Product2Id, PricebookEntry.Name 
                               FROM OpportunityLineItems)
                       FROM Opportunity 
                       WHERE HasOpportunityLineItem = true 
                       LIMIT 1]; 
        Asset[] assets = new Asset[]{}; 
        // Create an asset for each line item on the opportunity
        for (OpportunityLineItem lineItem:opp.OpportunityLineItems) {
            // This code populates the line item Id, AccountId, and Product2Id for each asset
            Asset asset = new Asset(Name = lineItem.PricebookEntry.Name,
                                Line_Item_ID__c = lineItem.Id,
                                AccountId = opp.AccountId,
                                Product2Id = lineItem.PricebookEntry.Product2Id);
            assets.add(asset);
        }
        try {
            /*
             * This line upserts the assets list with the Line_Item_Id__c field specified as the Asset field 
             * that should be used for matching the record that should be upserted. 
             */
            upsert assets Line_Item_ID__c;  
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
    }

    /**
     * 合并记录：merge 操作将最多三条记录合并到一条记录中，删除其他记录，并更新任何相关记录。其它注意事项：
     * 1、只能合并leads, contacts, accounts 
     * 2、可以将主记录和最多两个附加sObject记录传递给 merge 方法
     * 3、使用Apex合并操作，主记录上的字段值始终取代要合并的记录上的相应字段值。要保留合并的记录字段值，只需在执行合并之前在 master sObject 上设置此字段值。
     * 4、外部ID字段不能用于合并。
     */
    @isTest
    public static void test10() {
        // Insert new accounts
        List<Account> ls = new List<Account>{
            new Account(name='Acme Inc.'),
            new Account(name='Acme')
        };                                        
        insert ls;

        // Queries to get the inserted accounts 
        Account masterAcct = [SELECT Id, Name FROM Account WHERE Name = 'Acme Inc.' LIMIT 1];
        Account mergeAcct = [SELECT Id, Name FROM Account WHERE Name = 'Acme' LIMIT 1];

        // Add a contact to the account to be merged
        Contact c = new Contact(FirstName='Joe',LastName='Merged');
        c.AccountId = mergeAcct.Id;
        insert c;

        try {
            merge masterAcct mergeAcct;
        } catch (DmlException e) {
            // Process exception
            System.debug('An unexpected error has occurred: ' + e.getMessage()); 
        }

        // Once the account is merged with the master account,
        // the related contact should be moved to the master record.
        masterAcct = [SELECT Id, Name, (SELECT FirstName, LastName From Contacts) 
                    FROM Account WHERE Name = 'Acme Inc.' LIMIT 1];
        System.assert(masterAcct.getSObjects('Contacts').size() > 0);
        System.assertEquals('Joe', masterAcct.getSObjects('Contacts')[0].get('FirstName'));
        System.assertEquals('Merged', masterAcct.getSObjects('Contacts')[0].get('LastName'));

        // Verify that the merge record got deleted
        Account[] result = [SELECT Id, Name FROM Account WHERE Id=:mergeAcct.Id];
        System.assertEquals(0, result.size());
    }

    @isTest
    public static void test11() {
        // Create master account
        Account master = new Account(Name='Account1');
        insert master;

        // Create duplicate accounts
        Account[] duplicates = new Account[]{
            // Duplicate account 
            new Account(Name='Account1, Inc.'),
            // Second duplicate account
            new Account(Name='Account 1')
        };
        insert duplicates;

        // Create child contact and associate it with first account
        Contact c = new Contact(firstname='Joe',lastname='Smith', accountId=duplicates[0].Id);
        insert c;

        // Get the account contact relation ID, which is created when a contact is created on "Account1, Inc." 
        AccountContactRelation resultAcrel = [SELECT Id FROM AccountContactRelation WHERE ContactId=:c.Id LIMIT 1];

        // Merge accounts into master
        Database.MergeResult[] results = Database.merge(master, duplicates, false);

        for(Database.MergeResult res : results) {
            if (res.isSuccess()) {
                // Get the master ID from the result and validate it
                System.debug('Master record ID: ' + res.getId());
                System.assertEquals(master.Id, res.getId());              

                // Get the IDs of the merged records and display them
                List<Id> mergedIds = res.getMergedRecordIds();
                System.debug('IDs of merged records: ' + mergedIds);                
        
                // Get the ID of the reparented record and validate that this the contact ID.
                System.debug('Reparented record ID: ' + res.getUpdatedRelatedIds());

	            // Make sure there are two IDs (contact ID and account contact relation ID); the order isn't defined
                System.assertEquals(2, res.getUpdatedRelatedIds().size() );    
                boolean flag1 = false;
	            boolean flag2 = false;

    	        // Because the order of the IDs isn't defined, the ID can be at index 0 or 1 of the array	     
                if (resultAcrel.id == res.getUpdatedRelatedIds()[0] || resultAcrel.id == res.getUpdatedRelatedIds()[1] )
            	    flag1 = true;
        
                if (c.id == res.getUpdatedRelatedIds()[0] || c.id == res.getUpdatedRelatedIds()[1] )
                    flag2 = true;
            
                System.assertEquals(flag1, true); 
                System.assertEquals(flag2, true);  
            } else {
                for(Database.Error err : res.getErrors()) {
                    // Write each error to the debug output
                    System.debug(err.getMessage());
                }
            }
        }
    }

    /**
     * 在数据库中保留记录后，可以使用 delete 删除这些记录。
     * 已删除的记录不会从Salesforce中永久删除，但会将它们放置在回收站中15天，以便还原它们。
     */
    @isTest
    public static void test12() {
        Account[] doomedAccts = [SELECT Id, Name FROM Account 
                                WHERE Name = 'DotCom']; 
        try {
            delete doomedAccts;
        } catch (DmlException e) {
            // Process exception here
        }
    }
    
    /**
     * 撤销删除
     * "ALL ROWS"可以查出逻辑删除的数据（15天期限）
     */
    @isTest
    public static void test13() {
        Account a = new Account(Name='Universal Containers');
        insert(a);
        insert(new Contact(LastName='Carter',AccountId=a.Id));
        delete a;

        Account[] savedAccts = [SELECT Id, Name FROM Account WHERE Name = 'Universal Containers' ALL ROWS]; 
        try {
            undelete savedAccts;
        } catch (DmlException e) {
            // Process exception here
        }
    }

    /**
     * 转换Leads（潜在客户）
     * DML操作"convertLead"将 lead（潜在客户） 转换为 account（账户）和 contact（联系人），（可选）机会。
     * "convertLead"只能作为 Database 类的方法使用；不能使用 DML 语法！
     */
    @isTest
    public static void test14() {
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    }

    /**
     * 通过关系访问sObject
     * 下面示例中，如果对应Acount不存在，那么Contact插入失败！
     */
    public static void test15() {
        Account refAcct = new Account(externalId__c = '12345');
        Contact c = new Contact(Account = refAcct, LastName = 'Kay');
        insert c;
        // 下面的代码等同于上面，但是因为使用了SOQL语句，所以效率不高
        // Account refAcct = [SELECT Id FROM Account WHERE externalId__c='12345'];
        // Contact c = new Contact(Account = refAcct.Id);
        // insert c;
    }

    /**
     * 外键和父子关系SOQL查询
     */
    public static void test16() {
        System.debug([SELECT Account.Name FROM Contact WHERE FirstName = 'Caroline'].Account.Name);

        // Account关联多个Contacts
        for (Account a : [SELECT Id, Name, (SELECT LastName FROM Contacts)
                  FROM Account
                  WHERE Name = 'Acme']) {
            Contact[] cons = a.Contacts;
        }

        // The following example also works because we limit to only 1 contact
        for (Account a : [SELECT Id, Name, (SELECT LastName FROM Contacts LIMIT 1)
                  FROM Account
                  WHERE Name = 'testAgg']) {
            Contact c = a.Contacts;
        }
    }

    /**
     * 统计函数
     */
    public static void test17() {
        AggregateResult[] groupedResults = [SELECT AVG(Amount)aver FROM Opportunity];
        Object avgAmount = groupedResults[0].get('aver');

        // "expr0"是默认别名
        AggregateResult[] groupedResults = 
            [SELECT CampaignId, AVG(Amount)
            FROM Opportunity
            GROUP BY CampaignId];
        for (AggregateResult ar : groupedResults)  {
            System.debug('Campaign ID' + ar.get('CampaignId'));
            System.debug('Average amount' + ar.get('expr0'));
        }
    }

    /**
     * 大数据量的处理
     */
    public static void test18() {
        // Account[] accts = [SELECT Id FROM Account];
        // if the results are too large, this syntax causes a runtime exception

        // Use this format if you are not executing DML statements 
        // within the for loop
        for (Account a : [SELECT Id, Name FROM Account 
                        WHERE Name LIKE 'Acme%']) {
            // Your code without DML statements here
        }

        // Use this format for efficiency if you are executing DML statements 
        // within the for loop
        for (List<Account> accts : [SELECT Id, Name FROM Account
                                    WHERE Name LIKE 'Acme%']) {
            // Your code here
            update accts;
        }
    }
}
