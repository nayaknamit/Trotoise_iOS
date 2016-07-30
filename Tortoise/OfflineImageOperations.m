//
//  OfflineImageOperations.m
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
#import <FCFileManager/FCFileManager.h>
#import "OfflineImageOperations.h"
#import "DataAccessManager.h"
#import "MonumentList+CoreDataProperties.h"
#import "Voice+CoreDataProperties.h"
#import "CityMonument+CoreDataProperties.h"
#import "ImageAttribute+CoreDataProperties.h"
#import "Voice+CoreDataProperties.h"
#import "MonumentLanguageDetail+CoreDataProperties.h"
@implementation OfflineImageOperations

+(id)sharedManager{
    
    static OfflineImageOperations *sharedInstance = nil;
    static dispatch_once_t pred;
 sharedInstance = [[OfflineImageOperations alloc] init];    
//    if (sharedInstance) return sharedInstance;
//    
//    dispatch_once(&pred, ^{
//        sharedInstance = [[OfflineImageOperations alloc] init];
//    });
//    
    return sharedInstance;
}
-(id)init{
    
    if (self=[super init]) {
        _imageUrls = [NSMutableArray array];
        _counter = 0;

    }
    return self;
}



-(NSArray *)getImagUrlByParseCityDataFromJson:(NSDictionary *)data forLocaleLang:(NSString *)localeCode{

    
    __block  NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    __block BOOL isResultSaved = NO;
  
    
    CityMonument *city = [NSEntityDescription insertNewObjectForEntityForName:@"CityMonument" inManagedObjectContext:context];

    
    
    [city setValue:[NSNumber numberWithInteger:[[data objectForKey:@"id"] integerValue]] forKey:@"id"];
    
    [city setValue:[data objectForKey:@"name"] forKey:@"name"];
    [city setValue:[data objectForKey:@"lat"] forKey:@"latitude"];
    [city setValue:[data objectForKey:@"lng"] forKey:@"longitude"];
    [city setValue:[data objectForKey:@"voiceBasePath"] forKey:@"voiceBasePath"];
    [city setValue:[NSNumber numberWithBool:YES] forKey:@"offline"];

    
    NSArray *arraData = [data objectForKey:@"monumentList"];
    
    [arraData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
                                NSDictionary *monumentDict = (NSDictionary *)obj;
                                
                                MonumentList *monumentListDS =[NSEntityDescription insertNewObjectForEntityForName:@"MonumentList" inManagedObjectContext:context];
        
                                [monumentListDS setValue:[monumentDict objectForKey:@"name"] forKey:@"name"];
                                [monumentListDS setValue:[monumentDict objectForKey:@"lat"] forKey:@"latitude"];
                                [monumentListDS setValue:[monumentDict objectForKey:@"lng"] forKey:@"longitude"];
                                [monumentListDS setValue:[self checkForNULL:[monumentDict objectForKey:@"shortDesc"]] forKey:@"shortDesc"];
                                [monumentListDS setValue:[self checkForNULL:[monumentDict objectForKey:@"desc"]] forKey:@"desc"];
        [monumentListDS setValue:[self checkForNULL:[monumentDict objectForKey:@"addInfo"] ]forKey:@"addInfo"];
        

        NSString *strThumb = [monumentDict objectForKey:@"thumbnail"];
        strThumb = [strThumb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"str %@",strThumb);
        [monumentListDS setValue:strThumb forKey:@"thumbnail"];
        [_imageUrls addObject:[NSDictionary dictionaryWithObjectsAndKeys:strThumb,@"imageUrl",@"image",@"key", nil]];
                                [monumentListDS setValue:[NSNumber numberWithInteger:[[monumentDict objectForKey:@"id"] integerValue]] forKey:@"id"];
                                [monumentListDS setValue:localeCode   forKey:@"language"];
                                [monumentListDS setValue:[NSNumber numberWithBool:YES] forKey:@"offline"];
        
                                NSArray *imageAttributeArra = [monumentDict objectForKey:@"arrImages"];
                                if (imageAttributeArra.count>0) {
                                    [imageAttributeArra enumerateObjectsUsingBlock:^(id  _Nonnull obj4, NSUInteger idx4, BOOL * _Nonnull stop4) {
                                            ImageAttribute *imageAttributeObject =[NSEntityDescription insertNewObjectForEntityForName:@"ImageAttribute" inManagedObjectContext:context];
                                        
                                        NSString *strThumbImg = (NSString *)obj4;
                                        strThumbImg = [strThumbImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                        NSLog(@"str %@",strThumbImg);
                                        
                                        [imageAttributeObject setValue:strThumbImg forKey:@"imageUrl"];
                                        
                                        [_imageUrls addObject:[NSDictionary dictionaryWithObjectsAndKeys:strThumbImg,@"imageUrl",@"image_Attr",@"key", nil]];
                                        [monumentListDS addImageAttributesObject:imageAttributeObject];
                                        
                                    }];
                                    
                                }
        
        NSArray *voicesArray = [monumentDict objectForKey:@"voices"];
        if (voicesArray.count >0) {
            [voicesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj3, NSUInteger idx, BOOL * _Nonnull stop) {
                Voice *voiceAttr = [NSEntityDescription insertNewObjectForEntityForName:@"Voice" inManagedObjectContext:context];
                NSDictionary *voiceDict = (NSDictionary *)obj3;
                    [voiceAttr setValue:[voiceDict objectForKey:@"transCode"] forKey:@"transCode"];
                    [voiceAttr setValue:[voiceDict objectForKey:@"nuCode4"] forKey:@"nuCode4"];
                   [voiceAttr setValue:[voiceDict objectForKey:@"gender"] forKey:@"gender"];
                   [voiceAttr setValue:[voiceDict objectForKey:@"voice"] forKey:@"voice"];
                
                NSString *strThumbPath = [voiceDict objectForKey:@"path"];
                strThumbPath = [strThumbPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"str %@",strThumbPath);
                
                [voiceAttr setValue:strThumbPath forKey:@"path"];
                if (idx==0) {
                [_imageUrls addObject:[NSDictionary dictionaryWithObjectsAndKeys:strThumbPath,@"path",@"mp3",@"key", nil]];
                }
                [monumentListDS addVoiceAttributesObject:voiceAttr];
            }];
        }
        
                                [city addCitymonumentrelationshipObject:monumentListDS];
    }];

        
        NSError *error = nil;
        if([context save:&error]){
//            NSLog(@"Insert Product with Product ID %@",[continent.name description]);
            isResultSaved = YES;
        }else{
            isResultSaved = NO;
            NSLog(@"Error In Inserting Data %@",[error description]);
            
        }
