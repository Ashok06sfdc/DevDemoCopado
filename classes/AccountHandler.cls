public class AccountHandler {
    public static void beforeInsertMethod(List<Account> accList){
        for(Account a:accList){
            a.Description='New Account Description';
        }
    }
    public static void beforeInsertRating(List<Account> accList1){
        for(Account a:accList1){
            if(a.Industry!=null && a.Industry=='Media'){
                a.Rating='Hot';
            }
        }
    }
    public static void afterInsertOpportunity(List<Account> accList2){
        List<Opportunity> OptyList=new List<Opportunity>();
        for(Account a:accList2){
            Opportunity op=new Opportunity();
            op.Name=a.Name;
            op.stageName='Closed-Won';
            op.CloseDate=system.today()+15;
            op.AccountId=a.Id;
            optyList.add(op);
        }
        if(!OptyList.isEmpty()){
            insert OptyList;
        }
        
    }
    public static void beforeAccPhoneUpdate(Map<Id,Account> oldMap, Map<Id,Account> newMap){
        set<Id> AccIds=oldMap.keySet();
        for(Id aId:AccIds){
            Account accOld=oldMap.get(aId);
            Account accNew=newMap.get(aId);
            if(accOld.Phone!=null && accOld.Phone!=accNew.Phone){
                accNew.Description='Phone is updated';
            }
        }
    }
    public static void afterAccPhoneUpdate(Map<Id,Account> oldMap, Map<Id,Account> newMap){
        set<Id> accIds=oldMap.keySet();
        List<opportunity> oppList=new List<Opportunity>();
        for(Id aid:accIds){
            Account oldAcc=oldMap.get(aid);
            Account newAcc=newMap.get(aid);
            if(oldAcc.Phone!=null && oldAcc.Phone != newAcc.Phone){
               oppList=[Select id,Phone__c from Opportunity where AccountId=:aid];
            }
            for(opportunity op:oppList){
                op.Phone__c=newAcc.Phone;
            }
        }
        update oppList;
    }

}