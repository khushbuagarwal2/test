/**
* @author TCS Developer
* @date 01/29/2015
* @module PPM
* @usage VF Controller for VF page WorkplanHomepageCreateWorkplan and WorkplanHomepageReportSection
* @description  This is a controller for ‘WorkplanHomepageCreateWorkplan’ vfp, which has been used on the HOME page to display 
				the button which navigate the user to his workplan report. 
				Controller also provides the functionality to create the Workplan for the Grant.
* @version history
	1. Developer Name - MM/DD/YYYY - Description
*/

public with sharing class WorkplanHomepageCreateWorkplanController {
    //public list<Country__c> lstusercountry{get;set;}
    public string CountryNames {get;set;}
    public string uname{get;set;}
    public list<report> Rprts{get;set;}
    
    public WorkplanHomepageCreateWorkplanController(){
        getCountryNames();
        getReports();
        uname=userinfo.getName();
        system.debug('@@:'+Rprts);
    }
    
    /**
	* @description Returns country records
	* @author TCS Developer
	* @date 01/29/2015
	* @param None
	* @return String
	* @version history
		1. Developer Name - MM/DD/ - Description
	*/
    public string getCountryNames(){
        //Rohini  - Commented this code due CT public group Id need to refactor this code 
        
        /*id uid = userinfo.getUserId();
        system.debug('@@User ID:'+uid);
        List<GroupMember> lstGroupMember = [SELECT GroupId FROM GroupMember where userorgroupid =:uid ];
        list<Country__c> lstcountry = [Select Name, CT_Public_Group_ID__c,To_be_hidden__c from Country__c WHERE To_be_hidden__c = false];
        list<Country__c> lstusercountry = new list<Country__c>();
        //list<Group> lstuserGroup = new list<Group>();
        for(GroupMember gm : lstGroupMember){
           for(Country__c c : lstcountry){
               if(gm.GroupId == c.CT_Public_Group_ID__c){
               lstusercountry.add(c);
               }
           }
        }
      
        system.debug('@@Country List :'+lstusercountry);
        
        List<String> countryNameList =new List<String>();
        Integer listSize = 0; 
        if(lstusercountry.size()>0){
            for(Country__c cn : lstusercountry){           
                countryNameList.add(cn.Name);
                countryNameList.add(',');
            }
            listSize = countryNameList.size();
            countryNameList[listSize-1] = '';
            CountryNames ='';
            for(String name : countryNameList){
                          CountryNames = CountryNames+name;
            }
            return CountryNames ;
        }else{
            return null;
        }  */
        return null;
         
    }

    /**
	* @description Returns report list
	* @author TCS Developer
	* @date 01/29/2015
	* @param None
	* @return List<Report>
	* @version history
		1. Developer Name - MM/DD/ - Description
	*/
    public list<report> getReports(){
        id usr = userinfo.getUserId();
        Rprts= new list<Report>([select id,name from Report where ownerid =: usr]);
        system.debug('@@Report List :'+Rprts);
        return Rprts;
    }
}