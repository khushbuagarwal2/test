/**
* @author TCS Developer
* @date 09/24/2014
* @module PPM
* @usage Class
* @description   Class to create Test Data
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
public with sharing class WorkPlanTestUtility {
  
     // Inserting Single User with Profile - 
    public static User singleUser(String profilename){
        
        Profile p                                   = [select Id,name from Profile where name=:profilename  limit 1];
        User newUser                                = new User(
            profileId                               = p.id,
            username                                = System.now().millisecond() + 'PortalUser@yahoo.com',
            email                                   = 'portal@ff.com',
            emailencodingkey                        = 'UTF-8',
            localesidkey                            = 'en_US',
            languagelocalekey                       = 'en_US',
            timezonesidkey                          = 'America/Los_Angeles',
            alias                                   ='nuser',
            lastname                                ='user',
            country                                 = 'TestCountry'
         ); 
        
        return newUser;    
    }
    
     //create single Account, Need to change the API Names of Address fields
     public static Account createTestAccount(){
        Account acc                             = new Account();
        acc.name                                ='Testusr';
       // acc.Short_Name__c                       = 'MOH';        
        //acc.Address_line_1__c                   = 'Test Address 1';
        //acc.Address_line_2__c                   = 'Test Address 2';
        //acc.Address_line_3__c                   = 'Test Address 3';
        //acc.Short_Name__c                       = 'MOH';
        //acc.Country__c                          = country_Id ;     
        return acc;
     }
     //single Contact Creation 
   /* public static Contact createTestContact(Id Account_Id)
    {
        Contact tempContact                     = new Contact(); 
        tempContact.lastName                    = 'testContact 1';        
        tempContact.AccountId                   = Account_Id;
        tempContact.Email                       = 'testAccount@test.com';
        return tempContact;
    }*/
    
    //create Milestone
    /* public static Step__c createMileStone(Id User_Id ,Id MileStone_Id,Id Task_Id)
    {
        Step__c mileStoneRecord            = new Step__c(); 
        mileStoneRecord.Name                    = 'Test MileStone';      
        mileStoneRecord.Original_Predecessors__c         = MileStone_Id;
        mileStoneRecord.Task_Name_lkp__c                 = Task_Id;
        mileStoneRecord.Original_Duration__c             = 60;
        mileStoneRecord.Original_Due_Date__c       = Date.Today()+8;
        return mileStoneRecord;
    }
    //create multiple Milestone records
    public static List<Step__c> createMultipleMileStone(Id User_Id ,Id MileStone_Id,Id Task_Id){
        List<Step__c> mileStoneList = new List<Step__c>();
        for(Integer i=0;i<3;i++){
            Step__c mileStoneRecord            = new Step__c(); 
            mileStoneRecord.Name                    = 'Test MileStone'+i;       
            mileStoneRecord.Original_Predecessors__c         = MileStone_Id;
            mileStoneRecord.Task_Name_lkp__c                 = Task_Id;
            mileStoneRecord.Original_Duration__c             = 60;
            mileStoneList.add(mileStoneRecord);
        }
        return mileStoneList;
    }*/
     //create Milestone Without Parent MileStone
     public static Step__c createMileStoneWithoutParentMileStone(Id User_Id ,Id Task_Id)
    {
        Step__c mileStoneRecord            = new Step__c(); 
        mileStoneRecord.Name                    = 'Test MileStone';
        mileStoneRecord.Task_Name_lkp__c                 = Task_Id;
        mileStoneRecord.Original_Duration__c             = 60;      
        return mileStoneRecord;
    }
    
    
    
  
    //create Single Task
   //We dont need 'Grant_Making' so commenting whole method(by Razia)
  /* public static Task__c createTask( Id User_Id)
    {
        RecordType rt = [SELECT id FROM RecordType WHERE DeveloperName='Grant_Making' AND SobjectType='Task__c' LIMIT 1];        
        Task__c TaskRecord                      = new Task__c(); 
        TaskRecord.Comments__c                  = 'Test Comments';
       
        TaskRecord.Status__c                    = 'In Progress;';
        TaskRecord.Name                = 'Test Task';
        TaskRecord.Task_Name__c                 = 'Training Plan';
        TaskRecord.RecordTypeId = rt.Id;
        return TaskRecord;
    }*/
     //create Multiple Task
    /*public static List<Task__c> createMultipleTaskRecords(Id User_Id,Id ImplementationPeriod_Id)
    {
         List<Task__c> TaskRecordList                  = new List<Task__c>();
         for(Integer i=0;i<2;i++){  
            Task__c TaskRecord                      = new Task__c();             
            TaskRecord.Comments__c                  = 'Test Comments';
            TaskRecord.Grant_Name__c     = ImplementationPeriod_Id;   
            TaskRecord.Status__c                    = 'In Progress;';
            TaskRecord.Name                = 'Test Task';
            TaskRecord.Task_Name__c                 = 'Training Plan';
            TaskRecordList.add(TaskRecord);
            
         }
         return TaskRecordList;
    }
    //create Custom-Settimg-Milestone_Lookup(Milestone_Lookup__c) Record
     public static Milestone_Lookup__c createMilestoneLookup(String milestone,String predecessor,String Task_Name){
        Milestone_Lookup__c mileLookUp = new Milestone_Lookup__c();
        mileLookUp.Name = 'Test MileLookUp1';
        mileLookUp.Duration__c = 50;
        mileLookUp.Milestone__c = milestone;
        mileLookUp.Predecessor__c = predecessor;
        mileLookUp.Task_Name__c = Task_Name;
        
        
        return mileLookUp;
     }
     //create multiple of Milestone Lookup records
     public static List<Milestone_Lookup__c> createMultipleMilestoneLookupRecords(String milestone,String predecessor,String Task_Name){
        List<Milestone_Lookup__c> mileStoneLookUpList = new List<Milestone_Lookup__c>();
        for(Integer i=0;i<50;i++){            
            Milestone_Lookup__c mileLookUp = new Milestone_Lookup__c();
            mileLookUp.Name = 'Test MileLookUp'+Math.Random();
            mileLookUp.Duration__c = 50;
            mileLookUp.Milestone__c = milestone;
            mileLookUp.Predecessor__c = predecessor;
            mileLookUp.Task_Name__c = Task_Name;
            mileStoneLookUpList.add(mileLookUp);
        }
        return mileStoneLookUpList;
     }
     //create Custom-Setting-Task_Lookup(Task_Lookup__c) Record
     public static Task_Lookup__c createTaskLookup(String grantCycle,String predecessor,String Task_Name){
        Task_Lookup__c taskLookUp = new Task_Lookup__c();
        taskLookUp.Name = 'Test MileLookUp1';
        taskLookUp.Task_Type__c = Task_Name;
        TaskLookUp.Grant_Cycle__c = grantCycle;
        
        
        return taskLookUp;
     }
      //create multiple of Task Lookup records
     public static List<Task_Lookup__c> createMultipleTaskLookupRecords(String grantCyle,String Task_Name){
        List<Task_Lookup__c> TaskLookUpList = new List<Task_Lookup__c>();
        for(Integer i=0;i<50;i++){            
            Task_Lookup__c TaskLookUp = new Task_Lookup__c();
            TaskLookUp.Name = 'Test MileLookUp'+Math.Random();
            TaskLookUp.Grant_Cycle__c = grantCyle;
            TaskLookUp.Task_Type__c = Task_Name;
            
            TaskLookUpList.add(TaskLookUp);
        }
        return TaskLookUpList;
     }
      //create multiple of Responsible records
      
     public static List<Responsible__c> createMultipleResponsibleRecords(Id taskId, Id stepId,Id userId){
        List<Responsible__c> responsibleList = new List<Responsible__c>();
        for(Integer i=0;i<50;i++){            
            Responsible__c res = new Responsible__c();
            res.Responsible__c = userId;
            res.Task__c = taskId;
            res.Step__c = stepId;
            
            responsibleList.add(res);
        }
        return responsibleList;
     }
     */
     //create country
     
     public static Aim_Geography__c createCountry(){
         Aim_Geography__c cont = new Aim_Geography__c();
         cont.Name = 'Test Country';
         //cont.X200DEMA_Exch_Rate_in_EUR__c = 80;
         //cont.X200DEMA_Exch_Rate_in_USD__c = 60;
         //cont.X200DEMA_Exch_Rate_Last_Updated_Date__c = Date.Today()+50;
         
         return cont;
     }
     
    // public static Country__c createCountry(Id ctPublicgroupId){
         //Country__c cont = new Country__c();
         //cont.Name = 'Test Country';
         //cont.CT_Public_Group_ID__c = ctPublicgroupId;
         //cont.X200DEMA_Exch_Rate_in_EUR__c = 80;
         //cont.X200DEMA_Exch_Rate_in_USD__c = 60;
         //cont.X200DEMA_Exch_Rate_Last_Updated_Date__c = Date.Today()+50;
         
       //  return cont;
     //}
     
     //create group member
     
   /*  public static GroupMember createGrpMember(){
         GroupMember grpMember = new GroupMember();
         
         
         return grpMember;
    }*/
    
    //create Single of Responsible records for Task
      
     public static List<Responsible__c> createSingleTaskResponsibleRecords(Id taskId,Id userId){
        List<Responsible__c> responsibleList = new List<Responsible__c>();               
            Responsible__c res = new Responsible__c();
            res.Responsible__c = userId;
            res.Task__c = taskId;
            
            responsibleList.add(res);
        
        return responsibleList;
     }
     
     //create Single of Responsible records for Step
      
     public static List<Responsible__c> createSingleStepResponsibleRecords(Id stepid,Id userId){
        List<Responsible__c> responsibleList = new List<Responsible__c>();               
            Responsible__c res = new Responsible__c();
            res.Responsible__c = userId;
            res.Step__c = stepId;
            
            responsibleList.add(res);
        
        return responsibleList;
     }
     
     //test method created by tejas
     //create Single Task
  /*  public static Task__c createTask2( Id User_Id,Id ImplementationPeriod_Id)
    {
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'PPM_Key_Activity'];        
        Task__c TaskRecord                      = new Task__c(); 
        TaskRecord.Comments__c                  = 'Test Comments';
        TaskRecord.Grant_Name__c                =  ImplementationPeriod_Id;        
        TaskRecord.Status__c                    = 'In Progress;';
        TaskRecord.Name                = 'Test Task';
        TaskRecord.Task_Name__c                 = 'Training Plan';
        TaskRecord.RecordTypeId = rt.Id;
        return TaskRecord;
    }*/
    
    //create Single Task tejas
  //we dont need 'Concept_Note' hence commenting whole method(by Razia)
  /*  public static Task__c createTask3( Id User_Id)
    {
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Concept_Note' AND SobjectType = 'Task__c'];        
        Task__c TaskRecord                      = new Task__c(); 
        TaskRecord.Comments__c                  = 'Test Comments';
         
        TaskRecord.Status__c                    = 'In Progress;';
        TaskRecord.Name                = 'Test Task';
        TaskRecord.Task_Name__c                 = 'Training Plan';
        TaskRecord.RecordTypeId = rt.Id;
        return TaskRecord;
    }    */     
    //create Board Planner task
   /* public static Task__c createBoardPlannerTask( Id User_Id)
    {
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Board_Planner' AND SobjectType = 'Task__c'];        
        Task__c TaskRecord                      = new Task__c(); 
        TaskRecord.Comments__c                  = 'Test Comments';
        TaskRecord.Status__c                    = 'In Progress;';
        TaskRecord.Name                         = 'Test Task';
        TaskRecord.Task_Name__c                 = 'Board Plan Task';
        TaskRecord.RecordTypeId = rt.Id;
        return TaskRecord;
    }  */ 
    //create Single Task with record type PPM_Key_Activity
    public static Task__c createTask4( String recordTypeName)
    {
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName =:recordTypeName AND SobjectType = 'Task__c'];        
        Task__c TaskRecord                      = new Task__c(); 
        TaskRecord.Comments__c                  = 'Test Comments';
         
        TaskRecord.Status__c                    = 'In Progress;';
        TaskRecord.Name                         = 'Test Task';
        TaskRecord.Task_Name__c                 = 'Training Plan';
        TaskRecord.RecordTypeId = rt.Id;
        return TaskRecord;
    }         
}