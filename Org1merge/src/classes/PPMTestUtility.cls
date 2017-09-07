/**
* @author TCS Developer
* @date 09/29/2015
* @module PPM
* @usage Test Utility Class
* @description This is Utility class used in Test Classes for PPM.
* @version history
    1. Developer Name - MM/DD/YYYY - Description
*/
public with sharing class PPMTestUtility {

   
    public static Task__c createTask(){
        Task__c taskRec = new Task__c();
        taskRec.Name = 'Testing in Test Class';        
        return taskRec;
    }
  
  
}