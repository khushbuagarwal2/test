/**
* @author TCS Developer
* @date 08/05/2015 
* @module PPM
* @usage Test class
* @description Test class for PPMAssignedToHandler
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
@isTest
private class PPMAssignedToHandler_Test{
    public static String profilename = 'Procurement User';
    static testmethod void TestAssignedTo(){
        RecordType rt = [select id,Name from RecordType where SobjectType='Responsible__c' and developerName='Responsible_for_PPM_Key_activity'];
        Id ppmRecordtypeId = rt.Id;
        
        String ppmKeyActRecType = '';
        String ppmTravelPlanRecType = '';
        String recTravelSteps = '';
        String recTodo = '';
        String ppmTravelDetailsRecType = '';
        String recAsgnToKeyAct = '';
        String recAsgnToTravelPlan = '';
        String recAsgnToTodo = '';
        String recAsgnToTravelSteps = '';
        List<RecordType> listRecType = new List<RecordType>();
        listRecType = [select Id,DeveloperName, sObjectType from RecordType where DeveloperName in ('PPM_Key_Activity','PPM_Travel_Plan','Travel_Task',
                        'PPM_To_do','PPM_Travel_details','Responsible_for_PPM_Key_activity','Responsible_for_PPM_To_do',
                        'Responsible_for_PPM_Travel_details','Responsible_for_PPM_Travel_plan'
                        ) AND sObjectType IN('Task__c','Step__c','Responsible__c') ];
        for(RecordType rec : listRecType){            
            if(rec.DeveloperName == 'PPM_Key_Activity' && rec.sObjectType == 'Task__c'){
                ppmKeyActRecType = rec.Id;
            }else if(rec.DeveloperName == 'PPM_Travel_Plan' && rec.sObjectType == 'Task__c'){
                ppmTravelPlanRecType = rec.Id;
            }else if(rec.DeveloperName == 'Travel_Task' && rec.sObjectType == 'Task__c'){
                recTravelSteps = rec.Id;
            }else if(rec.DeveloperName == 'PPM_To_do' && rec.sObjectType == 'step__c'){
                recTodo = rec.Id;
            }else if(rec.DeveloperName == 'PPM_Travel_details' && rec.sObjectType == 'step__c'){
                ppmTravelDetailsRecType = rec.Id;
            }else if(rec.DeveloperName == 'Responsible_for_PPM_Key_activity' && rec.sObjectType == 'Responsible__c'){
                recAsgnToKeyAct = rec.Id;
            }else if(rec.DeveloperName == 'Responsible_for_PPM_To_do' && rec.sObjectType == 'Responsible__c'){
                recAsgnToTodo = rec.Id;            
            }else if(rec.DeveloperName == 'Responsible_for_PPM_Travel_details' && rec.sObjectType == 'Responsible__c'){
                recAsgnToTravelPlan = rec.Id;
            }else if(rec.DeveloperName == 'Responsible_for_PPM_Travel_plan' && rec.sObjectType == 'Responsible__c'){
                recAsgnToTravelSteps = rec.Id;
            }
            
        }
        User newUser = WorkPlanTestUtility.singleUser(profilename);
        newUser.lastname = 'TestSupportUser';
        insert newUser;        
        User newUser2 = WorkPlanTestUtility.singleUser(profilename);
        newUser2.lastname = 'TestLeadUser';
        insert newUser2; 
        //create Account
        Account AccountRecord = WorkPlanTestUtility.createTestAccount();
        insert AccountRecord;
       
    }
    static testmethod void TestDuplicateResponsible(){
        
        /* Adding Custom Setting Test Data -- By Pankaj */
        
        TriggerDisabledSettings__c ObjTriggerDisabled= new TriggerDisabledSettings__c();
        ObjTriggerDisabled.name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert   ObjTriggerDisabled;
        
        /* Ends Adding Custom Setting Test Data by Pankaj */
        
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Responsible__c' and developerName='Responsible_for_PPM_Key_activity'];
        Id ppmRecordtypeId = rt.Id;
        
        String ppmKeyActRecType = '';
        String ppmTravelPlanRecType = '';
        String recTravelSteps = '';
        String recTodo = '';
        String ppmTravelDetailsRecType = '';
        String recAsgnToKeyAct = '';
        String recAsgnToTravelPlan = '';
        String recAsgnToTodo = '';
        String recAsgnToTravelSteps = '';
        List<RecordType> listRecType = new List<RecordType>();
        listRecType = [select Id,DeveloperName, sObjectType from RecordType where DeveloperName in ('PPM_Key_Activity','PPM_Travel_Plan','Travel_Task',
                        'PPM_To_do','PPM_Travel_details','Responsible_for_PPM_Key_activity','Responsible_for_PPM_To_do',
                        'Responsible_for_PPM_Travel_details','Responsible_for_PPM_Travel_plan'
                        ) AND sObjectType IN('Task__c','Step__c','Responsible__c') ];
        for(RecordType rec : listRecType){            
            if(rec.DeveloperName == 'PPM_Key_Activity' && rec.sObjectType == 'Task__c'){
                ppmKeyActRecType = rec.Id;
            }else if(rec.DeveloperName == 'PPM_Travel_Plan' && rec.sObjectType == 'Task__c'){
                ppmTravelPlanRecType = rec.Id;
            }else if(rec.DeveloperName == 'Travel_Task' && rec.sObjectType == 'Task__c'){
                recTravelSteps = rec.Id;
            }else if(rec.DeveloperName == 'PPM_To_do' && rec.sObjectType == 'step__c'){
                recTodo = rec.Id;
            }else if(rec.DeveloperName == 'PPM_Travel_details' && rec.sObjectType == 'step__c'){
                ppmTravelDetailsRecType = rec.Id;
            }else if(rec.DeveloperName == 'Responsible_for_PPM_Key_activity' && rec.sObjectType == 'Responsible__c'){
                recAsgnToKeyAct = rec.Id;
            }else if(rec.DeveloperName == 'Responsible_for_PPM_To_do' && rec.sObjectType == 'Responsible__c'){
                recAsgnToTodo = rec.Id;            
            }else if(rec.DeveloperName == 'Responsible_for_PPM_Travel_details' && rec.sObjectType == 'Responsible__c'){
                recAsgnToTravelPlan = rec.Id;
            }else if(rec.DeveloperName == 'Responsible_for_PPM_Travel_plan' && rec.sObjectType == 'Responsible__c'){
                recAsgnToTravelSteps = rec.Id;
            }
            
        }
              
        User newUser2 = WorkPlanTestUtility.singleUser(profilename);
        newUser2.lastname = 'TestSupportUser';
        insert newUser2; 
        //create Account
        Account AccountRecord = WorkPlanTestUtility.createTestAccount();
        insert AccountRecord;
        Test.startTest();
       
        //create Task Record
        Task__c taskRecord = PPMTestUtility.createTask();       
        taskRecord.PPM_Workstream__c='Business Planning';
        taskRecord.PPM_Component__c='Financial Forecast & Management';
        taskRecord.RecordTypeId = ppmKeyActRecType;
        insert taskRecord;
        
        //create responsible for the task created        
        List<Responsible__c> responsibleTaskList = WorkPlanTestUtility.createSingleTaskResponsibleRecords(taskRecord.Id ,newUser2.Id);
        for(Responsible__c res: responsibleTaskList){
            res.recordtypeId = recAsgnToKeyAct;
            res.type__c='Support';
           
        }
       
        insert responsibleTaskList;        
       
        List<User> userRec = [select name from user where id =:responsibleTaskList[0].Responsible__c ORDER BY Name];
        Task__c taskRec= [SELECT id,PPM_Leads__c,PPM_Support__c FROM Task__c];   
        
        //verify Lead and support fields at Task   
        System.assertEquals(userRec[0].name,taskRec.PPM_Support__c);
        System.assertNotEquals(userRec[0].name,taskRec.PPM_Leads__c);
        responsibleTaskList[0].type__c='Lead';
        responsibleTaskList[0].Responsible__c = newUser2.Id;
        update responsibleTaskList[0];     
        Test.stopTest();  
        
    }
}