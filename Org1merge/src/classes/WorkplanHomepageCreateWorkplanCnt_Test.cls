/**
* @author TCS Developer
* @date 01/29/2015
* @module PPM
* @usage Test Class
* @description Test class for WorkplanHomepageCreateWorkplanController 
* @version history
	1. Developer Name - MM/DD/YYYY - Description
*/
@IsTest
public with sharing class WorkplanHomepageCreateWorkplanCnt_Test{
    
    public static String profilename = 'Solution Manager';
    public static Set<Id> stepRecordIdsSet= new Set<Id>();
    
    static testmethod void testmethod_A(){
        
        Id groupId;      
        
        //create user
        User newUser = WorkPlanTestUtility.singleUser(profilename);
        insert newUser;
        
        List<GroupMember> groupMemberList = new List<GroupMember>();
        groupMemberList = [SELECT GroupId FROM GroupMember WHERE UserOrGroupId=:UserInfo.getUserId()];
        
        if(groupMemberList.size() != 0){
        	
        	groupId = groupMemberList[0].GroupId;
            
        }
        //Country__c countryRecord = WorkPlanTestUtility.createCountry();
        //countryRecord.CT_Public_Group_ID__c = groupId;
        //insert countryRecord;
        //start test
        Test.startTest(); 
        
        WorkplanHomepageCreateWorkplanController wrkPlanHome = new WorkplanHomepageCreateWorkplanController();
        //Country__c cntObj = [Select id, Name from Country__c where id=:countryRecord.id];
        Test.stopTest();
      
     //   System.assertEquals(cntObj.Name,'Test Country');
     
     System.assertNotEquals(null, wrkPlanHome);
       
    }
    
}