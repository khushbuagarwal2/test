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
public class WorkplanTaskDelOverrideExt_Test{
    
    public static String profilename = 'System Administrator';
    
    public static testMethod void testingTaskDelOverrideExt ()
    {
        
        
        /* Adding Custom Setting Test Data -- By Pankaj */
        
        TriggerDisabledSettings__c ObjTriggerDisabled= new TriggerDisabledSettings__c();
        ObjTriggerDisabled.name = 'DS1';
        ObjTriggerDisabled.DisableTrigger__c = False;
        insert   ObjTriggerDisabled;
        
        /* Ends Adding Custom Setting Test Data by Pankaj */
        
        
        
          	User newUser=WorkPlanTestUtility.singleUser(profilename);
            insert newUser;
            String uname=userinfo.getName();           
            WorkplanHomepageCreateWorkplanController objCont=new WorkplanHomepageCreateWorkplanController();
            String CountryNames=objCont.getCountryNames(); 
        
        	Task__c taskRecord4=WorkPlanTestUtility.createTask4('PPM_Key_Activity');         
             insert taskRecord4; 
        
        	//create Step record
            Step__c stepRecord = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord4.Id);
            stepRecord.Name = 'test';
            stepRecord.Original_Due_Date__c = System.today()+5;
            stepRecord.Due_Date__c = System.today()+5;
            insert stepRecord;
            
            
                                              
           ApexPages.StandardController stdCtrl = new ApexPages.StandardController(taskRecord4);                     
            WorkplanTaskDelOverrideExt oDelOverExt=new WorkplanTaskDelOverrideExt(stdCtrl);
        
        	System.debug('oDelOverExt ----------' + oDelOverExt);
        
        	String newPage ;
        
           if(oDelOverExt.checkDelete() != null){
                newPage = (oDelOverExt.checkDelete().getUrl()).replace('+',' ');
                System.assertNotEquals(null,newPage); 
                
            }
       
          
        	 Task__c taskRecord5=WorkPlanTestUtility.createTask4('PPM_Key_Activity');         
             insert taskRecord5; 
        
        	//create Step record
            Step__c stepRecord2 = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord5.Id);
            stepRecord2.Name = 'test';
            stepRecord2.Original_Due_Date__c = System.today()+5;
            stepRecord2.Due_Date__c = System.today()+5;
            insert stepRecord2;
            
            
                                              
            ApexPages.StandardController stdCtrl2 = new ApexPages.StandardController(taskRecord5);                     
            WorkplanTaskDelOverrideExt oDelOverExt2 =new WorkplanTaskDelOverrideExt(stdCtrl);
            oDelOverExt2.showPortfolio = 'False';
        	String newPage2 ;
            if(oDelOverExt2.checkDelete() != null){
                	  newPage2 = (oDelOverExt2.checkDelete().getUrl()).replace('+',' ');
          			  System.assertNotEquals(null,newPage); 
            }
           
        
        
        
        
            Task__c taskRecord6=WorkPlanTestUtility.createTask4('PPM_Key_Activity');         
            taskRecord6.OwnerId = UserInfo.getUserId();
             insert taskRecord6; 
        
        	//create Step record
            Step__c stepRecord3 = WorkPlanTestUtility.createMileStoneWithoutParentMileStone(newUser.Id ,taskRecord6.Id);
            stepRecord3.Name = 'test';
            stepRecord3.Original_Due_Date__c = System.today()+5;
            stepRecord3.Due_Date__c = System.today()+5;
            insert stepRecord3;
            
            
                                              
            ApexPages.StandardController stdCtrl3 = new ApexPages.StandardController(taskRecord6);                     
            WorkplanTaskDelOverrideExt oDelOverExt3 =new WorkplanTaskDelOverrideExt(stdCtrl3);
            oDelOverExt3.showPortfolio = 'False';
        	String newPage3 ;
   			oDelOverExt3.checkDelete();
       
                
            //Line 50,51,52 added by Razia       
            TEST.startTest();   
            stdCtrl = new ApexPages.StandardController(taskRecord4); 
            oDelOverExt=new WorkplanTaskDelOverrideExt(stdCtrl);
            if(oDelOverExt.checkDelete() != null){
                  newPage = (oDelOverExt.checkDelete().getUrl()).replace('+',' ');   
            }
          
        
           // stdCtrl = new ApexPages.StandardController(taskRecord4);                     
           // oDelOverExt=new WorkplanTaskDelOverrideExt(stdCtrl);
           // newPage = (oDelOverExt.checkDelete().getUrl()).replace('+',' ');
           
        	if(oDelOverExt2.checkDelete() != null)
            {
            	System.assertNotEquals(null,newPage);     
            }
            
            
            TEST.stopTest();
           
    } 


    static testMethod void testingBoardTaskDelOverrideExt ()
    { 
        
        // Commented by Pankaj on 19/10/2016 as BoardPlanner is not used right now
        /*
     	    User newUser=WorkPlanTestUtility.singleUser('System Administrator');
            insert newUser;
           String uname=userinfo.getName();           
           //create Task
            Task__c taskRecord=WorkPlanTestUtility.createBoardPlannerTask(newUser.Id);         
            insert taskRecord; 
            TEST.startTest();                                     
     	    ApexPages.StandardController stdCtrl = new ApexPages.StandardController(taskRecord);                     
            WorkplanTaskDelOverrideExt oDelOverExt=new WorkplanTaskDelOverrideExt(stdCtrl);
            PageReference pageRef = oDelOverExt.checkDelete();
            System.assertEquals(null,pageRef); 
	        TEST.stopTest();
		*/
    }
    


}