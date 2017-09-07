/**
* @author TCS Developer
* @date 11/19/2014
* @module PPM
* @usage Test Class
* @description This Class is meant for Trigger-WorkPlanResponsibleTrigger(on Responsible__c) and Class-WorkplanResponsibleTriggerHandler
 				Used to Test Trigger-WorkPlanResponsibleTrigger(on Responsible__c) and Class-WorkplanResponsibleTriggerHandler
* @version history
	1. Developer Name - MM/DD/YYYY - Description
*/   
@isTest 
public class WorkplanResponsibleTriggerHandler_Test{
    public static String profilename = 'Procurement User';
    public static Set<Id> stepRecordIdsSet= new Set<Id>();
    public static RecordType rTravel;
    
     @testSetup static void setup() { 
    	
        /* Adding Custom Setting Test Data -- By Pankaj */
        
        TriggerDisabledSettings__c ObjTriggerDisabled= new TriggerDisabledSettings__c();
        ObjTriggerDisabled.name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert   ObjTriggerDisabled;
     } 
   
   //We dont need 'Travel_Task' hence commenting whole method(by Razia)
    static testmethod void testInsertResponsible(){
        User newUser = WorkPlanTestUtility.singleUser(profilename);
        insert newUser;        
        User newUser2 = WorkPlanTestUtility.singleUser(profilename);
        insert newUser2; 
       
      
        rTravel = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
        Task__c taskRecord= new task__c();
        taskRecord.Task_Name__c='Travel';
        taskRecord.RecordTypeId = rTravel.id;
        taskRecord.Name='Test Task';
        insert taskRecord;
      
        
        //create Step record
        Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
      
        //create responsible for the step created
        List<Responsible__c> responsibleStepList = WorkPlanTestUtility.createSingleStepResponsibleRecords(stepRecord.Id ,newUser.Id);
 
        //create responsible for the task created
        List<Responsible__c> responsibleTaskList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord.Id ,newUser2.Id);
 
        //start test
        Test.startTest();
        insert responsibleStepList;
        insert responsibleTaskList;
 
        WorkplanResponsibleTriggerHandler.filterResponsibleToInsert(responsibleStepList);
        WorkplanResponsibleTriggerHandler.filterResponsibleToInsert(responsibleTaskList);
     
 
 
        Responsible__c oRespTask = [Select id, Task__r.name from Responsible__c where Task__c =:taskRecord.Id]; 
        System.assertEquals(oRespTask.Task__r.name,'Test Task');
 
        list<Responsible__c> oRespStep = [Select id, Step__r.name from Responsible__c where Step__c =:stepRecord.Id order BY name]; 
     
