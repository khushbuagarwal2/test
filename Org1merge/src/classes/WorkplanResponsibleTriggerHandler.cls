/**
* @author TCS Developer
* @date 11/19/2014
* @module PPM
* @usage Test Class
* @description This Class is handler for Trigger-WorkPlanResponsibleTrigger. 
                Updates Responsible(Responsible__c) fields in Task and Step Objects with following Values:
                1. If More than one Child(Responsible)records then Responsible(Responsible__c) will be equal to Responsible
                  (Responsible__c on Responsible Object)User Names separated by Semicolons. 
                2. Blank if no related Responsible record. 
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/   
public class WorkplanResponsibleTriggerHandler {

    public static Boolean TriggerDisabled = false;
    
    public Boolean IsDisbaled()
    {
        TriggerDisabledSettings__c ObjTriggerDisabled= TriggerDisabledSettings__c.getValues('DS1');
       
        if(ObjTriggerDisabled.DisableTrigger__c== true)
        {
            return true;
        }
        else
        {
            return TriggerDisabled;
        }
    }
    
    public static void filterResponsibleToInsert(List <Responsible__c > ResponsibleListToFilter) {
           Set<Id> taskIds=new Set<Id>();            
           for (Responsible__c res: ResponsibleListToFilter) {
            if (res.Task__c != null){
                    taskIds.add(res.Task__c);
                }                
            }
           List<Responsible__c> listResp= new List<Responsible__c>();
           listResp=[SELECT Id,Responsible__c,Task__c FROM Responsible__c WHERE Task__c in :taskIds];      //Make Correct query               
            for(Responsible__c res: ResponsibleListToFilter) 
            {  
                for(Responsible__c resMaster:listResp)
                {
                  if(res.Task__c==resMaster.Task__c && res.Responsible__c==resMaster.Responsible__c)
                    {
                 
                      res.addError('Responsible already exist for this task');
                    }
                }
            }            
        }

    /**
    * @description Update responsible string on Task and STEP on addition of related Responsible record
    * @author TCS Developer
    * @date 11/19/2014
    * @param List<Responsible__c>
    * @return void
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
            
    public static void updateResponsiblestringOnTaskAndStepOnAdditonOfResp(List<Responsible__c> ResponsibleRecordsList) {
        //Task record Ids Set
        Set <Id> taskIds = new Set < Id > ();
        Set <Id> stepIds = new Set < Id > ();
        //Task records List
        List < Task__c > taskList = new List < Task__c > ();
        List < Task__c > taskListToUpdate = new List < Task__c > ();
        
        // Step records List
        List <Step__c> stepList = new List <Step__c> ();
        List <Step__c> stepListToUpdate = new List <Step__c> ();
        
            for (Responsible__c res: ResponsibleRecordsList) {
                if (String.isNotBlank(res.Step__c)) {
                    stepIds.add(res.Step__c);
                }
                if (String.isNotBlank(res.Task__c)) {
                    taskIds.add(res.Task__c);                    
                }
            }
            
        //--------- Adding Responsible string on TASK-------------------    
        if (taskIds.SIZE() > 0) {                
            //Query Task records and respective Responsible records with Task Ids
            taskList = [SELECT id, Responsible__c, ownerId, (SELECT id, Responsible__r.Name FROM Responsible__r) FROM Task__c WHERE ID IN: taskIds];
            //update Responsible field in Task with Responsible User Names separated by Semicolons          
            if (taskList.SIZE() > 0) {
                for (task__c tsk: taskList) {

                    List < String > responsibleNameList = new List < String > ();
                    Integer listSize = 0;
                    String responsibleNames = '';
                    if (tsk.Responsible__r.SIZE() > 0) {
                        for (Responsible__c res: tsk.Responsible__r) {
                            responsibleNameList.add(res.Responsible__r.Name);
                            responsibleNameList.add('; ');
                        }
                        listSize = responsibleNameList.SIZE();
                        responsibleNameList[listSize - 1] = '';
                        for (String name: responsibleNameList) {
                            responsibleNames = responsibleNames + name;
                        }
                    }
                    //update Responsible in respective Task
                    tsk.Responsible__c = responsibleNames;
                    taskListToUpdate.add(tsk);
                }
                if(!taskListToUpdate.isempty())
                update taskListToUpdate;
            }
        }
        
    //--------- Adding Responsible string on STEP-------------------
            
        if (stepIds.SIZE() > 0) {
            //Query Step records and respective Responsible records with step Ids
            stepList = [SELECT Responsible__c, Task_Name_lkp__r.Id, Task_Name_lkp__r.ownerId, (SELECT id, Responsible__r.Name FROM Responsible__r) FROM Step__c WHERE ID IN: stepIds];
            //update Responsible field in Step with Responsible User Names separated by Semicolons  
            for (Step__c step: stepList) {
                List < String > responsibleNameList = new List < String > ();
                Set < Id > userSet = new Set < Id > ();
                Integer listSize = 0;
                String responsibleNames = '';
                if (step.Responsible__r.SIZE() > 0) {
                    for (Responsible__c res: step.Responsible__r) {
                        if (res.Responsible__c != null && res.Responsible__c != step.Task_Name_lkp__r.ownerId) userSet.add(res.Responsible__c);
                        responsibleNameList.add(res.Responsible__r.Name);
                        responsibleNameList.add('; ');
                    }
                    listSize = responsibleNameList.SIZE();
                    responsibleNameList[listSize - 1] = '';
                    for (String name: responsibleNameList) {
                        responsibleNames = responsibleNames + name;
                    }
                }
                
                //update Responsible in respective Step
                step.Responsible__c = responsibleNames;
                stepListToUpdate.add(step);
            }
                if(!stepListToUpdate.isempty())
                update stepListToUpdate;
        }
    }
    
        
        /**
        * @description Update responsible string on Task and Step on deletion of Responsible record
        * @author TCS Developer
        * @date 11/19/2014
        * @param List<Responsible__c>
        * @return void
        * @version history
            1. Developer Name - MM/DD/ - Description
        */
        public static void updateResponsiblestringOnTaskAndStepOnDeletionOfResp( List<Responsible__c> ResponsibleRecforDelete) {
            List < Task__c > tsklistresponsibleUpdate =  new List < Task__c >();
            Set < Id > taskIds = new Set < Id > ();
            
            List < Step__c > steplistresponsibleUpdate =  new List < Step__c >();
            Set <Id> stepIds = new Set <Id> ();
           
            for (Responsible__c res: ResponsibleRecforDelete) {
               if (res.Task__c != null) 
                 taskIds.add(res.Task__c);
                if(res.Step__c != null)
                stepIds.add(res.Step__c);
            }
            
            for (Step__c stp: [Select id, Task_Name_lkp__c from step__c where id In: stepIds]) {
                taskIds.add(stp.Task_Name_lkp__c);
                }
                
          //------------TASK------------
           for (Task__c tsk: [Select id,Responsible__c, ownerId, (Select id from steps__r), (Select id, Task__c,Responsible__r.Name, step__c, Responsible__c from Responsible__r) from task__c where id IN: taskIds]) {
                String responsibleNames = '';
                 if (!tsk.steps__r.isEmpty()) {
                    for (Step__c s: tsk.steps__r) {
                        stepIds.add(s.Id);
                    }
                }
                if (!tsk.Responsible__r.isEmpty()) {
                    for (Responsible__c res: tsk.Responsible__r) {
                        responsibleNames += res.Responsible__r.Name +', ';
                        
                        }
                    }
               tsk.Responsible__c = responsibleNames.removeEnd(', ');
                tsklistresponsibleUpdate.add(tsk);
            }  
            if(!tsklistresponsibleUpdate.isempty())
            update tsklistresponsibleUpdate;
            
              //---------STEP----  
            for (Step__c stp: [Select id,Responsible__c, (Select id, Responsible__r.Name,step__c, Responsible__c from Responsible__r) from Step__c where Id IN: stepIds]) {
                 String responsibleNames = '';
                if (!stp.Responsible__r.isEmpty()) {
                    for (Responsible__c res: stp.Responsible__r) {
                         responsibleNames += res.Responsible__r.Name +', ';
                    }
                }
                
                stp.Responsible__c = responsibleNames.removeEnd(', ');
                steplistresponsibleUpdate.add(stp);
            }
             if(!steplistresponsibleUpdate.isempty())
                update steplistresponsibleUpdate;
        }
    }