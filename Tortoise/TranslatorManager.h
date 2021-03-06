//
//  TranslatorManager.h
//  Tortoise
//
//  Created by Namit Nayak on 2/16/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger TRANSLATEREQUESTER;
enum
{
    TR_TRANSLATE_REQUEST_NONE = 0,
   TR_TRANSLATE_REQUEST_SETTINGS = 1,
    TR_TRANSLATE_REQUEST_HOME = 2,
   TR_TRANSLATE_REQUEST_DETAIL = 3
};

@class MonumentList,MonumentListDS;
@interface TranslatorManager : NSObject
typedef void (^HUDTextChange)(NSString *text);

+(id)sharedInstance;

-(void)translateLanguageForMonumentObject:(MonumentListDS *)objMonument withSource:(NSString *)source withTarget:(NSString *)target;
//-(void)translateLanguage:(NSArray *)monumentListDSObjArra withSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType;

-(void)translateLanguageWithSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType withMonumentObj:(MonumentListDS *)monumentObj;


-(void)translateLanguageWithSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType withMonumentObj:(MonumentListDS *)monumentObj withLoaderHandler:(HUDTextChange)handler;


-(void)translateOfflineMonumentwithTarget:(NSString *)target withCityName:(NSString *)cityName  withLanguageID :(NSNumber *)languageID withLoaderHandler:(HUDTextChange)handler;

@end
