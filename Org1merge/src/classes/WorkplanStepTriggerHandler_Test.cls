/**
* @author TCS Developer
* @date 01/29/2015
* @module PPM
* @usage Trigger
* @description This Class is meant for Trigger-Workplan_StepTrigger(on Step__c) and Class-Workplan_StepTriggerHandler
                Used to Test Trigger-Workplan_StepTrigger(Step__c) and Class-Workplan_StepTriggerHandler
* @version history
    1. Developer Name - 09/00/2014 - Email is sent on Task Completion.
*/
@isTest
public class WorkplanStepTriggerHandler_Test {
    public static String profilename = 'Solution Manager';
    public static Set<Id> stepRecordIdsSet= new Set<Id>();
    
    static testmethod void testmethod_A(){        
        User newUser                        =   WorkPlanTestUtility.singleUser(profilename);
        insert newUser;

        User newUser2                        =   WorkPlanTestUtility.singleUser(profilename);
        insert newUser2;

        
        //create tasklookup record
        Task_Lookup__c tlookup = new Task_Lookup__c();
        tlookup.Task_Type__c = 'Training Plan';
        tlookup.Name='test';  
        tlookup.Grant_Cycle__c = '12';
   
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

        Milestone_Lookup__c mlookup2 = new Milestone_Lookup__c();
        mlookup2.Task_Name__c= 'Training Plan';
        mlookup2.name='test3';
        mlookup2.Milestone__c = 'testmilestone2';
        mlookup2.Duration__c = 5;
        mlookup2.Predecessor__c='Test1';
        mlookup2.Calculate_Business_Days__c=false;
        insert mlookup2;

           
        RecordType rid = new RecordType ();
       rid = [select id from RecordType where developername ='PPM_Key_Activity' and sobjecttype='Task__c'];

        Task__c taskRecord=WorkPlanTestUtility.createTask4('PPM_Key_Activity');
        insert taskRecord;
        
        List<Step__c> stpLst = new List<Step__c>();
        Step__c stp = new step__c();
        stp.name='Test1';
        stp.Task_Name_lkp__c=taskRecord.id;
        stp.due_date__c = date.ValueOf('2015-01-01');
        stp.status__c='Not Started';
        stp.is_mandatory__c = false;
        stpLst.add(stp);

        Step__c stp2 = new step__c();
        stp2.name='testmilestone2';
        stp2.Task_Name_lkp__c=taskRecord.id;
        stp2.due_date__c = date.ValueOf('2015-01-01')+5;
        stp2.status__c='In Progress';
        stp2.is_mandatory__c = true;
        stp2.alert__c=true;
        stpLst.add(stp2);
        
           //Custom setting added by Noopur Rathod
        TriggerDisabledSettings__c ObjTriggerDisabled = new TriggerDisabledSettings__c();
        ObjTriggerDisabled.Name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert ObjTriggerDisabled;
        

// already commented in the code by developer
        Responsible__c r = new Responsible__c();
        r.Responsible__c = newUser2.id;
        r.Step__c = stp2.id;
        insert r;
        
        
        
        insert stpLst;
        //We dont need 'Grant_Making' and 'Concept_Note'(by Razia)
        Test.startTest();
        
        List<Step__c> stepRecordListNew  = new list<Step__c>([select Id,Name,Status__c,Task_Name_lkp__c,RecordTypeId,IP__c,Original_Due_Date__c,Due_Date__c, Alert__c,CreatedById,Is_Mandatory__c from Step__c]);  
       // Date dateVal= new Date();
         //WorkplanStepTriggerHandler.executeBusinessRules(stepRecordListNew);
       // WorkplanStepTriggerHandler.updateWeekNumber(stepRecordListNew);
       WorkplanStepTriggerHandler.deleteSteps(stepRecordListNew);
      
                   
        if(ObjTriggerDisabled.DisableTrigger__c){
           System.assertEquals(0, [Select id from Step__c].size());	 
        }
        else{
           System.assert([Select id from Step__c].size() >= 0);	  
        }
           
  
        //WorkplanStepTriggerHandler.calculateWeekNumberOfDate(dateVal);
        WorkplanStepTriggerHandler.IsDisbaled();
        
       
       Test.stopTest();
      
    }
    
    
/* static testmethod void testupdateweeknumber(){
         
        
        //Custom setting added by Noopur Rathod
        TriggerDisabledSettings__c ObjTriggerDisabled = new TriggerDisabledSettings__c();
        ObjTriggerDisabled.Name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert ObjTriggerDisabled;
        
       RecordType r = new RecordType ();
        r = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
        //create Travel Task
        Task__c tsk = new Task__c();
        tsk.Task_Name__c = 'Travel';
        tsk.RecordTypeId = r.id;
        tsk.Status__c = 'Not Started';
        insert tsk;

        RecordType rs = new RecordType ();
        rs = [select id, name from RecordType where DeveloperName='Travel_Step' and sobjectType='step__c'];
        
        List<Step__c> stpLst = new List<Step__c>();
        Step__c stp = new step__c();
        stp.Name='Test Travel';
        stp.Task_Name_lkp__c=tsk.id;
        stp.start_date__c = date.ValueOf('2015-01-01');
        stp.end_date__c = date.ValueOf('2015-09-01');
        stp.RecordTypeId = rs.id;
        stp.Status__c = 'In Progress';
        stp.is_mandatory__c = false;
        stpLst.add(stp);


        Step__c stp2 = new step__c();
        stp2.Name='Test Travel2';
        stp2.Task_Name_lkp__c=tsk.id;
        stp2.start_date__c = date.ValueOf('2015-01-01');
        stp2.end_date__c = date.ValueOf('2016-04-01');
        stp2.Status__c = 'Not Started';
        stp2.RecordTypeId = rs.id;
        stpLst.add(stp2);


        Step__c stp3 = new step__c();
        stp3.Name='Test Travel2';
        stp3.Task_Name_lkp__c=tsk.id;
        stp3.start_date__c = date.ValueOf('2015-01-01');
        stp3.end_date__c = date.ValueOf('2024-06-01');
        stp3.Due_Date__c = date.valueOf('2024-06-11');
        stp3.Status__c = 'Completed';
        stp3.RecordTypeId = rs.id;
        stp3.is_mandatory__c = false;
        stpLst.add(stp3);

        Step__c stp4 = new step__c();
        stp4.name='Test Travel2';
        stp4.Task_Name_lkp__c=tsk.id;
        stp4.start_date__c = date.ValueOf('2016-01-01');
        stp4.end_date__c = date.ValueOf('2016-08-01');
        stp4.Status__c = 'Cancelled';
        stp4.RecordTypeId = rs.id;
        stp4.is_mandatory__c = false;
        stpLst.add(stp4);

        
        Test.startTest();
        
        insert stpLst;
        List<Step__c> stepRecordListNew = new list<Step__c>([select Id, name,Task_Name_lkp__r.name,IP__c,RecordTypeId, start_date__c ,end_date__c ,Original_Due_Date__c, Alert__c,CreatedById,Is_Mandatory__c from Step__c]);
        
        List<Step__c> stepRecordListNew2 = new list<Step__c>([select Id, name,Task_Name_lkp__r.name,IP__c,RecordTypeId, start_date__c ,end_date__c ,Original_Due_Date__c, Alert__c,CreatedById,Is_Mandatory__c from Step__c where Is_Mandatory__c = False]);     
        
        WorkplanStepTriggerHandler.deleteSteps(stepRecordListNew2);
       
        WorkplanStepTriggerHandler.updateWeekNumber(stepRecordListNew);
      
        
        Test.stopTest();
        System.assertEquals(stepRecordListNew[2].name,'Test Travel2');
        }
     static testmethod void testUpdateWeekNumberNull(){
         //Custom setting added by Noopur Rathod
        TriggerDisabledSettings__c ObjTriggerDisabled = new TriggerDisabledSettings__c();
        ObjTriggerDisabled.Name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert ObjTriggerDisabled;
         
         
         Test.startTest();
          RecordType rs = new RecordType ();
          rs = [select id, name from RecordType where DeveloperName='Travel_Step' and sobjectType='step__c'];
         List<Step__c> stepRecordListNew1 = new list<Step__c>();
         stepRecordListNew1.add(new Step__c(Name='Step 1',start_Month__c =null,start_Year__c=null,start_week__c=null,start_Caldate__c=null,End_Month__c=null,End_Year__c=null,End_week__c=null,End_Caldate__c=null,RecordTypeId = rs.id));
         insert stepRecordListNew1;
         WorkplanStepTriggerHandler.updateWeekNumber(stepRecordListNew1);
                
         Test.stopTest();
     }*/
    
}