public class WorkplanStepDelOverrideExt {

    public id stepId{get;set;}
    public Step__c stepToDel;
    public Boolean NotDeleteRec = False;
    ApexPages.StandardController controllerExt;
    public List<Task__c> taskToRef;
    
    
    public WorkplanStepDelOverrideExt(ApexPages.StandardController controller) {
    
      controllerExt = controller;
      List<String> fieldNames = new List<String>();
      fieldNames.add('OwnerId');
      fieldNames.add('PPM_Assigned_To__c');
      fieldNames.add('Task_Name_lkp__c');
      fieldNames.add('PPM_Status__c');
      fieldNames.add('PPM_Due_Date__c');
      fieldNames.add('PPM_Actual_Completion_Date__c');
      if(!test.isRunningTest())
        {  
        controllerExt.addfields(fieldNames);
        }    
     // controllerExt.addfields(fieldNames);
      this.stepToDel= (Step__c)controller.getRecord();
      this.stepId=stepToDel.id;
    }
    
      /**
    * @description Delete Step data
    * @author TCS Developer
    * @date 01/29/2015
    * @param None
    * @return Pagereference
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
    public PageReference checkDelete()
   {
      PageReference pageRef;
      Step__c stepObj= (Step__c)controllerExt.getRecord();
       try{
            if( stepObj.Id != NULL){
                List<Step__c> stepList= new List<Step__c>();
                stepList.add(stepObj);
                Boolean notResponsibleForTask=getStepTaskRecord(stepList);
                if(!notResponsibleForTask)
                {
                        taskToRef = new List<Task__c>();
                        taskToRef= RollupStatus(stepList);
                        if(taskToRef!=null){
                            delete stepObj;
                        }
                        pageRef= new PageReference('/'+taskToRef[0].id);
                        system.debug('inside else pageref'+pageRef);
                        return pageRef;                
                }
                else
                {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not allowed to delete this Step record since you are responsible for the task of this Step.'));
                        pageRef = null;
                        return pageRef;
                }
            }
           }
           catch(exception e)
           {
                pageRef = null;
                return pageRef;
           }
       return pageRef;
   }
   /**
    * @description  Roll up Status on Task on the basis of related Steps's Status
                    Calculates MAX of Due Date from Steps and shows on Task Due Date
    * @author TCS Developer
    * @date 06/01/2015
    * @param None
    * @return void
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
    Public static list<Task__c> RollupStatus(List<Step__c> newSteps){
     system.debug('****inside RollupStatus********'+newSteps.SIZE()); 
                   
        boolean flag = false;
        Date tempDueDate;
        list<Step__c> stepList= new list<Step__c>();
        integer cancelStep=0; //to count the step having status as CANCEL 
        integer completeStep=0; //to count the step having status as COMPLETED
        integer inprogressStep=0; //to count the step having status as INPROGRESS
        integer ntstartStep=0; //to count the step having status as NOT STARTED
        integer onHoldStep=0;       
        Set<Id> parentTasksIds = new  Set<Id>();
        
        List<Task__c> parentTasksToBeUpdated = new List<Task__c>();
        map<Task__c,list<Step__c>> mtaskSteps = new map<task__c,list<Step__c>>();
        list<Task__c> taskToUpdate = new list<Task__c>();
        string Vrecordtypeid ='';
        Vrecordtypeid = [SELECT id from RecordType where DeveloperName ='PPM_To_do' and SobjectType = 'Step__c' ].Id;
        
        try{
        for(Step__c sobj : newSteps){
        system.debug('****inside RollupStatus for loop sobj recordtype********'+sobj.RecordTypeId);                            
            if(sobj.RecordTypeId== Vrecordtypeid )
             system.debug('****inside RollupStatus if********'+sobj.RecordTypeId);                            
                parentTasksIds.add(sobj.Task_Name_lkp__c); 
        }  
        Map<Id, String> taskToItsDueDate = new Map<Id, String>();
        Map<Id, Date> taskToItsActualCompDate1 = new Map<Id, Date>();
        for(Task__c tsk: [SELECT PPM_Actual_Completion_Date__c,PPM_Status__c,PPM_Due_Date__c,(SELECT PPM_Status__c,PPM_Actual_Completion_Date__c,PPM_Due_Date__c  from Steps__r)  FROM Task__c where ID in: parentTasksIds])
        {   
            mtaskSteps.put(tsk,tsk.Steps__r);
        }
        for(task__c task : mtaskSteps.keySet()){
            boolean Q1v = false;
            boolean Q2v = false;
            boolean Q3v = false;
            boolean Q4v = false;            
            Date tempCompletionDate;
            stepList = new list<Step__c>();
            stepList = mtaskSteps.get(task);
            if(stepList.SIZE()>0){            
                for(Step__c step :stepList){
                    // This is for task status calculation                      
                    if(step.PPM_Status__c == 'Not Started'){
                        ntstartStep = ntstartStep+1;
                    }
                    else if (step.PPM_Status__c == 'In Progress'){
                        inprogressStep=inprogressStep+1;
                    }
                    else if (step.PPM_Status__c == 'Completed'){
                        completeStep=completeStep+1;
                    }
                    else if (step.PPM_Status__c == 'Cancelled'){
                        cancelStep=cancelStep+1;
                    }
                    else if(step.PPM_Status__c == 'On Hold'){
                        onHoldStep = onHoldStep+1;              
                    }
                    // This is to calculate due date
                    if(tempDueDate == null || step.PPM_Due_Date__c > tempDueDate)   
                       tempDueDate = step.PPM_Due_Date__c;
                }
                //this is to calculate quarter in which due date is fallilng
                if(tempDueDate!=NULL){
                    integer month1 = tempDueDate.month();                    
                    if(month1 == 1) Q1v = true;
                    else if   (month1 == 2) Q1v = true; 
                    else if   (month1 == 3) Q1v = true; 
                    else if   (month1 == 4) Q2v = true; 
                    else if   (month1 == 5) Q2v = true; 
                    else if   (month1 == 6) Q2v = true; 
                    else if   (month1 == 7) Q3v = true; 
                    else if   (month1 == 8) Q3v = true; 
                    else if   (month1 == 9) Q3v = true; 
                    else if   (month1 ==10) Q4v = true; 
                    else if   (month1 ==11) Q4v = true; 
                    else if   (month1 ==12) Q4v = true;                    
                }
                
                // this is to calculate task status based on step status
                if((stepList.size()) == (cancelStep+ntstartStep) && ntstartStep >0) {
                
                    task.PPM_Status__c= 'Not Started';
                }
                else if(stepList.size() == cancelStep){
                    task.PPM_Status__c= 'Cancelled';
                }
                else if(stepList.size() == (completeStep+cancelStep+onHoldStep) && completeStep>0){
                    task.PPM_Status__c= 'Completed';
                }
                else if(stepList.size() == (cancelStep+onHoldStep) && cancelStep>0){
                    task.PPM_Status__c= 'Cancelled';
                }
                else if(stepList.size() == onHoldStep){
                    task.PPM_Status__c= 'On Hold';
                }
                else{
                    task.PPM_Status__c= 'In Progress';
                }
                for(Step__c step1 : stepList){ 
                 system.debug('****inside RollupStatus for loop step1********'+'PPM_Status__c'+step1.PPM_Status__c);                                               
                    if((step1.PPM_Status__c== 'Completed') || (step1.PPM_Status__c== 'Cancelled')||(step1.PPM_Status__c== 'On Hold'))
                    {   
                        flag = true;                        
                        if(tempCompletionDate == null || step1.PPM_Actual_Completion_Date__c> tempCompletionDate)
                            tempCompletionDate = step1.PPM_Actual_Completion_Date__c;
                    }
                    else                
                    {
                        flag = false;
                        break;
                    }
                }
                if(!flag)
                {   
                    tempCompletionDate = null ;
                }                                            
                task.PPM_Due_Date__c = tempDueDate;                       
                task.PPM_Actual_Completion_Date__c= tempCompletionDate;
                task.PPM_Q1__c = Q1v;
                task.PPM_Q2__c = Q2v;
                task.PPM_Q3__c = Q3v;
                task.PPM_Q4__c = Q4v;  
                
                taskToUpdate.add(task);
            }
            else{
            system.debug('****inside RollupStatus else********');                                               
                task.PPM_Actual_Completion_Date__c= NULL;
                task.PPM_Status__c= '';
                task.PPM_Due_Date__c = NULL;
                task.PPM_Q1__c = false;
                task.PPM_Q2__c = false;
                task.PPM_Q3__c = false;
                task.PPM_Q4__c = false;  
                taskToUpdate.add(task);
            }           
        }    
      
        update taskToUpdate;
        }catch(exception e)
        {
            system.debug('exception in workplanstepdeloverride class'+e);
            return null;
        }
        return taskToUpdate;
    }
    /* to get parent task record*/
    