//    if (_imageUrls!=nil && _imageUrls.count>0) {
//        [self  downloadImageURLForNSArray:_imageUrls withCityName:[data objectForKey:@"name"] withLoaderHandler:^(NSString *text) {
//            NSLog(@"Namit %@",text);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"OperationComplete" object:text];
//            
//        }];
//    }
    return _imageUrls;
    
    
}

-(void)voicePathForCity:(NSString *)cityName withLanguageCode4:(NSString *)code4  {
    
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name CONTAINS[cd] '%@' AND offline == 1",cityName]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        CityMonument *city = [cityList objectAtIndex:0];
        
        NSArray *monumentArra = [city.citymonumentrelationship allObjects];
        NSMutableArray *mp3UrlArr = [NSMutableArray array];
        [monumentArra enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MonumentList *mm = (MonumentList *)obj;
            NSString *url = [NSString stringWithFormat:@"%@%@_%@.mp3",city.voiceBasePath,mm.name,code4];
            [mp3UrlArr addObject:url];
        }];

        [self downloadMultiLingualMp3ForArray:mp3UrlArr withHandler:^(NSString *text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OFFLINE_DOWNLOAD_MP3_NOTIFY object:nil];
        }];
    }
}
-(NSArray *)getCityListArra{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offline == 1"]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        CityMonument *city = [cityList objectAtIndex:0];
        
        NSLog(@"City Offline Check %ld",[city.offline integerValue]);
        
        return cityList;
        
        
    }
    
    return nil;
    
}

-(BOOL)checkCityWithCityNameExist:(NSString *)cityName{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name CONTAINS[cd] '%@' AND offline == 1",cityName]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        CityMonument *city = [cityList objectAtIndex:0];
        
        NSLog(@"City Offline Check %ld",[city.offline integerValue]);
        
        return YES;
        
        
    }
    
    return NO;
    
}