        System.assertEquals(oRespStep[0].Step__r.name,'Test MileStone');
        Test.stopTest();
        
    }
 
  
    static testmethod void testInsertResponsible2(){
        
        User newUser = WorkPlanTestUtility.singleUser(profilename);
        insert newUser;        
        User newUser2 = WorkPlanTestUtility.singleUser(profilename);
        insert newUser2; 
    
      
        rTravel = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
        Task__c taskRecord= new task__c();
        taskRecord.Task_Name__c='Travel';
        taskRecord.RecordTypeId = rTravel.id;
        taskRecord.Name='Test Task';
        insert taskRecord; 
        
        //create Step record
        Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
        
        //create responsible for the task created
        List<Responsible__c> responsibleTaskList = new List<Responsible__c> ();
        Responsible__c resp1 = new Responsible__c(Task__c = taskRecord.id , Responsible__c =newUser.Id );
        Responsible__c resp2 = new Responsible__c(Task__c = taskRecord.id , Responsible__c =newUser2.Id );
        responsibleTaskList.add(resp1);
        responsibleTaskList.add(resp2);
        
         //create responsible for the step created
        List<Responsible__c> responsibleStepList = new List<Responsible__c> ();
        Responsible__c resp3 = new Responsible__c(Step__c = stepRecord.id , Responsible__c =newUser.Id );
        Responsible__c resp4 = new Responsible__c(Step__c = stepRecord.id , Responsible__c =newUser2.Id );
        responsibleStepList.add(resp3);
        responsibleStepList.add(resp4);
        
        
        //start test
        Test.startTest();
        insert responsibleTaskList;
        insert responsibleStepList;
        
        WorkplanResponsibleTriggerHandler.filterResponsibleToInsert(responsibleStepList);
        WorkplanResponsibleTriggerHandler.filterResponsibleToInsert(responsibleTaskList);
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnAdditonOfResp(responsibleTaskList);
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnAdditonOfResp(responsibleStepList);
 
        List<Responsible__c> respTaskLst = [Select id, Task__r.name from Responsible__c where Task__c =:taskRecord.Id]; 
        System.assertEquals(respTaskLst[0].Task__r.name,'Test Task');
        
        List<Responsible__c> respStepLst = [Select id, Step__r.name from Responsible__c where Step__c =:stepRecord.Id]; 
        System.assertEquals(respStepLst[0].Step__r.name,'Test MileStone');
        Test.stopTest();
        
    }
    
   
    static testmethod void testDeleteResponsible(){
        User newUser = WorkPlanTestUtility.singleUser(profilename);
        insert newUser;
       
       
       //create Task
        rTravel = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
        Task__c taskRecord= new task__c();
        taskRecord.Task_Name__c='Travel';
        taskRecord.RecordTypeId = rTravel.id;
        taskRecord.Name='Test Task';
        insert taskRecord;
        
        //create Step record
        Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
        //create responsible for the step created
        List<Responsible__c> responsibleStepList = WorkPlanTestUtility.createSingleStepResponsibleRecords(stepRecord.Id ,newUser.Id);
 
        
        //create responsible for the task created
        List<Responsible__c> responsibleTaskList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord.Id ,newUser.Id);
 
        
        //start test
        Test.startTest();
        insert responsibleStepList;
        insert responsibleTaskList;
        WorkplanResponsibleTriggerHandler.filterResponsibleToInsert(responsibleTaskList);
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnDeletionOfResp(responsibleTaskList);
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnDeletionOfResp(responsibleStepList);
 
 
        Responsible__c oRespTask = [Select id, Task__r.name from Responsible__c where Task__c =:taskRecord.Id]; 
        System.assertEquals(oRespTask.Task__r.name,'Test Task');
        
        Responsible__c oRespStep = [Select id, Step__r.name from Responsible__c where Step__c =:stepRecord.Id]; 
        System.assertEquals(oRespStep.Step__r.name,'Test MileStone');
        Test.stopTest();
        
        
    }
    
    
    static testmethod void test_updateResponsiblestringOnTaskAndStepOnDeletionOfResp(){
		User newUser = WorkPlanTestUtility.singleUser(profilename);
        insert newUser;        
        User newUser2 = WorkPlanTestUtility.singleUser(profilename);
        insert newUser2; 
       
      
        rTravel = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
        Task__c taskRecord= new task__c();
        taskRecord.Task_Name__c='Travel';
        taskRecord.RecordTypeId = rTravel.id;
        taskRecord.Name='Test Task';
        insert taskRecord;
          
        
        //create Step record
        Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
      
        //create responsible for the step created
        List<Responsible__c> responsibleStepList = WorkPlanTestUtility.createSingleStepResponsibleRecords(stepRecord.Id ,newUser.Id);
 
        //create responsible for the task created
        List<Responsible__c> responsibleTaskList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord.Id ,newUser2.Id);
        insert responsibleStepList;
        insert responsibleTaskList;
 
        Test.startTest();
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnDeletionOfResp(responsibleStepList);
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnDeletionOfResp(responsibleTaskList);
        Test.stopTest();
    }
    
    static testmethod void updateResponsiblestringOnTaskAndStepOnAdditonOfResp(){
        User newUser = WorkPlanTestUtility.singleUser(profilename);
        insert newUser;        
        User newUser2 = WorkPlanTestUtility.singleUser(profilename);
        insert newUser2; 
       
      
        rTravel = [select id, name from RecordType where DeveloperName='PPM_Key_Activity' and sobjectType='Task__c'];
        Task__c taskRecord= new task__c();
        taskRecord.Task_Name__c='Travel';
        taskRecord.RecordTypeId = rTravel.id;
        taskRecord.Name='Test Task';
        insert taskRecord;
          
        
        //create Step record
        Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord.Id);
        stepRecord.Original_Due_Date__c = System.today()+5;
        stepRecord.Due_Date__c = System.today()+5;
        insert stepRecord;
      
        //create responsible for the step created
        List<Responsible__c> responsibleStepList = WorkPlanTestUtility.createSingleStepResponsibleRecords(stepRecord.Id ,newUser.Id);
 
        //create responsible for the task created
        List<Responsible__c> responsibleTaskList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord.Id ,newUser2.Id);
        insert responsibleStepList;
        insert responsibleTaskList;
 
        Test.startTest();
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnAdditonOfResp(responsibleStepList);
        WorkplanResponsibleTriggerHandler.updateResponsiblestringOnTaskAndStepOnAdditonOfResp(responsibleTaskList);
        Test.stopTest();
    }
  }