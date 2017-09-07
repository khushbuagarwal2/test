//This Test Class covers ProcurementController 
@isTest
public class ProcurementControllerTest{
    public static testMethod void ProcurementControllerTest1(){
    
        
    Procurement__kav article=new Procurement__kav(Title='Unit Test',Language = 'en_US',UrlName='abcd');
    Test.startTest();
    Insert article;
    List<Procurement__kav> listPro=ProcurementController.findAll();
    List<Procurement__kav> listPro1=ProcurementController.findAll1();
    List<Procurement__kav> listPro2=ProcurementController.findAll2();
    List<Procurement__kav> listPro3=ProcurementController.findAll3();
    List<Procurement__kav> listPro4=ProcurementController.findAll4();
    List<Procurement__kav> listPro5=ProcurementController.findAll5();
    List<Procurement__kav> listPro6=ProcurementController.findAll6();
    List<Procurement__kav> listPro7=ProcurementController.findAll7();
    List<Procurement__kav> listPro8=ProcurementController.findAll8();
    List<Procurement__kav> listPro9=ProcurementController.findAll9();
    
    
    
        
    System.assertNotEquals(null, article);
        
        
    article = [SELECT KnowledgeArticleId FROM Procurement__kav WHERE Id = :article.Id];
    String articleId = article.KnowledgeArticleId;
    //String articleId = article.id;
    //KbManagement.PublishingService.publishArticle(articleId, true);
        
        
        
        
        
        
        
    //System.debug('PublishStatus is'+article.PublishStatus);
    //Procurement__DataCategorySelection p=[SELECT Id,DataCategoryName, ParentId FROM Procurement__DataCategorySelection];
    //system.debug('The category is'+p);
   /* DescribeDataCategoryGroupResult[] results = Schema.describeDataCategoryGroups(
    new String[] { 'KnowledgeArticleVersion'}
    ); 
    Knowledge__DataCategorySelection tempCat = new Knowledge__DataCategorySelection ();
    tempCat.DataCategoryGroupName = results[0].getName();  // key line
    tempCat.DataCategoryName = 'PPM__c'; //m.Category_Path__c;
    tempCat.ParentId = article.id;
    insert tempcat;
    ProcurementController.findAll();*/
    
    
    }
    
}