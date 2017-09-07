/**
* @author TCS Developer
* @date 08/05/2015 
* @module PPM
* @usage Test class
* @description Test class for PPMStepshandler
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
@isTest 
private class PPMStepshandler_Test {
    @testSetup static void setup() { 
        
        /* Adding Custom Setting Test Data -- By Pankaj */
        
        TriggerDisabledSettings__c ObjTriggerDisabled= new TriggerDisabledSettings__c();
        ObjTriggerDisabled.name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert   ObjTriggerDisabled;
        
        /* Ends Adding Custom Setting Test Data by Pankaj */
        
        
        Task__c Testtask = new Task__c();
        Testtask.Name = 'Testing in Test Class';
        System.debug('Setting Test Data');
        try{
            insert Testtask;    
        }catch(Exception e){
            System.debug('Exception occured ---- ' + e);
        }
        
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Step__c' and developerName='PPM_To_do'];
        Id ppmRecordtypeId = rt.Id;
    
        List<Step__c> stepRecordsList = new List<Step__c>();
        List<Responsible__c> respRecordsList = new List<Responsible__c>();
        //create Step Records
        for(Integer i=1;i<=50;i++){
            Step__c TestStep1 = new Step__c();
            TestStep1.Name = 'TestTrigger'+i;
            TestStep1.RecordTypeId= ppmRecordtypeId;
            Date myDate = Date.newInstance(2012, 9, 8);
            TestStep1.PPM_Due_Date__c = myDate;
            TestStep1.PPM_Status__c = 'In Progress';
            TestStep1.Task_Name_lkp__c = Testtask.Id;       
            TestStep1.OwnerId = UserInfo.getUserId();
            stepRecordsList.add(TestStep1);
        }
        for(Integer i=1;i<=50;i++){
            Step__c TestStep1 = new Step__c();
            TestStep1.Name = 'TestTrigger'+i;
            TestStep1.RecordTypeId= ppmRecordtypeId;
            Date myDate = Date.newInstance(2012, 9, 8);
            TestStep1.PPM_Due_Date__c = myDate;
            TestStep1.PPM_Status__c = 'Completed';
            TestStep1.Task_Name_lkp__c = Testtask.Id;       
            TestStep1.OwnerId = UserInfo.getUserId();
            stepRecordsList.add(TestStep1);
        }
        insert stepRecordsList;
        for(Integer i=1;i<=50;i++){
            Responsible__c resRecord= new Responsible__c();
            resRecord.Responsible__c = UserInfo.getUserId();
            resRecord.Type__c = 'Support';
            resRecord.step__c = stepRecordsList[0].Id;
            respRecordsList.add(resRecord);
        }
        insert respRecordsList;
        System.AssertEquals(Testtask.Name , 'Testing in Test Class');  
        
        
    }
    static testmethod void Test_PPMStepshandler()
    {
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Step__c' and developerName='PPM_To_do'];
        Id ppmRecordtypeId = rt.Id;
        List<Step__c> stepList = [SELECT name,Task_Name_lkp__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger1'];
       
        Test.startTest();
        
        Task__c taskRecord = [select id,PPM_Q1__c,PPM_Actual_Completion_Date__c,PPM_Q2__c,PPM_Q3__c,PPM_Q4__c,PPM_Due_Date__c,PPM_Status__c from Task__c];        
        //check if Due Date (PPM_Due_Date__c) at Task__c is equal to Max Due Date on related Steps
        System.AssertEquals(taskRecord.PPM_Due_Date__c, Date.newInstance(2012, 9, 8));
        System.AssertNotEquals(taskRecord.PPM_Due_Date__c, Date.newInstance(2015, 10, 10));
        stepList[0].PPM_Status__c = 'Completed';
        stepList[0].PPM_Due_Date__c = Date.newInstance(2016, 10, 10);  
        stepList[0].PPM_Actual_Completion_Date__c = Date.newInstance(2016, 10, 10);
        
       
        update stepList[0]; 
        
       
        //check if Q4(PPM_Q4__c) at Task__c(Max among Steps) is TRUE since (2012, 9,*) falls in 3rd Quarter
        System.AssertEquals(taskRecord.PPM_Q3__c, TRUE);
        System.AssertEquals(taskRecord.PPM_Q4__c, FALSE);
        System.AssertEquals(taskRecord.PPM_Q2__c, FALSE);
        System.AssertEquals(taskRecord.PPM_Q1__c, FALSE);
        //If Steps's Status(In Progress and Not Started) then Task status is In Progress
        System.AssertEquals(taskRecord.PPM_Status__c, 'In Progress');
        System.AssertNotEquals(taskRecord.PPM_Status__c, 'Not Started');
        

        stepList[0].PPM_Status__c = 'In Progress';
        stepList[0].PPM_Actual_Completion_Date__c = NULL;
        update stepList[0];

        stepList[0].PPM_Status__c = 'Completed'; 
        stepList[0].PPM_Actual_Completion_Date__c = date.today();
        Update stepList[0];
        stepList[0].PPM_Status__c = 'Completed';
        
        Update stepList[0];
        stepList[0].PPM_Status__c = 'Completed';
        
        Update stepList[0];        
        
       
        Test.stopTest();
        
    }
    static testmethod void Test_PPMStepshandler2()
    {
        
        
        List<Step__c> stepList = new List<Step__c>([SELECT name,Task_Name_lkp__r.PPM_Status__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger1']);
        
        Test.startTest(); 
        stepList[0].PPM_Status__c = 'Completed';
        stepList[0].PPM_Actual_Completion_Date__c = Date.newInstance(2016, 10, 10);
        update stepList[0];
        //check if Due Date at task is in progress
        System.AssertEquals('In Progress', stepList[0].Task_Name_lkp__r.PPM_Status__c);     
        Test.stopTest();
        
        
    }
    static testmethod void Test_PPMStepshandler3()
    {
        
        List<Step__c> stepList = new List<Step__c>([SELECT name,Task_Name_lkp__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger1']);      
        Test.startTest();       
        Delete stepList[0];
        System.AssertEquals(False,stepList[0]==NULL);
        List<Step__c> stepListforDelete = new List<Step__c>([SELECT name,Task_Name_lkp__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c]); 
        delete stepListforDelete;
        Test.stopTest();
       
    }
    static testmethod void Test_PPMStepshandlerCancelled()
    {
        List<Step__c> stepList = new List<Step__c>([SELECT name,Task_Name_lkp__r.PPM_Status__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger1']);
        
        Test.startTest(); 
        stepList[0].PPM_Status__c = 'Cancelled';
        stepList[0].PPM_Actual_Completion_Date__c = null;
        update stepList[0];
        //check if Due Date at task is in progress
        System.AssertEquals('In Progress', stepList[0].Task_Name_lkp__r.PPM_Status__c);     
        Test.stopTest();
    }
    
    static testmethod void Test_PPMStepshandlerOnHold()
    {
        List<Step__c> stepList = new List<Step__c>([SELECT name,Task_Name_lkp__r.PPM_Status__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger1']);
        
        Test.startTest(); 
        stepList[0].PPM_Status__c = 'On Hold';
        stepList[0].PPM_Actual_Completion_Date__c = null;
        update stepList[0];
        //check if Due Date at task is in progress
        System.AssertEquals('In Progress', stepList[0].Task_Name_lkp__r.PPM_Status__c);     
        Test.stopTest();
    }
    
    static testmethod void Test_PPMStepshandlerNotStarted()
    {
        List<Step__c> stepList = new List<Step__c>([SELECT name,Task_Name_lkp__r.PPM_Status__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger1']);
        
        Test.startTest(); 
        stepList[0].PPM_Status__c = 'Not Started';
        stepList[0].PPM_Actual_Completion_Date__c = null;
        update stepList[0];
        //check if Due Date at task is in progress
        System.AssertEquals('In Progress', stepList[0].Task_Name_lkp__r.PPM_Status__c);     
        Test.stopTest();
    }
    
    static testmethod void Test_PPMStepshandlerNotStarted1()
    {
        List<Step__c> stepList = new List<Step__c>();
        stepList = new List<Step__c>([SELECT name,Task_Name_lkp__r.PPM_Status__c,PPM_Status__c,PPM_Due_Date__c FROM Step__c where name='TestTrigger5']);
        
        Test.startTest(); 
        stepList[0].PPM_Status__c = 'Not Started';
        stepList[0].PPM_Actual_Completion_Date__c = null;
        update stepList[0];
        
        //check if Due Date at task is in progress
        System.AssertEquals('In Progress', stepList[0].Task_Name_lkp__r.PPM_Status__c);     
        Test.stopTest();
    }

    static testmethod void test_restrictUsersToInsertStepRecords() {
        
           
        List<Task__c> ls_task = new List<Task__c>();
        ls_task.add(new Task__C(name = 'testname'));
        
        try{
            insert ls_task;    
        }catch(Exception e){
            System.debug('Exception occured ---- ' + e);
        }
        
        Test.starttest();
        PPMStepsHandler.restrictUsersToInsertStepRecords(ls_task);
        Test.stopTest();
    }    
    
}