/**
* @author TCS Developer
* @date 09/25/2014
* @module PPM
* @usage Trigger handler class
* @description This class inserts the Standard Event and Milestone on the insertion of the Task. 
* @version history
    1. TCS Developer - 07/23/2015 - PPM merge,added function restrictUsersToEditTaskRecords(List<Task__c> newTaskRecords)
*/
public class WorkPlanTaskTriggerHandler {
  
    public static Boolean TriggerDisabled = false;
    
    public Boolean IsDisbaled()
    {
           
        TriggerDisabledSettings__c ObjTriggerDisabled= TriggerDisabledSettings__c.getValues('DS1');    
                
        if(ObjTriggerDisabled!=null)
        {
            if(ObjTriggerDisabled.DisableTrigger__c== true)
            {
                return true;
            }
            else
            {
                return TriggerDisabled;
            }
        }
     return false;
    }
   
    public static void deleteTask(List<Task__c> oldTaskListforDelete){
        Set<String> tskSet = new Set<String>(); 
        for(Task__c t : oldTaskListforDelete){
            if(t.Is_Mandatory__c==false){
                tskSet.add(t.Id);   
            }          
            else if(t.Is_Mandatory__c==true){
                t.adderror('You are Not allowed to delete Mandatory Task.');
            }
        }
    }      
    
    
   
}