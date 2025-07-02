@isTest
private class AccountHandlerTest {
    @testSetup
    static void createAccount(){
        //creation of test data
        List<Account> accList=new List<Account>();
        for(integer i=1;i<=2;i++){
            accList.add(new Account(Name='Test'+i,phone='040-123'));
        }
        insert accList;
            
        }
    @isTest
        static void beforeAccInsertTest(){
            Account acc=[Select id,Name,Description from Account where Name='Test1'];
            system.assertEquals('New Account Description',acc.Description);
                 
    }
    @isTest
    static void beforeInsertRatingTestMethod(){
        Account acc=[Select id,Name,Rating,Industry from Account where Name='Test1'];
        if(acc.Industry != null && acc.Industry=='Media'){
            system.assertEquals('Hot',acc.Rating);
        }
    }
    @isTest
    static void afterInsertOpportunityTestMethod(){
        Account acc=[Select id,Name,Rating,Industry from Account where Name='Test2'];
        Opportunity opp=[Select id,Name,Account.Name from Opportunity where AccountId=:acc.Id];
        system.assertNotEquals(null,opp);
    }
    @isTest
    static void beforeAccPhoneUpdate(){
  /*      Account acc=[Select id,Name,Phone from Account where Name='Test1'];  //fetching data from setup Method
        acc.Phone='+1-12345';
        Test.startTest();
        update acc;
        Test.stopTest();
        system.assertEquals('Phone is updated',acc.Description);    */
        List<Account> accList=[Select id,Name,Phone from Account];
        for(Account a:accList){
            if(a.Phone!=null){
                a.Phone='+1-12456';
            }
        }
        Test.StartTest();             //Apply DML
        update accList;
        Test.StopTest();
        
        Account acc=[Select Phone,Description from Account where Id=:accList[0].Id];       //Validating the data
        system.assertEquals('Phone is updated',acc.Description);
    }
    
    @isTest
    static void afterAccPhoneUpdateTestMethod(){
        List<Account> accList=[Select id,Phone from Account];
        for(Account a:accList){
            if(a.Phone !=null){
                a.Phone='+11-2345';
            }
        }
        Test.StartTest();
        update accList;
        Test.StopTest();
        
        List<Opportunity> optyList=[Select id,Phone__c from Opportunity where AccountId=:accList[0].Id];
        for(Opportunity op:optyList){
            system.assertEquals(op.Phone__c,accList[0].Phone);
        }
    }

}