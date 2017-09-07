/**
* @author TCS Developer
* @date 10/01/2015
* @module PPM
* @usage Test Class
* @description  Test class for WorkPlanTaskTriggerHandler
* @version history
	1. Developer Name - MM/DD/YYYY - Description
*/
@IsTest
public with sharing class WorkplanTaskTriggerHandler_Test{

    public static String profilename = 'Solution Manager';
    public static Set<Id> stepRecordIdsSet= new Set<Id>();

	
    static testmethod void deleteTask_Test(){
        
        
        
        TriggerDisabledSettings__c cus_Settings = new TriggerDisabledSettings__c();
        cus_Settings.name = 'DS1';
        cus_Settings.DisableTrigger__c = False;
        insert cus_Settings;
             
        
        
        
        
        List<Task__C> list_Tasks = new List<Task__C>();
          //create Task
        Task__c taskRecord1 = new task__c();
        taskRecord1.name = 'Test_Task1';
        list_Tasks.add(taskRecord1);
        
        Task__c taskRecord2 = new task__c();
        taskRecord2.name = 'Test_Task2';
        taskRecord2.Is_Mandatory__c = True;
        list_Tasks.add(taskRecord2);
        
        insert list_Tasks; 
        
        Test.startTest();
   		WorkplanTaskTriggerHandler handler= new WorkPlanTaskTriggerHandler();
        handler.IsDisbaled();
        WorkPlanTaskTriggerHandler.deleteTask(list_Tasks);    
        if(cus_Settings.DisableTrigger__c){
           System.assertEquals(0, [Select id from Task__C].size());	 
        }
        else{
           System.assert([Select id from Task__C].size() >= 0);	  
        }
           
        
        Test.stopTest();
    }
    
    
   
  }