/**
* @author TCS Developer
* @date 01/29/2015
* @module PPM
* @usage Extension class for VF page WorkplanTaskDelOverride
* @description  This is an extension for the ‘WorkplanTaskDelOverride’ vfp, which has been used to restrict the user 
                from delete the mandatory Workplan Task and Steps.
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
public class WorkplanTaskDelOverrideExt {

    public string CountryNames {get;set;}
    public string uname{get;set;}
    public Task__c taskToDel;
    public id tskid{get;set;}
    public string showPortfolio{get;set;}
    public Boolean IsMandatory{get;set;}
    public List<Step__c> milestoneToDelete{get;set;}
    ApexPages.StandardController controllerExt;
    public Boolean NotDeleteRec = False;
    
    public WorkplanTaskDelOverrideExt(ApexPages.StandardController controller) {    
    controllerExt = controller;
     List<String> fieldNames = new List<String>();
     fieldNames.add('OwnerId');
     fieldNames.add('PPM_Team__c');   
       
    if(!test.isRunningTest())// this conditional check added by Pankaj.
    {	
        controllerExt.addfields(fieldNames);
    }    
        
	this.taskToDel = (Task__c)controller.getRecord();        
   
    uname=userinfo.getName(); 
    WorkplanHomepageCreateWorkplanController objCont=new WorkplanHomepageCreateWorkplanController();
    CountryNames=objCont.getCountryNames(); 
    showPortfolio=ApexPages.currentPage().getParameters().get('showPortfolio');
    IsMandatory=false;
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
            
            Boolean isTraveltask=false;  
            PageReference pageRef;
            Task__c taskName;
            Task__c resTaskName;
            string rtypename;
            
            List<profile> profileList =  [SELECT Id, Name FROM 
                                          Profile WHERE 
                                          Id=:userinfo.getProfileId() LIMIT 1];
            String profileName= profileList[0].Name;
       
            Task__c taskObj = (Task__c)controllerExt.getRecord();
         
       
       try{
              if( taskObj.Id != NULL){
                    taskName=[SELECT Task_Name__c,Is_Mandatory__c, 
                             Recordtype.Developername FROM Task__c 
                             where id =:taskObj.id];
                  
                    rtypename = taskName.Recordtype.Developername;
                  
                    System.debug('---Record Type name ---'+rtypename );
               
           /************ Commented by pankaj on 19/10/2017 as this record type was
            ************ not used ************/
			
                  /*
                  if(rtypename == 'Board_Planner'){
                            
                            Boolean flag = false;
                            List<PermissionSetAssignment> ps = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Report_Access_to_specific_board_users' AND AssigneeId =: UserInfo.getUserId()]; 
                            if( !ps.isEmpty() ){
                                for( PermissionSetAssignment p : ps){
                                    flag = true;
                                    break;
                                 }            
                            }else{
                                if( profileName == 'Super User' || profileName == 'System Administrator'){
                                    flag = true; 
                                }
                            }
                            if(flag){
                                delete taskToDel;
                                Schema.DescribeSObjectResult r = Task__c.sObjectType.getDescribe();
                                String keyPrefix = r.getKeyPrefix();
                                Pagereference pageRef1 = new Pagereference('/'+keyPrefix+'/o');
                                return pageRef1;
                            }
                            return null;    
                    }
               	  */
                  
                  if(taskToDel.id != null && showPortfolio!='true'){
                   taskName=[SELECT Task_Name__c,Is_Mandatory__c, Recordtype.Developername FROM Task__c where id =:taskToDel.id];
                   isTraveltask=taskName.Task_Name__c=='Travel'?true:false;
                   IsMandatory=taskName.Is_Mandatory__c;
                   rtypename = taskName.Recordtype.Developername;
                   tskid=taskToDel.id;
                      
                      
                   System.debug('isMandatory-------------> ' + isMandatory);   
                   
                   resTaskName = [SELECT Task_Name__c,Is_Mandatory__c, 
                                  Recordtype.Developername,
                                  (Select id,Task__c,OwnerId,Responsible__c
                                   from Responsible__r) FROM Task__c 
                                   where id =:taskToDel.id];
                   
                   //Set of responsible of the current task
                   Set<id> ResSet = new Set<id>();
                   for(Responsible__c responsible: [Select id,Task__c,OwnerId,Responsible__c from Responsible__c where Task__c =:tskid]){
                     ResSet.add(responsible.Responsible__c );
                   }
                  
                   if(taskToDel.OwnerId != UserInfo.getUserId() && !(ResSet.contains(UserInfo.getUserId()) )){
                       
                       System.debug('taskToDel.OwnerId ----------- >' + taskToDel.ownerId);
                       System.debug('UserInfo.getUserId()----------- >' + UserInfo.getUserId());
                       System.debug('ResSet.contains(UserInfo.getUserId()) ----------- >' + ResSet.contains(UserInfo.getUserId()));
                       
                       
                        NotDeleteRec = True;
                   }
                   
                  if(NotDeleteRec == True){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You are not allowed to delete this record.'));
                    pageRef = null;
                    return pageRef;
                }
                   
                   
                   if(!IsMandatory){ 
                   System.debug('Inside ismandory');
                   milestoneToDelete=new List<Step__c>();
                   //Delete Child Steps for taskToDel.id child
                    milestoneToDelete=[select id from Step__c where task_name_lkp__c =:taskToDel.id];
                    if(!milestoneToDelete.isempty()){
                   		 delete milestoneToDelete;
                    }
                   delete taskToDel;
                  
                   }
                }
          
                
           System.debug('@@@rtypename '+rtypename ); 
           if(!IsMandatory)
           {             
           System.debug('@@@IstravelTask:'+isTraveltask);
          
            if(rtypename == 'PPM_Key_Activity' || rtypename == 'PPM_Travel_Plan'){
                    pageRef = new PageReference('/home/home.jsp');
                    pageRef.setredirect(true);    
                }
            
           /* else
            {
                pageRef = new PageReference('/'+Label.Workplan_My_Portofilio+'?pv1='+CountryNames+'&pv2='+uname);
                pageRef.setredirect(true);            
            }*/
            }else
            {
            system.debug('@@Ayush');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Mandatory Task can not be deleted.'));
                pageRef = null;
                          
            }
         } 
      } catch(Exception e){
				
          		System.debug('Exception ---> ' + e);
          		pageRef = null;
                return pageRef;
       }
       
      return pageRef ;
           
   }
}