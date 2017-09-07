/**
* @author TCS Developer
* @date 09/25/2014
* @module PPM
* @usage This Class is handler for Trigger-Workplan_StepTrigger.
* @description  1) If Step is Sequential then Scheduled Start Date(Scheduled_Start_Date__c) is equal to the
                 Due Date(Due_Date__c) from Predecessor(Step)
                2) Original Due Date = Original Due Date(From Predecessor)-Duratin(From Step custom Setting)
                3)Scheduled Start Date = Scheduled Due Date - Original Duration
                4)Execute Business rules in Step
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
public with sharing class WorkplanStepTriggerHandler {
    public static Date startDate;
    public static Date endDate;
    public static Integer startDateMonth;
    public static Integer endDateMonth;
    public static Integer startDateWeekNumber;
    public static Integer endDateWeekNumber;
    public static List<Step__c> allSteprecordsList;
    public static Integer stepIndex;
    
    
    public static Boolean TriggerDisabled = false;
    
    public static Boolean IsDisbaled()
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

   
    
   /* public static void executeBusinessRules(List<Step__c> stepRecordsList){
           
    }*/
    
      
    public static void deleteSteps(List<Step__c> oldStepsListforDelete){
        Set<String> stepsSet = new Set<String>(); 
        for(Step__c steps : oldStepsListforDelete){
            if(steps.Is_Mandatory__c==false){
                stepsSet.add(steps.Id);   
            }          
            else if(steps.Is_Mandatory__c==true){
                steps.adderror('You are Not allowed to delete Mandatory Step.');
            }
        }        
    }  
   
   
    /*public static Integer calculateWeekNumberOfDate(Date dtVal)
        {
            
             //Segregated Fields
             Integer year=dtVal.year();
             Integer month=dtVal.month();
             Integer dateOfMonth=dtVal.day();
             //To Calculate 
              Integer weekOfTheDate=0; 
              
              //FirstDateOftheMonth            
              Datetime dt = datetime.newInstanceGMT(year,month,1);          
              Integer daysBeforeMondayCount=0; 
              while(dt.formatGMT('EEE')!='Mon')
              {
                daysBeforeMondayCount++;
                dt=dt+1;
              }
              
              //FirstWeekCheck on Monday Basis
              Integer weekFirst=0;
              weekFirst=daysBeforeMondayCount>0?1:0;
              
              //Days Left After firstWeek filter
              Integer DaysLeftInMonth=dateOfMonth-daysBeforeMondayCount;
              
              //Week Count in Remaining Days 
              Integer WeekMid=DaysLeftInMonth/7;
              
              //Last Week Validity on remainder days count basis
              Integer DaysLeftLastWeek=math.mod(DaysLeftInMonth,7);
              Integer WeekLast=DaysLeftLastWeek>0?1:0;
              
              weekOfTheDate=weekFirst+WeekMid+WeekLast;
              return weekOfTheDate;
      }*/
      
    /**
    * @description Update Week Number
    * @author TCS Developer
    * @date 09/25/2014
    * @param List<Step__c> 
    * @return void
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
   /* public static void updateWeekNumber(List<Step__c> stepListforUpdate)
    {
        RecordType travelRecordType=new RecordType();
        travelRecordType=([SELECT DeveloperName,Id,Name FROM RecordType WHERE DeveloperName = 'Travel_Step']);
            //Start Date Values
            for(Step__c oStep:stepListforUpdate){
                if( oStep.RecordTypeId == travelRecordType.id){
                    if(oStep.Start_Date__c!=null)
                {
                    Integer year= oStep.Start_Date__c.year();
                    Integer month=oStep.Start_Date__c.month(); 
                    oStep.start_Month__c=month;
                    oStep.start_Year__c=year;
                    oStep.start_Caldate__c=oStep.Start_Date__c.day();
                    oStep.start_week__c=calculateWeekNumberOfDate(oStep.Start_Date__c);   
                 
                 
                }else
                {
                    oStep.start_Month__c=null;
                    oStep.start_Year__c=null;
                    oStep.start_week__c=null;
                    oStep.start_Caldate__c=null;
                }             
             //End date values
             
                if(oStep.End_Date__c!=null)
                {
                    Integer year= oStep.End_Date__c.year();
                    Integer month=oStep.End_Date__c.month();                                    
                    oStep.End_Month__c=month;
                    oStep.End_Year__c=year;
                    oStep.End_Caldate__c=oStep.End_Date__c.day();  
                    oStep.End_week__c=  calculateWeekNumberOfDate(oStep.End_Date__c);
                     
                }else
                {
                    oStep.End_Month__c=null;
                    oStep.End_Year__c=null;
                    oStep.End_week__c=null;
                    oStep.End_Caldate__c=null;
                }
            }
        }
    }
    */

    /**
    * @description This method is to calculate custom roll up fields on tasks, which are dependent on respective fields on steps.
    * @author TCS Developer
    * @date 09/25/2014
    * @param List<Step__c> 
    * @return void
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
    /*public static void updateCustomRollupsOnTasks(List<Step__c> stepRecords){    
    system.debug('$$$$ inside class');
    
        set<id> taskIds= new set<id>();
        list<Step__c> allSteps = new list<Step__c>();
        list<Task__c> taskToUpdate = new list<Task__c>();
        list<Step__c> stepList= new list<Step__c>();
        map<Task__c,list<Step__c>> mtaskSteps = new map<task__c,list<Step__c>>();
        boolean flag = false;        
        integer cancelStep=0; //to count the step having status as CANCEL 
        integer completeStep=0; //to count the step having status as COMPLETED
        integer inprogressStep=0; //to count the step having status as INPROGRESS
        integer ntstartStep=0; //to count the step having status as NOT STARTED        

        for(Step__c m : stepRecords){
            taskIds.add(m.Task_Name_lkp__c);
        }
        if(trigger.isdelete)
        {   
            for(Task__c tsk : [select id,RecordType.DeveloperName,Is_Mandatory__c ,Step_Completion_Date__c,Due_Date_rollup__c,Start_Date_rollup__c,End_Date_rollup__c,
                                (select Id,Status__c,Task_Name_lkp__c,Is_Mandatory__c,Actual_Completion_Date__c,Due_Date__c,Start_Date__c,End_Date__c 
                                from Steps__r where id NOT IN: stepRecords) 
                                from Task__c where id =: taskIds]){
                                
                mtaskSteps.put(tsk,tsk.Steps__r);                            
            }
        }
        else      
        {   
            for(Task__c tsk : [select id,RecordType.DeveloperName,Is_Mandatory__c ,Step_Completion_Date__c,Due_Date_rollup__c,Start_Date_rollup__c,End_Date_rollup__c,
                                (select Id,Status__c,Task_Name_lkp__c,Is_Mandatory__c,Actual_Completion_Date__c,Due_Date__c,Start_Date__c,End_Date__c from Steps__r) 
                                from Task__c where id =: taskIds]){            
                mtaskSteps.put(tsk,tsk.Steps__r);               
            }  
        }      
        
        for(task__c task : mtaskSteps.keySet()){
            Date tempDueDate;
            Date tempStartDate;
            Date tempEndDate;
            Date tempCompletionDate;
            
            stepList = new list<Step__c>();
            stepList = mtaskSteps.get(task);              
            for(Step__c step :mtaskSteps.get(task)){            
                if(task.RecordType.DeveloperName!='Travel_Task')
                    { 
                        if(tempDueDate == null || step.Due_Date__c > tempDueDate)   
                            tempDueDate = step.Due_Date__c;
                        
                        // This is for task status calculation                      
                        if(step.Status__c == 'Not Started'){
                            ntstartStep = ntstartStep+1;
                        }
                        else if (step.Status__c == 'In Progress'){
                            inprogressStep=inprogressStep+1;
                        }
                        else if (step.Status__c == 'Completed'){
                            completeStep=completeStep+1;
                        }
                        else if (step.Status__c == 'Cancelled'){
                            cancelStep=cancelStep+1;
                        }
                        if(task.Is_Mandatory__c == false){
                            task.Is_Mandatory__c = step.Is_Mandatory__c;    
                        }   
                    }
                                    
            }
            if(task.RecordType.DeveloperName!='Travel_Task'){           
                // this is to calculate task status based on step status
                if((stepList.size()) == (cancelStep+ntstartStep) && ntstartStep >0) {
                
                    task.Status__c = 'Not Started';
                }
                else if(stepList.size() == cancelStep){
                    task.Status__c = 'Cancelled';
                }
                else if(stepList.size() == (completeStep+cancelStep) && completeStep>0){
                    task.Status__c = 'Completed';
                }
                else{
                    task.Status__c = 'In Progress';
                }
                
                for(Step__c step1 : stepList){ 
                    if((step1.Status__c == 'Completed') || (step1.Status__c == 'Cancelled'))
                    {   
                        flag = true;                        
                        if(tempCompletionDate == null || step1.Actual_Completion_Date__c > tempCompletionDate)
                            tempCompletionDate = step1.Actual_Completion_Date__c;
                    }
                    else                
                    {
                        flag = false;
                        break;
                    }
                }                            
            }           
            if(!flag)
            {   
                tempCompletionDate = null ;
            }                                            
            task.Due_Date_rollup__c = tempDueDate;
            task.Start_Date_rollup__c = tempStartDate;
            task.End_Date_rollup__c = tempEndDate;                           
            task.Step_Completion_Date__c = tempCompletionDate;
            
            taskToUpdate.add(task); 
        }         
        //Dynamic Calendar three Fields Calculation logic
       for(Task__c oTask:taskToUpdate)
        {
            if(oTask.RecordType.DeveloperName!='Travel_Task' && oTask.Due_Date_rollup__c!=null)
            {    
             Integer year= oTask.Due_Date_rollup__c.year();
             Integer month=oTask.Due_Date_rollup__c.month();
            
             oTask.Year__c=year;
             oTask.Month__c=month;
             oTask.CalDate__c=oTask.Due_Date_rollup__c.day();
             oTask.Week__c=calculateWeekNumberOfDate(oTask.Due_Date_rollup__c);  
            
              }
        }                       
        update taskToUpdate;                   
    }*/
}