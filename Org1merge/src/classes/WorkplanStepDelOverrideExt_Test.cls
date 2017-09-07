/**
* @author TCS Developer
* @date 10/01/2015
* @module PPM
* @usage Test Class
* @description  Test class for WorkplanTaskDelOverrideExt 
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
@isTest

public class WorkplanStepDelOverrideExt_Test {

  public static String profilename = 'System Administrator';
        
    public static testMethod void testingStepDelOverrideExt ()
    {
           
            TriggerDisabledSettings__c ObjTriggerDisabled= new TriggerDisabledSettings__c();
            ObjTriggerDisabled.name = 'DS1';
            ObjTriggerDisabled.DisableTrigger__c = False;
            insert   ObjTriggerDisabled;           
            User newUser=WorkPlanTestUtility.singleUser(profilename);
            insert newUser;
                   
            Task__c taskRecord4=WorkPlanTestUtility.createTask4('PPM_Key_Activity');  
            taskRecord4.PPM_Status__c= 'Cancelled';
            insert taskRecord4; 
        
             
            Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord4.Id);
            stepRecord.Name = 'testForDelete';
            stepRecord.PPM_Status__c = 'Not Started';
            stepRecord.Original_Due_Date__c = System.today()+5;
            stepRecord.Due_Date__c = System.today()+5;
            stepRecord.PPM_Due_Date__c = System.today()+5;
                      
        
             Step__c stepRecord1 = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord4.Id);
            stepRecord1.Name = 'testForDelete';
            stepRecord1.PPM_Status__c = 'In Progress';
            stepRecord1.Original_Due_Date__c = System.today()+5;
            stepRecord1.Due_Date__c = System.today()+5;
            stepRecord1.PPM_Due_Date__c = System.today()+5;
                      
            
            Step__c stepRecord2 = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord4.Id);
            stepRecord2.Name = 'testForDelete';
            stepRecord2.PPM_Status__c = 'Completed';
            stepRecord2.Original_Due_Date__c = System.today()+5;
            stepRecord2.Due_Date__c = System.today()+5;
            stepRecord2.PPM_Due_Date__c = System.today()+5;
            stepRecord2.PPM_Actual_Completion_Date__c =System.today()+5;
            

            Step__c stepRecord3 = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord4.Id);
            stepRecord3.Name = 'testForDelete';
            stepRecord3.PPM_Status__c = 'Cancelled';
            stepRecord3.Original_Due_Date__c = System.today()+5;
            stepRecord3.Due_Date__c = System.today()+5;
            stepRecord3.PPM_Due_Date__c = System.today()+5;
                    
        
            Step__c stepRecord4 = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord4.Id);
            stepRecord4.Name = 'testForDelete';
            stepRecord4.PPM_Status__c = 'On Hold';
            stepRecord4.Original_Due_Date__c = System.today()+5;
            stepRecord4.Due_Date__c = System.today()+5;
            stepRecord4.PPM_Due_Date__c = System.today()+5;
                               
            List<Step__c> listOfStep = new List<Step__c>{stepRecord,stepRecord1,stepRecord2,stepRecord3,stepRecord4};
          
        
            List<Responsible__c> responsibleRecList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord4.Id,newUser.Id);
            
        
            List<Task__c> listOfTask = new List<Task__c>();
            listOftask.add(taskRecord4);
            WorkplanStepDelOverrideExt.restrictUsersToDeleteStepRecords(listOftask);
        
           
            ApexPages.StandardController stdCtrl;
            WorkplanStepDelOverrideExt oDelOverExt;
            PageReference pageRef;
            
            TEST.startTest();  
            insert listOfStep;
            insert responsibleRecList;
            stdCtrl = new ApexPages.StandardController(stepRecord);                     
            oDelOverExt=new WorkplanStepDelOverrideExt(stdCtrl);
            pageRef = oDelOverExt.checkDelete();
            System.assertNotEquals(null,pageRef ); 
        
                
            
            stdCtrl = new ApexPages.StandardController(stepRecord);                     
            oDelOverExt=new WorkplanStepDelOverrideExt(stdCtrl);
            pageRef = oDelOverExt.checkDelete();
            PageReference newPage = new PageReference('You are not allowed to add/edit this Step since you are not Responsible');
            System.assertNotEquals(newPage ,pageRef); 
                    
            TEST.stopTest();
    
    }

}