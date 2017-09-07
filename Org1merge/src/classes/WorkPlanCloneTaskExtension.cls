/**
* @author TCS Developer
* @date 12/08/2014
* @module PPM
* @usage Test Class
* @description This Class is used to add Responsible Users to Step(adding Responsible records).This Class is related with 
               WorkPlanAddResponsibleVFP Page.
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
public with sharing class WorkPlanCloneTaskExtension{
    Task__c tskRec;
    Task__c tsk;
    Step__c s;
    Responsible__c res;
    Map<id,Step__c> mStep;

    public WorkPlanCloneTaskExtension(ApexPages.standardController ctr){
        tskRec = (Task__c)ctr.getRecord();   
    }
    
     /**
    * @description Add Tasks
    * @author TCS Developer
    * @date 12/08/2014
    * @param None
    * @return void
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
    public PageReference addTask(){
        mStep = new Map<id,Step__c>();
        list<Responsible__c> tskres= new list<Responsible__c>();
        tsk = [select Name,Task_Name__c, Due_Date_Guidance__c, RecordtypeId,Comments__c,Priority__c, (select Name from Steps__r), (select Responsible__c,Task__c from Responsible__r) from Task__c where id=:tskRec.Id];
        Task__c t = tsk.clone(false, true, false, false);
        t.Is_Clone__c = true;
        t.Name = 'CLONE - '+ t.Name;
        
        insert t;
        for(Responsible__c r : tsk.Responsible__r){
            res= new  Responsible__c();
            res.Responsible__c = r.Responsible__c;
            res.Task__c = t.id;
            tskres.add(res);
        }
        insert tskres;
        
        list<Responsible__c> stpres= new list<Responsible__c>();
        Set<Id> sid = new Set<Id>();
        list<Step__c> stp = new list<Step__c>([select Name,Task_Name_lkp__c, Is_mandatory__c,start_date__c, End_date__c, RecordtypeId,Geography__c,Comments__c, Priority__c, (select Responsible__c,Step__c from Responsible__r)  from step__c where Task_Name_lkp__c =:tskRec.Id]);
        list<Step__c> nwstp = new list<Step__c>();
        for(Step__c step :stp){
            s = new Step__c();
            sid.add(Step.id);
            s = step.clone(false, true, false, false);
            s.Task_Name_lkp__c = t.id;
            nwstp.add(s);
            mStep.put(step.id,s);
                       
        }          
        insert nwstp;
        
        
        for(Step__c step :stp){
            for(Responsible__c r : step.Responsible__r){
                    if(r.Step__c == step.id){
                        s = new Step__c();
                        s= mStep.get(step.id);
                        
                        res= new  Responsible__c();
                        res.Responsible__c = r.Responsible__c;
                        res.Step__c= s.id;
                        stpres.add(res);
                    }    
                }
        }
        
        insert stpres;
     
       return new Pagereference('/'+t.id+'/e?retURL=%2F'+t.ID).setRedirect(True);
    }
}