//
//  MonumentDataManager.m
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "MonumentDataManager.h"
#import "MonumentListDS.h"
@implementation MonumentDataManager


+(id)sharedManager{
  
    static MonumentDataManager *sharedInstance = nil;

    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[MonumentDataManager alloc] init];
    });
    
    return sharedInstance;

    
}
-(NSArray *)getParseAPIDataToLanguageDS:(NSArray *)arraData withCustomizeData:(BOOL)isCustomzie{
    __block NSMutableArray *monumentMainArra = [NSMutableArray array];
    
    [arraData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *continentDict = (NSDictionary *)obj;
        
        ContinentDS * contientDS = [[ContinentDS alloc] init];
        contientDS.name = [continentDict objectForKey:@"name"];
        contientDS.continentID = [NSNumber numberWithInteger:[[continentDict objectForKey:@"id"] integerValue]];
        __block NSMutableSet *countrySet=[NSMutableSet set];
        NSArray *countryList =[continentDict objectForKey:@"countryList"];
        
        if(countryList.count>0){
            
            
            [countryList enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
               
                NSDictionary *countryDict = (NSDictionary *)obj1;
                CountryDS *countryDS = [[CountryDS alloc] init];
                
                countryDS.name = [countryDict objectForKey:@"name"];
                countryDS.latitude = [countryDict objectForKey:@"lat"];
                 countryDS.longitude = [countryDict objectForKey:@"lng"];
                 countryDS.shortDesc = [countryDict objectForKey:@"shortDesc"];
                countryDS.desc = [countryDict objectForKey:@"desc"];
                 countryDS.addInfo = [countryDict objectForKey:@"addInfo"];
                 countryDS.thumbnail = [countryDict objectForKey:@"thumbnail"];
                 countryDS.countryID = [NSNumber numberWithInteger:[[countryDict objectForKey:@"id"] integerValue]];
                
               NSArray *cityList = [countryDict objectForKey:@"cityList"];
                if (cityList.count >0) {
                    NSMutableSet *countryCityList = [NSMutableSet set];
                    
                    [cityList enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                       
                        NSDictionary *cityListDict = (NSDictionary *)obj2;
                        CityMonumentDS *cityMonumentDS = [[CityMonumentDS alloc] init];
                        cityMonumentDS.name = [cityListDict objectForKey:@"name"];
                        cityMonumentDS.latitude = [cityListDict objectForKey:@"lat"];
                        cityMonumentDS.longitude = [cityListDict objectForKey:@"lng"];
                        cityMonumentDS.cityMonumentID = [NSNumber numberWithInteger:[[cityListDict objectForKey:@"id"] integerValue]];
                        
                        
                        NSArray *monumentListArra = [cityListDict objectForKey:@"monumentList"];
                        
                        if(monumentListArra.count>0){
                            NSMutableSet *monumentList = [NSMutableSet set];
                            [monumentListArra enumerateObjectsUsingBlock:^(id  _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                               
                                NSDictionary *monumentDict = (NSDictionary *)obj3;
                                
                                MonumentListDS *monumentListDS = [[MonumentListDS alloc] init];
                                
                                monumentListDS.name = [monumentDict objectForKey:@"name"];
                                monumentListDS.latitude = [monumentDict objectForKey:@"lat"];
                                monumentListDS.longitude = [monumentDict objectForKey:@"lng"];
                                monumentListDS.shortDesc = [monumentDict objectForKey:@"shortDesc"];
                                monumentListDS.desc = [monumentDict objectForKey:@"desc"];
                                monumentListDS.addInfo = [monumentDict objectForKey:@"addInfo"];
                                monumentListDS.thumbnail = [monumentDict objectForKey:@"thumbnail"];
                                monumentListDS.monumentID = [NSNumber numberWithInteger:[[monumentDict objectForKey:@"id"] integerValue]];
                                [monumentList addObject:monumentListDS];
                                
                            }];
                            
                            cityMonumentDS.citymonumentrelationship = monumentList;
                            
                        }
                        
                        [countryCityList addObject:cityMonumentDS];
                        
                        
                        
                    }];
                    countryDS.citylistSet = countryCityList;
                }
                
                [countrySet addObject:countryDS];
                
            }];
            contientDS.countryList = countrySet;
        }
        
        [monumentMainArra addObject:contientDS];
    }];
    
//    if(monumentMainArra.count>0){
//        NSDictionary * Contientdict = [monumentMainArra objectAtIndex:0];
//        
//        [Contientdict objectForKey:@"countryList"];
//        
//    }
    
    NSArray *customizeData;
    @try {
//        customizeData = [[[[monumentMainArra objectAtIndex:0] objectForKey:@"countryList"] objectAtIndex:3] objectForKey:@"cityList"];
//customizeData = [monumentMainArra objectAtIndex:0]
        ContinentDS *cDS = (ContinentDS *)[monumentMainArra objectAtIndex:0];
       __block CountryDS *countryDS ;
        [[cDS.countryList allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            CountryDS *tempDS =  (CountryDS *)obj;
            if ([tempDS.name isEqualToString:@"India"]) {
            countryDS = (CountryDS *)obj;
                *stop = YES;
                return ;
            }
            
            
        }];
        
        __block CityMonumentDS *cityMonumentDs ;
        [[countryDS.citylistSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CityMonumentDS *tempDS =  (CityMonumentDS *)obj;
            if ([tempDS.name isEqualToString:@"Delhi"]) {
                cityMonumentDs = (CityMonumentDS *)obj;
                *stop = YES;
                return ;
            }
            
            
        }];
        
        customizeData = [cityMonumentDs.citymonumentrelationship allObjects];
        
        
    }
    @catch (NSException *exception) {
        customizeData = nil;
    }
    @finally {
        
    }
    
    return  (isCustomzie)?customizeData:monumentMainArra;
   // return customizeData;
    
    
}

@end
