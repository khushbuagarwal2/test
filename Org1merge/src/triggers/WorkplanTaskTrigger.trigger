/**
* @author TCS Developer
* @date 01/29/2015
* @module PPM
* @usage Trigger
* @description This Trigger inserts the Standard Event and Step Records on the basis of 
               Step Template Administrator Custom Setting-(Milestone_Lookup__c)
               on the insertion of the Task. 
* @version history
    1. TCS Developer - 09/25/2014 - Merged code of Trigger-Workplan_ontaskinsert on Task__c Dated 
    2. TCS Developer - 07/13/2015 - Updated Code due to merging on PPM in WorkPlanning By TCS Developer
*/
trigger WorkplanTaskTrigger on Task__c (before insert, before update, before delete, after insert, after update, after delete){
    List<RecordType> workPlanTaskRecordTypeList = new List<RecordType>([select Id,DeveloperName from RecordType where SObjectType = 'Task__c']);
    //Map with Key:WorkPlanTask Record type Id and Value:WorkPlanTask ReccordType Developer Name
    Map<Id,String> Map_Key_TaskRecordTypeId_Value_TaskDevplrName = new Map<Id,String>();
    //Map with Key:Task Record Id and Value:Task Record(in Trigger.new)
    Map<Id,Task__c> PPMMapOfNewTaskRecords = new Map<Id,Task__c>();
    //Map with Key:Task Record Id and Value:Task Record(in Trigger.old)
    Map<Id,Task__c> PPMMapOfOldTaskRecords = new Map<Id,Task__c>();
    for(RecordType rect:workPlanTaskRecordTypeList){
        Map_Key_TaskRecordTypeId_Value_TaskDevplrName.put(rect.Id,rect.DeveloperName);  
    }
    List<Task__c> workPlanningNewTaskRecords = new List<Task__c>();
    List<Task__c> workPlanningOldTaskRecords = new List<Task__c>();
    
    if(Trigger.isInsert||Trigger.isUpdate){
        
        for(Task__c taskRec:Trigger.new){            
            if(Map_Key_TaskRecordTypeId_Value_TaskDevplrName.get(taskRec.RecordTypeID)=='PPM_Key_Activity'|| 
                    Map_Key_TaskRecordTypeId_Value_TaskDevplrName.get(taskRec.RecordTypeID)=='PPM_Travel_Plan'
            ){
                PPMMapOfNewTaskRecords.put(taskRec.Id,taskRec);
            }
           
        }
    }
    if(Trigger.isUpdate||Trigger.isDelete){
        for(Task__c taskRec:Trigger.old){
            if(Map_Key_TaskRecordTypeId_Value_TaskDevplrName.get(taskRec.RecordTypeID)=='PPM_Key_Activity'|| 
                    Map_Key_TaskRecordTypeId_Value_TaskDevplrName.get(taskRec.RecordTypeID)=='PPM_Travel_Plan'
            ){
                PPMMapOfOldTaskRecords.put(taskRec.Id,taskRec);
            }
        }
    }
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
              if(PPMMapOfNewTaskRecords.SIZE()>0){
                PPMTaskTriggerHandler.restrictUsersToEditTaskRecords(PPMMapOfNewTaskRecords.Values(), Trigger.OldMap);
            }     
        }
        if(Trigger.isDelete){
           if(workPlanningOldTaskRecords.SIZE()>0){
               WorkPlanTaskTriggerHandler.deleteTask(workPlanningOldTaskRecords);
            }
        }   
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            if(workPlanningNewTaskRecords.SIZE()>0){
                list<Task__c> tsklst = new list<Task__c>();
                for(Task__c tsk : workPlanningNewTaskRecords){
                    if(tsk.Is_Clone__c == false){ // Checking whether the new task is not a cloned task
                        tsklst.add(tsk);
                    }
                }
            }
        }
        if(Trigger.isUpdate){
                       
        }
        if(Trigger.isDelete){
        
        }
    }
}