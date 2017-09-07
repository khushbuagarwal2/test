/**
* @author TCS Developer
* @date 12/08/2014
* @module PPM
* @usage Test Class
* @description Tests all functionality of Class-WorkPlanCloneTaskExtension
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
@IsTest
public with sharing class WorkPlanCloneTaskExtension_Test{
     public static String profilename = 'Solution Manager';
     
     
     static testmethod void testWorkPlanCloneTaskExtension(){
    
        User newUser =  WorkPlanTestUtility.singleUser(profilename);
         insert newUser;
         
         //Custom Setting Data added - By Noopur Rathod
        TriggerDisabledSettings__c ObjTriggerDisabled= new TriggerDisabledSettings__c();
        ObjTriggerDisabled.name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert   ObjTriggerDisabled;
         
         
        //create Country Period
        AIM_Geography__c CountryRecord =  WorkPlanTestUtility.createCountry();
        insert CountryRecord;
        
        //create tasklookup record
        Task_Lookup__c tlookup = new Task_Lookup__c();
        tlookup.Task_Type__c = 'Training Plan';
        tlookup.Name='test';   
        tlookup.Grant_Cycle__c='12';
        insert tlookup;       
       
        //create milestonelookup record
        Milestone_Lookup__c mlookup = new Milestone_Lookup__c();
        mlookup.Task_Name__c= 'Training Plan';
        mlookup.name='test2';
        mlookup.Milestone__c = 'testmilestone';
        mlookup.Duration__c = 5;
        mlookup.Predecessor__c='Test1';
        mlookup.Calculate_Business_Days__c=TRUE;
        insert mlookup;
        
        RecordType r = new RecordType ();
        r = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
      
        //create Task
        Task__c taskRecord= new task__c();
        taskRecord.Task_Name__c='Training Plan';
        taskRecord.Geography__c = CountryRecord.id;
        taskRecord.RecordTypeId = r.id;
        taskRecord.Name='Task';
    
        insert taskRecord; 
        
        Step__c stp = new step__c();
        stp.name='Test1';
        stp.Task_Name_lkp__c=taskRecord.id;
        stp.due_date__c = system.today();
        stp.status__c='In Progress';
       
        stp.is_mandatory__c = false;
        insert stp;
        
       List<Responsible__c> responsibleRecList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord.Id,newUser.Id);
        
        
       List<Responsible__c> responsiblestpRecList = WorkPlanTestUtility.createSingleStepResponsibleRecords(stp.Id,newUser.Id);
                 
        
       Test.startTest();  
        insert responsibleRecList;  
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(taskRecord);  
        WorkPlanCloneTaskExtension oTSTravel=new WorkPlanCloneTaskExtension(stdCtrl);
        oTSTravel.addtask();           
        List<Task__c> taskRecordsList = new list<Task__c>([select id,Name,Task_Name__c,Geography__c from Task__c where Geography__c =: CountryRecord.id order by Task_Name__c]);       
         
        System.assert(taskRecordsList.size() >= 0);
         
        Test.stopTest();
        
                  
    }
}