-(NSArray *)getCityWithCityName:(NSString *)cityName{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name CONTAINS[cd] '%@' AND offline == 1",cityName]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        CityMonument *city = [cityList objectAtIndex:0];
        
        NSLog(@"City Offline Check %ld",[city.offline integerValue]);
        
        return cityList;
        
        
    }
    
    return nil;
    
}



-(Voice *)getVoiceObjectForMonument:(NSNumber *)MonumentID{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"MonumentList" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offline == 1 AND id == %ld",(long)[MonumentID integerValue]]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        MonumentList *monumentObj = [cityList objectAtIndex:0];
        
        NSArray *aa = [monumentObj.voiceAttributes array];
        Voice *voice;
        if (aa.count >0) {
            voice = [aa objectAtIndex:0];
        }else{
            voice = nil;
        }
        
               return voice;
        
        
    }
    
    return nil;

}
-(NSArray *)getMonumentListArraWithCityName :(NSString *)cityName {
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
       NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name =='%@' AND offline == 1",cityName]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        CityMonument * city = [cityList lastObject];
        NSArray *monumentLists = [city.citymonumentrelationship allObjects];
        
        
        return monumentLists;
        
    }
    
    return nil;
    
}
-(NSString *)getCityLocaleArrayForCityName :(NSString *)cityName {
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name CONTAINS[cd] '%@' AND offline == 1",cityName]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        CityMonument *city = [cityList objectAtIndex:0];
        
        NSLog(@"City Offline Check %ld",[city.offline integerValue]);
        NSString *citVal = city.localeStrings;
return [citVal uppercaseString];        //        NSArray *bb = [citVal componentsSeparatedByString:@" , "];
//        
//        if (bb.count >1) {
//            return bb;
//        }else {
//           return  bb = [NSArray arrayWithObject:@"en"];
//        }
//        
        
    }
    
    return nil;
    

    
    
}
//-(NSString *)checkForNULL:(id)dictValue{
//    NSString *val=@"";
//    if(dictValue != [NSNull null] ){
//        val = dictValue;
//    }
//    return val;
//}


-(void)addHindiLanguageData:(NSDictionary *)data forLocaleLang:(NSString *)localeCode withLanguageCode:(NSNumber*)languageID{
    __block  NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    __block BOOL isResultSaved = NO;
    
    
    NSArray *cityArra = [self getCityWithCityName:[data objectForKey:@"name"]];

    if (cityArra.count >0) {
        CityMonument *cityMonument  =  [cityArra lastObject];
        NSString *cityValLocale = (cityMonument.localeStrings==nil)? @"" : cityMonument.localeStrings;
        NSString *cityLangIDs = (cityMonument.langIDString==nil)? @"" : cityMonument.langIDString;
        
        if ([cityLangIDs isEqualToString:@""]) {
            cityLangIDs = [NSString stringWithFormat:@"%ld",(long)[languageID integerValue]];
            
        }else {
            cityLangIDs = [NSString stringWithFormat:@"%@ , %ld",cityLangIDs,(long)[languageID integerValue]];

        }
        
        
        if([cityValLocale isEqualToString:@""]) {
            
            cityValLocale = [NSString stringWithFormat:@"%@",localeCode];
            
        }else{
            
            cityValLocale = [NSString stringWithFormat:@"%@, %@",cityValLocale,localeCode];
            
        }
        
        [cityMonument setValue:cityValLocale forKey:@"localeStrings"];
        [cityMonument setValue:cityLangIDs forKey:@"langIDString"];
    }

    
    
    NSArray *arraData = [data objectForKey:@"monumentList"];
    
    [arraData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        
        
        
        
        
        NSDictionary *monumentDict = (NSDictionary *)obj;
        
        
        
        MonumentLanguageDetail * monumentLanugageDetail =[NSEntityDescription insertNewObjectForEntityForName:@"MonumentLanguageDetail" inManagedObjectContext:context];
        
        [monumentLanugageDetail setValue:languageID  forKey:@"langID"];
        
        [monumentLanugageDetail setValue:([monumentDict objectForKey:@"name"] == [NSNull null])?@"":[monumentDict objectForKey:@"name"] forKey:@"name"];
        [monumentLanugageDetail setValue:([monumentDict objectForKey:@"desc"] == [NSNull null])?@"":[monumentDict objectForKey:@"desc"] forKey:@"desc"];
        //        [monumentLanugageDetail setValue:(transArr[2] == [NSNull null])?@"":transArr[2] forKey:@"shortDesc"];
        [monumentLanugageDetail setValue:[NSNumber numberWithInteger:[[monumentDict objectForKey:@"id"] integerValue]] forKey:@"monumentID"];
        [monumentLanugageDetail setValue:localeCode forKey:@"locale"];
        
        MonumentList * monumentList1 = [self getMonumentObjectForMonumentID:[NSNumber numberWithInteger:[[monumentDict objectForKey:@"id"] integerValue]] ];
        [monumentList1 addMultiLocaleMonumentObject:monumentLanugageDetail];
        

    
    
    }];
    
    
    NSError *error = nil;
    if([context save:&error]){
        //            NSLog(@"Insert Product with Product ID %@",[continent.name description]);
        isResultSaved = YES;
    }else{
        isResultSaved = NO;
        NSLog(@"Error In Inserting Data %@",[error description]);
        
    }
   
    

}

