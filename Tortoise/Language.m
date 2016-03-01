//
//  Language.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "Language.h"
#import "Nuance.h"
#import "Provider.h"
#import "LanguageDS.h"
@implementation Language

// Insert code here to add functionality to your managed object subclass
+(void)insertDataIntoBasket:( LanguageDS*)dataObject withContextManagedObject:(NSManagedObjectContext *)context{
    
    
    Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:context];
    /*
    
     
     @property (nullable, nonatomic, retain) NSSet<Nuance *> *nuanceRelationship;*/


    
    
    [language setValue:dataObject.name forKey:@"name"];
    [language setValue:dataObject.transCode forKey:@"transCode"];
    [language setValue:dataObject.lang forKey:@"lang"];
//    [language addNuanceRelationshipObject:nuanceObject];
    NSArray *arrNuance = [dataObject.nuanceRelationship allObjects];
    
    NSMutableSet *nuanceSet = [NSMutableSet set];
    for(NuanceDS *nuanceDS in arrNuance){
    Nuance *nuanceObject  = [NSEntityDescription insertNewObjectForEntityForName:@"Nuance" inManagedObjectContext:context];
        /*@property (nullable, nonatomic, retain) NSString *code4;
        @property (nullable, nonatomic, retain) NSString *code6;
        @property (nullable, nonatomic, retain) NSString *lang;
        @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *provider;*/
        
        
        [nuanceObject setValue:nuanceDS.code4 forKey:@"code4"];
        [nuanceObject setValue:nuanceDS.code6 forKey:@"code6"];
        [nuanceObject setValue:nuanceDS.lang forKey:@"lang"];
        
        NSArray *arrProvider = [nuanceDS.provider allObjects];
        NSMutableSet *providerSet = [NSMutableSet  set];
        for(ProviderDS *providerDS in arrProvider)
        {
           Provider *providerObject  = [NSEntityDescription insertNewObjectForEntityForName:@"Provider" inManagedObjectContext:context];
            
            /**
             NSString *type;
             @property (nullable, nonatomic, retain) NSString *voice;*/
            [providerObject setValue:providerDS.type forKey:@"type"];
            [providerObject setValue:providerDS.voice forKey:@"voice"];
            [providerSet addObject:providerObject];
        }
        [nuanceObject addProvider:providerSet];
        
        [nuanceSet addObject:nuanceObject];
        
    }
    [language addNuanceRelationship:nuanceSet];
    
    NSError * error = nil;
    
    if([context save:&error]){
        NSLog(@"Insert Product with Product ID %@",[dataObject.name description]);
        
    }else{
        
        NSLog(@"Error In Inserting Data %@",[error description]);
        
    }
}
+(BOOL)isDataExistwithContext:(NSManagedObjectContext *)context{
    
    BOOL isExist = NO;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
    /* Tell the request that we want to read the
     contents of the Person entity */
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *productLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (productLists.count> 0 ) {
        isExist  = YES;
    }
    return isExist;
}
+(NSArray *)getLanguageDataFromContext:(NSManagedObjectContext *)context{
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
    /* Tell the request that we want to read the
     contents of the Person entity */
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *languageLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (languageLists.count> 0 ) {

    }
    
    return languageLists;
}

@end
