/**
* @author TCS Developer
* @date 19/10/2016
* @module Portal
* @usage Community users can view all the others community user details.
* @description To display community users in the community portal.
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/


public with sharing class ContactController {
@AuraEnabled
    public static List<User> findAll() {
        List<Id> profileId=new List<Id>();
        for(Profile p: [Select Id, Name from Profile where Name IN ('PPM Portal User Custom','Procurement Portal User') ]){
        profileId.add(p.id);
        
        }
        //if(profileList.size() > 0){
            List<User> users = 
                [SELECT Id, Name,Phone,Email,CompanyName,Country,LocaleSidKey,ProfileId,ContactId FROM User where ContactId != null and ProfileId IN:profileId];
                //Add isAccessible() check
                return users;    
           /* }
            return null;*/
        
    }
    
}