//
//  MonumentDataManager.m
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "MonumentDataManager.h"
#import "MonumentListDS.h"
#import "DataAccessManager.h"
#import "Continent+CoreDataProperties.h"
#import "Country+CoreDataProperties.h"
#import "CityMonument+CoreDataProperties.h"
#import "MonumentList+CoreDataProperties.h"
#import "ImageAttribute+CoreDataProperties.h"
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


-(void)flushMonumentList{
      NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Continent" inManagedObjectContext:context];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",[dict objectForKey:@"lg_name"]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
//    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *continentLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (continentLists.count> 0 ) {
        for (Continent *contient in continentLists) {
            [context deleteObject:contient];
        }
        
    }
    

}

-(MonumentList *)getMonumentListDetailObjectForID:(NSNumber *)monumentID{
    MonumentList *monumentListObj;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];

    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"MonumentList" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%d",monumentID.integerValue];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *languageLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (languageLists.count> 0 ) {
        monumentListObj = (MonumentList *)[languageLists lastObject];
    }

    return monumentListObj;
}
-(NSArray *)getMonumentListArra{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"MonumentList" inManagedObjectContext:context];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",[dict objectForKey:@"lg_name"]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    //    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *monumentLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (monumentLists.count> 0 ) {
        return monumentLists;
        
    }

    return nil;
    
}
-(BOOL)getParseAPIDataToMonumentDS:(NSArray *)arraData withCustomizeData:(BOOL)isCustomzie{
    __block  NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    __block BOOL isResultSaved = NO;
    if (arraData.count>0) {
        [self flushMonumentList];
    }
    [arraData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *continentDict = (NSDictionary *)obj;
        Continent *continent = [NSEntityDescription insertNewObjectForEntityForName:@"Continent" inManagedObjectContext:context];

        [continent setValue:[continentDict objectForKey:@"name"] forKey:@"name"];
        [continent setValue:[NSNumber numberWithInteger:[[continentDict objectForKey:@"id"] integerValue]] forKey:@"id"];
        
        
        
        NSArray *countryList =[continentDict objectForKey:@"countryList"];
        
        if(countryList.count>0){
            
            
            [countryList enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        
                Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:context];
                
                NSDictionary *countryDict = (NSDictionary *)obj1;
                
                [country setValue:[countryDict objectForKey:@"name"] forKey:@"name"];
                [country setValue:[countryDict objectForKey:@"lat"] forKey:@"latitude"];
                [country setValue:[countryDict objectForKey:@"lng"] forKey:@"longitude"];
                [country setValue:[countryDict objectForKey:@"symbol"] forKey:@"symbol"];
                [country setValue:[NSNumber numberWithInteger:[[countryDict objectForKey:@"id"] integerValue]] forKey:@"id"];
                
                NSArray *cityList = [countryDict objectForKey:@"cityList"];
                if (cityList.count >0) {
                    
                    [cityList enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                        
                        NSDictionary *cityListDict = (NSDictionary *)obj2;
                CityMonument *cityMonument =[NSEntityDescription insertNewObjectForEntityForName:@"CityMonument" inManagedObjectContext:context];
                        
                    [cityMonument setValue:[cityListDict objectForKey:@"name"] forKey:@"name"];
                    [cityMonument setValue:[cityListDict objectForKey:@"lat"] forKey:@"latitude"];
                    [cityMonument setValue:[cityListDict objectForKey:@"lng"] forKey:@"longitude"];
                    [cityMonument setValue:[NSNumber numberWithInteger:[[cityListDict objectForKey:@"id"] integerValue]] forKey:@"id"];
                      
                        
                        NSArray *monumentListArra = [cityListDict objectForKey:@"monumentList"];
                        
                        if(monumentListArra.count>0){
                            [monumentListArra enumerateObjectsUsingBlock:^(id  _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                                
                                NSDictionary *monumentDict = (NSDictionary *)obj3;
                                
                                MonumentList *monumentListDS =[NSEntityDescription insertNewObjectForEntityForName:@"MonumentList" inManagedObjectContext:context];
/*
 latitude;
 @property (nullable, nonatomic, retain) NSString *longitude;
 @property (nullable, nonatomic, retain) NSString *name;
 @property (nullable, nonatomic, retain) NSString *shortDesc;
 @property (nullable, nonatomic, retain) NSString *thumbnail;*/
                                [monumentListDS setValue:[monumentDict objectForKey:@"name"] forKey:@"name"];
                                 [monumentListDS setValue:[monumentDict objectForKey:@"lat"] forKey:@"latitude"];
                                 [monumentListDS setValue:[monumentDict objectForKey:@"lng"] forKey:@"longitude"];
                                 [monumentListDS setValue:[monumentDict objectForKey:@"shortDesc"] forKey:@"shortDesc"];
                                 [monumentListDS setValue:[monumentDict objectForKey:@"desc"] forKey:@"desc"];
                                 [monumentListDS setValue:[monumentDict objectForKey:@"thumbnail"] forKey:@"thumbnail"];
                                 [monumentListDS setValue:[NSNumber numberWithInteger:[[monumentDict objectForKey:@"id"] integerValue]] forKey:@"id"];
                                
                                NSArray *imageAttributeArra = [monumentDict objectForKey:@"arrImages"];
                                if (imageAttributeArra.count>0) {
                                    [imageAttributeArra enumerateObjectsUsingBlock:^(id  _Nonnull obj4, NSUInteger idx4, BOOL * _Nonnull stop4) {
                                       ImageAttribute *imageAttributeObject =[NSEntityDescription insertNewObjectForEntityForName:@"ImageAttribute" inManagedObjectContext:context];
                                        
                                        [imageAttributeObject setValue:(NSString *)obj4 forKey:@"imageUrl"];
                                        
                                        [monumentListDS addImageAttributesObject:imageAttributeObject];
                                        
                                    }];
                                    
                                }
                                
//                                [monumentList addObject:monumentListDS];
                                [cityMonument addCitymonumentrelationshipObject:monumentListDS];
                            }];
                            
                            
                        }
                        
                        [country addCitylistObject:cityMonument];
                        
                        
                    }];
                    
                }
                
                [continent addCountryListObject:country];
            }];
        }
        
        NSError *error = nil;
        if([context save:&error]){
            NSLog(@"Insert Product with Product ID %@",[continent.name description]);
            isResultSaved = YES;
        }else{
            isResultSaved = NO;
            NSLog(@"Error In Inserting Data %@",[error description]);
            
        }
    }];
    
    return isResultSaved;
}

@end

/*
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
 */