-(BOOL)updateEnglishLanguageParameterInCityWithCityName:(NSString *)cityName{
    @try {
        NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
        
        
    NSArray *cityArra = [self getCityWithCityName:cityName];
    
    if (cityArra.count >0) {
        CityMonument *cityMonument  =  [cityArra lastObject];
        
        NSString *cityValLocale = (cityMonument.localeStrings==nil)? @"" : cityMonument.localeStrings;
        NSString *cityLangIDs = (cityMonument.langIDString==nil)? @"" : cityMonument.langIDString;
        
        if  ([cityLangIDs isEqualToString:@""]){
            cityLangIDs = [NSString stringWithFormat:@"%d",24];
            
        }else{
            cityLangIDs = [NSString stringWithFormat:@"%@ , %d",cityLangIDs,24];

        }
        if ([cityValLocale isEqualToString:@""]) {
            cityValLocale = [NSString stringWithFormat:@"%@",@"en"];
            
        }else{
            cityValLocale = [NSString stringWithFormat:@"%@, %@",cityValLocale,@"en"];
            
        }
        
    
        
        
        [cityMonument setValue:cityValLocale forKey:@"localeStrings"];
        [cityMonument setValue:cityLangIDs forKey:@"langIDString"];
    }
    
    NSError *error = nil;
    if([context save:&error]){
        //            NSLog(@"Insert Product with Product ID %@",[continent.name description]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OFFLINE_DATA_LANG" object:nil];
    }else{
        NSLog(@"Error In Inserting Data %@",[error description]);
        
    }
    
    
}
@catch (NSException *exception) {
    NSLog(@"exception %@",exception.description);
}
@finally {
    
}


    return false;
}
-(void)addMultiLingualData:(NSArray *)dataArray withLocale:(NSString *)locale withCity:(NSString *)cityName withLanguageID:(NSNumber *)languageID{
    @try {
        NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
        
        
        
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary * dictTranslate = (NSDictionary *)obj;
            NSString * trans = [dictTranslate objectForKey:@"translated"];
            NSArray *transArr = [trans componentsSeparatedByString:@"_"];
            NSLog(@"transArr %ld",transArr.count);
            NSNumber *monumentID = [dictTranslate objectForKey:@"monumentID"];
            
            //        NSEntityDescription *entity =[NSEntityDescription entityForName:@"MonumentLanguageDetail" inManagedObjectContext:context];
            
            MonumentLanguageDetail * monumentLanugageDetail =[NSEntityDescription insertNewObjectForEntityForName:@"MonumentLanguageDetail" inManagedObjectContext:context];
            
            [monumentLanugageDetail setValue:languageID  forKey:@"langID"];
            
            [monumentLanugageDetail setValue:(transArr[0] == [NSNull null])?@"":transArr[0] forKey:@"name"];
            [monumentLanugageDetail setValue:(transArr[1] == [NSNull null])?@"":transArr[1] forKey:@"desc"];
            //        [monumentLanugageDetail setValue:(transArr[2] == [NSNull null])?@"":transArr[2] forKey:@"shortDesc"];
            [monumentLanugageDetail setValue:monumentID forKey:@"monumentID"];
            [monumentLanugageDetail setValue:locale forKey:@"locale"];
            
            MonumentList * monumentList1 = [self getMonumentObjectForMonumentID:monumentID];
            [monumentList1 addMultiLocaleMonumentObject:monumentLanugageDetail];
            
            
            
        }];
        
        NSArray *cityArra = [self getCityWithCityName:cityName];
        
        if (cityArra.count >0) {
            CityMonument *cityMonument  =  [cityArra lastObject];
            
            NSString *cityValLocale = (cityMonument.localeStrings==nil)? @"" : cityMonument.localeStrings;
            NSString *cityLangIDs = (cityMonument.langIDString==nil)? @"" : cityMonument.langIDString;
            
            if ([cityLangIDs isEqualToString:@""]) {
                cityLangIDs = [NSString stringWithFormat:@"%ld",(long)[languageID integerValue]];
                
            }else {
                cityLangIDs = [NSString stringWithFormat:@"%@ , %ld",cityLangIDs,(long)[languageID integerValue]];
                
            }
            
            
            if([cityValLocale isEqualToString:@""]) {
                
                cityValLocale = [NSString stringWithFormat:@"%@",locale];
                
            }else{
                
                cityValLocale = [NSString stringWithFormat:@"%@, %@",cityValLocale,locale];
                
            }
            
            
            [cityMonument setValue:cityValLocale forKey:@"localeStrings"];
            [cityMonument setValue:cityLangIDs forKey:@"langIDString"];
        }
        
        NSError *error = nil;
        if([context save:&error]){
            //            NSLog(@"Insert Product with Product ID %@",[continent.name description]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OFFLINE_DATA_LANG" object:nil];
        }else{
            NSLog(@"Error In Inserting Data %@",[error description]);
            
        }
        

    }
    @catch (NSException *exception) {
        NSLog(@"exception %@",exception.description);
    }
    @finally {
        
    }
    
    
    
}

