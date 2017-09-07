public with sharing class ProcurementController {
 
@AuraEnabled
    public static List<Procurement__kav> findAll() {             
     
            List<Procurement__kav> procurements =[select Id,Title,Summary,Author__r.Name,Attachment__Name__s,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,  PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Noticeboard__c  ORDER BY  FirstPublishedDate DESC];
                //Add isAccessible() check
                if(procurements.size() > 0)
                {
                return procurements; 
                }
               else 
                 return null;
        
    }
@AuraEnabled
    public static List<Procurement__kav> findAll1() {             
     
            List<Procurement__kav> procurements1 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT HIV_AIDS__c ORDER BY  FirstPublishedDate DESC];
                //Add isAccessible() check
                  if(procurements1.size() > 0)
                {
                return procurements1; 
                }
               else 
                 return null;                  
        
    }
 
    @AuraEnabled
    public static List<Procurement__kav> findAll2() {             
     
            List<Procurement__kav> procurements2 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Malaria__c ORDER BY  FirstPublishedDate DESC];
                if(procurements2.size() > 0)
                {
                return procurements2; 
                }
               else 
                 return null;                   
        
    }
    
        @AuraEnabled
    public static List<Procurement__kav> findAll3() {             
     
            List<Procurement__kav> procurements3 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Tuberculosis__c ORDER BY  FirstPublishedDate DESC];
                   if(procurements3.size() > 0)
                {
                return procurements3; 
                }
               else 
                 return null;                  
        
    }
        @AuraEnabled
    public static List<Procurement__kav> findAll4() {             
     
            List<Procurement__kav> procurements4 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Other_Health_Related_Procurement__c ORDER BY  FirstPublishedDate DESC];
                 if(procurements4.size() > 0)
                {
                return procurements4; 
                }
               else 
                 return null;                   
        
    }
        @AuraEnabled
    public static List<Procurement__kav> findAll5() {             
     
            List<Procurement__kav> procurements5 =[select Id,Title,Summary,Author__r.Name,Document_Type__c,Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Planning_and_Specifications__c ORDER BY  FirstPublishedDate DESC];
                 if(procurements5.size() > 0)
                {
                return procurements5; 
                }
               else 
                 return null;                  
        
    }
        @AuraEnabled
    public static List<Procurement__kav> findAll6() {             
     
            List<Procurement__kav> procurements6 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Tendering_and_Contracting__c ORDER BY  FirstPublishedDate DESC];
                    if(procurements6.size() > 0)
                {
                return procurements6; 
                }
               else 
                 return null;                  
        
    }
        @AuraEnabled
    public static List<Procurement__kav> findAll7() {             
     
            List<Procurement__kav> procurements7 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Supplier_Relationship_Management__c ORDER BY  FirstPublishedDate DESC];
                  if(procurements7.size() > 0)
                {
                return procurements7; 
                }
               else 
                 return null;                   
        
    }
        @AuraEnabled
    public static List<Procurement__kav> findAll8() {             
     
            List<Procurement__kav> procurements8 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT People_and_Organisation__c ORDER BY  FirstPublishedDate DESC];
                   if(procurements8.size() > 0)
                {
                return procurements8; 
                }
               else 
                 return null;                  
        
    }
        @AuraEnabled
    public static List<Procurement__kav> findAll9() {             
     
            List<Procurement__kav> procurements9 =[select Id,Title,Summary,Author__r.Name,ArticleType,Document_Type__c, Organisation__c,UrlName,ArticleNumber,Owner.Name,Date_Created__c,PublishStatus from Procurement__kav where PublishStatus = 'Online' AND Language = 'en_US' WITH DATA CATEGORY PPM__c AT Governance_and_Process__c ORDER BY  FirstPublishedDate DESC];
                  if(procurements9.size() > 0)
                {
                return procurements9; 
                }
               else 
                 return null;        
    }
}