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

-(BOOL)isLanguageDataExistInCoreData{
    
    __block  NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    if ([Language isDataExistwithContext:context]) {
        return true;
    }else{
        return false;
    }
    return false;
}

-(NSArray *)getParseAPIDataToLanguageDS:(NSArray *)arraData{
    
    __block NSMutableArray *arr = [NSMutableArray array];
    __block  NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    if ([Language isDataExistwithContext:context]) {
        NSArray * tempArra = [Language getLanguageDataFromContext:context];
        
        [tempArra enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Language *languageObj = (Language *)obj;
            LanguageDS *languageObject = [[LanguageDS alloc] init];
            languageObject.name = languageObj.name;
            languageObject.transCode = languageObj.transCode;
            languageObject.lang = languageObj.lang;
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
        
    }else{
        
        
        
        [arraData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *mainObj = (NSDictionary *)obj;
            LanguageDS *languageObject = [[LanguageDS alloc] init];
            languageObject.name = [mainObj objectForKey:@"name"];
            languageObject.transCode = [mainObj objectForKey:@"transCode"];
            languageObject.lang = [mainObj objectForKey:@"localeCode"];
            
            
            NSArray *nuanceArra = [mainObj objectForKey:@"nuance"];
            
            if(nuanceArra.count >0){
                __block NSMutableSet *nuanceSet1 = [[NSMutableSet alloc] init];
                [nuanceArra enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                    NuanceDS *naunceObj = [[NuanceDS alloc] init];
                    NSDictionary *naunceDict = (NSDictionary *)obj1;
                    naunceObj.code4 = [naunceDict objectForKey:@"code4"];
                    naunceObj.code6 = [naunceDict objectForKey:@"code6"];
                    naunceObj.lang = [naunceDict objectForKey:@"lang"];
                    
                    NSArray *providerArra = [naunceDict objectForKey:@"provider"];
                    __block NSMutableSet *providerObjectSet = [[NSMutableSet alloc] init];
                    
                    if (providerArra.count >0) {
                        [providerArra enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                            
                            NSDictionary *providerDict = (NSDictionary *)obj2;
                            ProviderDS *providerObj = [[ProviderDS alloc] init];
                            providerObj.voice = [providerDict objectForKey:@"voice"];
                            providerObj.type = [providerDict objectForKey:@"type"];
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
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj6, NSUInteger idx6, BOOL * _Nonnull stop6) {
            
            LanguageDS *languageDS = (LanguageDS *)obj6;
            
            
            [Language insertDataIntoBasket:languageDS withContextManagedObject:context];
        }];
        
    }
    return arr;
}

@end

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