-(NSArray *)getOfflineLanguageSupportListForCityName:(NSString *)cityName{
    
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name =='%@' AND offline == 1", cityName]];
    
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    
    
    if (cityList.count> 0 ) {
        
        CityMonument * city = [cityList lastObject];
        NSArray *langIDS = [city.langIDString componentsSeparatedByString:@","];
      __block  NSMutableArray *languageAr  = [NSMutableArray array];
        
        
        [langIDS enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSString *langStringID = (NSString *)obj;
            NSEntityDescription *entity1 =[NSEntityDescription entityForName:@"Language" inManagedObjectContext:context];
            
        NSPredicate    *predicate1 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id == %ld",(long)[langStringID integerValue]]];
            
            [fetchRequest setEntity:entity1];
            [fetchRequest setPredicate:predicate1];
            NSError *requestError1 = nil;

            NSArray *languageArr =[context executeFetchRequest:fetchRequest error:&requestError1];
            
            [languageAr addObjectsFromArray:languageArr];
            
        }];
        
        return languageAr;
    }

    
    return nil;
}
-(MonumentList *)getMonumentObjectForMonumentID: (NSNumber *)monumentID {
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"MonumentList" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id =='%ld' AND offline == 1", (long)[monumentID integerValue]]];
                              
//    kis ka bhi kal chalnga ho to     /* Tell the request that we want to read the
//     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *cityList =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (cityList.count> 0 ) {
        
        MonumentList * city = [cityList lastObject];
        return city;
        
    }
    
    return nil;

    
}
-(BOOL)deleteCityList:(NSNumber *)cityID{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"CityMonument" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id ==%d AND offline ==1",[cityID integerValue]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *continentLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (continentLists.count> 0 ) {
        CityMonument *cite = [continentLists lastObject];
        [context deleteObject:cite];
    }
    NSError *error = nil;
    if ([context save:&error]) {
        return true;
    }else{
        NSLog(@"Error Deleteing Object %@",[error description]);
    }
    

    
    return false;
}
-(void)flushMonumentList:(NSString *)entityName{
    NSManagedObjectContext *context =   [[DataAccessManager sharedInstance]managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",[dict objectForKey:@"lg_name"]];
    
    /* Tell the request that we want to read the
     contents of the Person entity */
    
    [fetchRequest setEntity:entity];
    //    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    /* And execute the fetch request on the context */
    NSArray *continentLists =[context executeFetchRequest:fetchRequest error:&requestError];
    
    if (continentLists.count> 0 ) {
    }
    NSError *error = nil;
    if ([context save:&error]) {
        
    }else{
        NSLog(@"Error Deleteing Object %@",[error description]);
    }
    
    
}

-(NSString *)checkForNULL:(id)dictValue{
    NSString *val=@"";
    if(dictValue != [NSNull null] ){
        val = dictValue;
    }
    return val;
}


-(void)hudUpdateTextWithResponseHandler:(HUDTextChange)handler{
    self.hudTextHandler = handler;
}

-(void)downloadMultiLingualMp3ForArray:(NSArray *)urlArray withHandler: (HUDTextChange)handler{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
    
    [FCFileManager createDirectoriesForPath:@"/OfflineData/"];
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            handler(@"DownloadComplete");
        }];
    }];
    
    for (NSString *urlString in urlArray)
    {
        NSBlockOperation *operation;
        
            
            NSURL *url = [NSURL URLWithString:urlString];
            operation = [NSBlockOperation blockOperationWithBlock:^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                if (data!=nil) {
                    _counter++;
                    [FCFileManager createFileAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:urlString]] withContent:data];
                    
                
                
                }
            }];
            
        [operation setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
               
            });
            
        }];
        [completionOperation addDependency:operation];
    
    }
    
    
    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
    [queue addOperation:completionOperation];
}
-(void)downloadImageURLForNSArray:(NSArray *)urlArray withMonumentCount:(NSInteger)count withHUD:(MBProgressHUD *)hud withCityName:(NSString *)cityName withmp3download:(BOOL)ismp3Download withLoaderHandler:(HUDTextChange)handler {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
    
    [FCFileManager createDirectoriesForPath:@"/OfflineData/"];
    
//  documentsPath =   [FCFileManager pathForDocumentsDirectoryWithPath:@"/OfflineData];
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            handler(@"cityname");
        }];
    }];
    
    for (NSDictionary* dict in urlArray)
    {
        NSBlockOperation *operation;
        
        if ([[dict objectForKey:@"key"] isEqualToString:@"mp3"]) {
//            if (ismp3Download) {
            
            
                NSURL *url = [NSURL URLWithString:[dict objectForKey:@"path"]];
                operation = [NSBlockOperation blockOperationWithBlock:^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                    if (data!=nil) {
                        _counter++;
                        
                    }else {
                
                        
                    }
                    

                    
                    [FCFileManager createFileAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:[dict objectForKey:@"path"]]] withContent:data];
//                    [data writeToFile: atomically:YES];
                
                }];
           