    public static Boolean getStepTaskRecord(List<Step__c> newSteps){
    
    Set<Id> parentTasksIds = new  Set<Id>(); 
    Boolean notResponsibleForTask= false;
    for(Step__c step:newSteps)
    {
             parentTasksIds.add(step.Task_Name_lkp__c);
    }
    List<Task__c> tasks=[Select id,OwnerId  from Task__c where id IN:parentTasksIds];
    notResponsibleForTask=restrictUsersToDeleteStepRecords(tasks);
    for(Step__c stp: newSteps){
        if(notResponsibleForTask){
         stp.adderror('You are not allowed to add/edit this Step since you are not Responsible.');
         return notResponsibleForTask;
        }
        }
    return notResponsibleForTask;
    
    }
    /**
    * @description   //restrict non Responsible User(s) to insert Step Record
                    //Only Owner of Task and Responsible on Task can insert step or edit Task record.
    * @author TCS Developer
    * @date 06/01/2015
    * @param None
    * @return void
    * @version history
        1. Developer Name - MM/DD/ - Description
    */
    public static Boolean restrictUsersToDeleteStepRecords(List<Task__c> newTaskRecords){
      system.debug('inside restrictUsersToEditTaskRecords');
        Set<id> ResSet = new Set<id>();
        Boolean notResponsibleForTask=FALSE;
                   for(Responsible__c responsible: [Select id,Task__c,OwnerId,Responsible__c from Responsible__c where Task__c IN :newTaskRecords]){
                     ResSet.add(responsible.Responsible__c );
                   }
                  
                  for(Task__c newTask:newTaskRecords)
                  {
                   if(newTask.OwnerId != UserInfo.getUserId() && !(ResSet.contains(UserInfo.getUserId()) )){
                       System.debug('Inside Not responsible for task as true');
                        notResponsibleForTask= true;
                   }
                  }
                  return notResponsibleForTask;
    }
    

}