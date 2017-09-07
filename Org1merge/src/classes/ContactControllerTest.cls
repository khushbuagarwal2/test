/**
* @author TCS Developer
* @date 19/10/2016
* @module Portal
* @usage Test Community users can view all the others community user details.
* @description To Test display community users in the community portal.
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/


@isTest
private class ContactControllerTest {


    static testMethod void testFindAll() {
    map<String,Id> mProfile=new map<String,Id>();
       for(Profile p:[Select id,name from profile ]){
       mProfile.put(p.name,p.id);
       
       }
       
      // List<UserRole> lRole=[Select id from UserRole];
       /*Account acc=TestDataFactory.createAccount();
       acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
       Insert acc;*/
       
         UserRole ur = new UserRole(Name = 'CEO');
         insert ur;
        
       //Creating Contact ownerId
       User u1=TestDataFactory.createUser();
       u1.ProfileId=mProfile.get('System Administrator');
      // u1.UserRoleId=lRole[0].id;
       u1.UserRoleId=ur.id;
       insert u1;
       
       system.runas(u1){
       Account acc=TestDataFactory.createAccount();
       acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
       Insert acc;
       
       Contact con=TestDataFactory.createContact();
       con.AccountId=acc.id;
       con.OwnerId=u1.id;
       Insert con;
       
       User u=TestDataFactory.createUser();
           if(mProfile.containsKey('PPM Portal User Custom')){
       		   u.ProfileId=mProfile.get('PPM Portal User Custom');
               u.ContactId=con.id;
               u.username='zzzzz@qaz.com';
               u.CommunityNickName='EFGHesdgv';
               Insert u;
        
           }
       
       
       }
       
       
       ContactController c=new ContactController();
        Test.startTest();
       List<User> lUser=ContactController.findAll();
        Test.stopTest();
       System.Assertnotequals(lUser,null);
       
       
  
    
    }
    
    
    
}