//        }
        }
        else  if ([[dict objectForKey:@"key"] isEqualToString:@"image_Attr"])
            {
        
                NSURL *url = [NSURL URLWithString:[dict objectForKey:@"imageUrl"]];

                     operation = [NSBlockOperation blockOperationWithBlock:^{
                        NSData *data = [NSData dataWithContentsOfURL:url];
//                        NSString *filename = [documentsPath stringByAppendingString:[url lastPathComponent]];
                         if (data!=nil) {
                             _counter++;
                         }else{
                             
                         }
                         
                         
                         [FCFileManager createFileAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[NSString stringWithFormat:@"img_attr_%@",[Utilities getFileNameFromURL:[dict objectForKey:@"imageUrl"]]]] withContent:data];
//                        [data writeToFile:filename atomically:YES];
                        
                    }];
        
            }else {
                NSURL *url = [NSURL URLWithString:[dict objectForKey:@"imageUrl"]];
                
                operation = [NSBlockOperation blockOperationWithBlock:^{
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    //                        NSString *filename = [documentsPath stringByAppendingString:[url lastPathComponent]];
                    if (data ==nil) {
                        NSLog(@"data nil");
                    }
                    _counter++;
                    
                    [FCFileManager createFileAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:[dict objectForKey:@"imageUrl"]]] withContent:data];
                    //                        [data writeToFile:filename atomically:YES];
                    }];

            }
        [operation setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                 hud.label.text = [NSString stringWithFormat:@"Downloading %ld monuments.\nAssets downloaded: %@/ %lu",count,[NSString stringWithFormat:@"%ld",(long)_counter],(unsigned long)urlArray.count];
            });
           
        }];
        [completionOperation addDependency:operation];
    }
    
    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
    [queue addOperation:completionOperation];
 
   
}





@end
