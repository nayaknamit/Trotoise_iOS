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


-(NSArray *)getParseAPIDataToLanguageDS:(NSArray *)arraData{
    
    __block NSMutableArray *arr = [NSMutableArray array];
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
