//
//  LanguageDataManager.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguageDataManager.h"
#import "TTAPIHandler.h"
#import "LanguageDS.h"
#import "DataAccessManager.h"
#import "Language.h"
#import "Nuance.h"
#import "Provider.h"
@interface LanguageDataManager(){
    
    
    
}
@end
@implementation LanguageDataManager


+(id)sharedManager{
    
    static LanguageDataManager *sharedInstance = nil;
    static dispatch_once_t pred;
     if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[LanguageDataManager alloc] init];
    });
    
    return sharedInstance;
}
-(id)init{
    
    if (self=[super init]) {

    }
    return self;
}
-(BOOL)isLanguageDataExistInCoreData{
    
      NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    if ([Language isDataExistwithContext:context]) {
        return true;
    }else{
        return false;
    }
    return false;
}
-(NSArray *)getLanguageArrayFromDB{
    
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    if ([Language isDataExistwithContext:context]) {
        NSArray * tempArra = [Language getLanguageDataFromContext:context];
        return tempArra;
    }
    return nil;
}
-(Language *)getDefaultLanguageObject{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDefaultLanguage == YES"];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *languageLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (languageLists.count> 0 ) {
        Language *lang = [languageLists lastObject];
        return lang;
    }
    
    
    return nil;
    
}


-(Language *)getDefaultOfflineLanguageObject{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",LANGUAGE_DEFAULT_ID];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *languageLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (languageLists.count> 0 ) {
        Language *lang = [languageLists lastObject];
        return lang;
    }
    
    
    return nil;
    
}


-(void)resetDefaultLanugageIfAny{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    NSError *error1 = nil;
    
    Language *langObj = [self getDefaultLanguageObject];
    if (langObj) {
        [langObj setIsDefaultLanguage:[NSNumber numberWithBool:NO]];
        if([context save:&error1]){
            
        }else{
            
            NSLog(@"Error In Inserting Data %@",[error1 description]);
            
        }
    }
    
}
-(void)setDefaultLanguage:(DEFUALT_LANGUAGE_TYPE)defaultLanugageType withLanguageDict:(NSDictionary *)dict {
   
    
    [self resetDefaultLanugageIfAny];
    
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    switch (defaultLanugageType) {
        case DEFAULT_LANGUAGE_WITH_NUANCE:
        {
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
            
            NSEntityDescription *entity =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@ AND nuanceRelationship.lang CONTAINS[cd] %@",[dict objectForKey:@"lg_name"],[dict objectForKey:@"nuance"]];
            
            /* Tell the request that we want to read the
             contents of the Person entity */
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            NSError *requestError = nil;
            /* And execute the fetch request on the context */
            NSArray *languageLists =[context executeFetchRequest:fetchRequest error:&requestError];
            
            if (languageLists.count> 0 ) {
                Language *lang = [languageLists lastObject];
                [lang setIsDefaultLanguage:[NSNumber numberWithBool:YES]];
                NSError *error = nil;
                if([context save:&error]){
                    
                }else{
                    
                    NSLog(@"Error In Inserting Data %@",[error description]);
                    
                }
            }
            
            
        }
        break;
        case DEFAULT_LANGUAGE_WITHOUT_NUANCE:
        {
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            
            NSEntityDescription *entity =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",[dict objectForKey:@"lg_name"]];
            
            /* Tell the request that we want to read the
             contents of the Person entity */
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            NSError *requestError = nil;
            /* And execute the fetch request on the context */
            NSArray *languageLists =[context executeFetchRequest:fetchRequest error:&requestError];
            
            if (languageLists.count> 0 ) {
                Language *lang = [languageLists lastObject];
                [lang setIsDefaultLanguage:[NSNumber numberWithBool:YES]];
                NSError *error = nil;
                if([context save:&error]){
                    
                }else{
                    
                    NSLog(@"Error In Inserting Data %@",[error description]);
                    
                }
            }
        }
        
        break;
       
    }
    
    
}

