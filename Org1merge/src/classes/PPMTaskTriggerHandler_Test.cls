/**
* @author TCS Developer
* @date 08/09/2015
* @module PPM
* @usage Test Class
* @description Test class for PPMTaskTriggerHandler 
* @version history
	1. Developer Name - MM/DD/YYYY - Description
*/
@isTest
private class PPMTaskTriggerHandler_Test{
     
     @testSetup static void setup() {
         
        //Custom Setting added by Noopur Rathod
        TriggerDisabledSettings__c ObjTriggerDisabled = new TriggerDisabledSettings__c();
        ObjTriggerDisabled.Name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert ObjTriggerDisabled;
         
         
        RecordType rt = [select id,Name from RecordType where SobjectType='Task__c' and developerName='PPM_Key_Activity'];
        Id ppmRecordtypeId = rt.Id;
        List<Task__c> taskList = new List<Task__c>();
        List<Responsible__c> responsibleList = new List<Responsible__c>();
        for(Integer i=1;i<=200;i++){
            Task__c Testtask = new Task__c();
            Testtask.Name = 'Testing in Test Class'+i; 
            Testtask.RecordtypeId = ppmRecordtypeId;  
            taskList.add(Testtask);
        }    
      insert taskList;
        
        for(Integer i=1;i<=100;i++){
            Responsible__c resRecord= new Responsible__c();
            resRecord.Responsible__c = UserInfo.getUserId();
            resRecord.Type__c = 'Support';
            resRecord.task__c = taskList[0].Id;
            responsibleList.add(resRecord);
        }        
        insert responsibleList ;
        
     }
    static testmethod void Test_PPMTaskTriggerHandler()
    {
        RecordType rt = [select id,Name from RecordType where SobjectType='Task__c' and developerName='PPM_Key_Activity'];
        Id ppmRecordtypeId = rt.Id; 
        Test.startTest();
        
       
        
        List<Task__c> taskReclst = [Select name from Task__c Where recordTypeId=:ppmRecordtypeId];
        for(Task__c task:taskReclst){
            task.Name = 'Task for UK Travel';
        }
        update taskReclst;
        for(Task__c taskRec:taskReclst){
            System.assertEquals('Task for UK Travel',taskRec.Name);
        }
        Test.stopTest();
        
    }
}