-(void)getParseAPIDataToLanguageDS:(NSArray *)arraData{
    
  __block NSManagedObjectContext * context =   [[DataAccessManager sharedInstance]managedObjectContext];

    if ([Language isDataExistwithContext:context]) {
        
        }else{
        
        [arraData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *mainObj = (NSDictionary *)obj;
            
            
              Language *language = [NSEntityDescription insertNewObjectForEntityForName:@"Language" inManagedObjectContext:context];
            [language setValue:[NSNumber numberWithInteger:[[mainObj objectForKey:@"id"] integerValue]] forKey:@"id"];
            [language setValue:[mainObj objectForKey:@"name"] forKey:@"name"];
            [language setValue:[mainObj objectForKey:@"transCode"] forKey:@"transCode"];
            [language setValue:[mainObj objectForKey:@"localeCode"] forKey:@"localeCode"];
            
            
            NSArray *nuanceArra = [mainObj objectForKey:@"nuance"];
            
            if(nuanceArra.count >0){
                
                
                [nuanceArra enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                     NSDictionary *naunceDict = (NSDictionary *)obj1;
                    Nuance *nuanceObj = [NSEntityDescription insertNewObjectForEntityForName:@"Nuance" inManagedObjectContext:context];
                    [nuanceObj setValue:[naunceDict objectForKey:@"code4"] forKey:@"code4"];
                    [nuanceObj setValue:[naunceDict objectForKey:@"code6"] forKey:@"code6"];
                    [nuanceObj setValue:[naunceDict objectForKey:@"lang"] forKey:@"lang"];

                    
                    
                    NSArray *providerArra = [naunceDict objectForKey:@"provider"];
                    
                    if (providerArra.count >0) {
                        [providerArra enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                            
                            NSDictionary *providerDict = (NSDictionary *)obj2;
                            
                              Provider *providerObj = [NSEntityDescription insertNewObjectForEntityForName:@"Provider" inManagedObjectContext:context];
                            [providerObj setValue:[providerDict objectForKey:@"voice"] forKey:@"voice"];
                            [providerObj setValue:[providerDict objectForKey:@"type"] forKey:@"type"];
                            
                            [nuanceObj addProviderObject:providerObj];
                        }];
                        
                        
                    }
                    
                    [language addNuanceRelationshipObject:nuanceObj];
                }];
            }

            NSError * error = nil;
            
            if([context save:&error]){
                NSLog(@"Insert Product with Product ID %@",[language.name description]);
                
            }else{
                
                NSLog(@"Error In Inserting Data %@",[error description]);
                
            }

        }];
            
            
            
           
    }
    
}

-(void)setInitialDefaultLanguage{
    if ([APP_DELEGATE getUserDefaultLanguageIsChached]) {
        //        dict = ;
        
        NSDictionary * dict = [APP_DELEGATE getLocalCahceLangugeDict];
        
        if ([dict objectForKey:@"nuance"]!= nil) {
            [self setDefaultLanguage:DEFAULT_LANGUAGE_WITH_NUANCE withLanguageDict:dict];
        }else{
            [self setDefaultLanguage:DEFAULT_LANGUAGE_WITHOUT_NUANCE withLanguageDict:dict];
        }
        
    }else{
        [self setDefaultLanguage:DEFAULT_LANGUAGE_WITH_NUANCE withLanguageDict:[NSDictionary dictionaryWithObjectsAndKeys:@"English",@"lg_name",@"English (US)",@"nuance", nil]];
    }

}
@end

/*
 [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj6, NSUInteger idx6, BOOL * _Nonnull stop6) {
 
 LanguageDS *languageDS = (LanguageDS *)obj6;
 
 
 [Language insertDataIntoBasket:languageDS withContextManagedObject:context];
 }];
 
 /**need to remove the code/  return tempArra;
[tempArra enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    Language *languageObj = (Language *)obj;
    LanguageDS *languageObject = [[LanguageDS alloc] init];
    languageObject.name = languageObj.name;
    languageObject.transCode = languageObj.transCode;
    languageObject.lang = languageObj.localeCode;
    //            languageObject.nuanceRelationship = languageObj.nuanceRelationship;
    
    NSArray *nuanceArra =[languageObj.nuanceRelationship allObjects];
    
    
    if(nuanceArra.count >0){
        __block NSMutableSet *nuanceSet1 = [[NSMutableSet alloc] init];
        [nuanceArra enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            NuanceDS *naunceObj = [[NuanceDS alloc] init];
            Nuance *naunceDB = (Nuance *)obj1;
            naunceObj.code4 = naunceDB.code4; // [naunceDict objectForKey:@"code4"];
            naunceObj.code6 =naunceDB.code6;
            naunceObj.lang =naunceDB.lang;
            
            NSArray *providerArra = [naunceDB.provider allObjects];
            __block NSMutableSet *providerObjectSet = [[NSMutableSet alloc] init];
            
            if (providerArra.count >0) {
                [providerArra enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                    
                    Provider *providerDict = (Provider *)obj2;
                    ProviderDS *providerObj = [[ProviderDS alloc] init];
                    providerObj.voice = providerDict.voice; //[providerDict objectForKey:@"voice"];
                    providerObj.type = providerDict.type;// [providerDict objectForKey:@"type"];
                    [providerObjectSet addObject:providerObj];
                    
                }];
                
                naunceObj.provider = providerObjectSet;
                
            }
            
            [nuanceSet1 addObject:naunceObj];
        }];
        languageObject.nuanceRelationship = nuanceSet1;
    }
    [arr addObject:languageObject];
    
    
    
    
    
}];

/*

 "name": "Arabic",
 "transCode": "ar",
 "localeCode": "ar",
 "nuance": [{
 "code4": "ar_WW",
 "code6": "ara-XWW",
 "lang": "Arabic",
 "provider": [{
 "voice": "Laila",
 "type": "female"
 }]
 }]*/
