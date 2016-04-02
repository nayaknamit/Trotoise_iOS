//
//  LanguageDataManager.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    DEFAULT_LANGUAGE_WITHOUT_NUANCE=0,
    DEFAULT_LANGUAGE_WITH_NUANCE = 1
}DEFUALT_LANGUAGE_TYPE;

@class Language;
@interface LanguageDataManager : NSObject
+(id)sharedManager;
-(NSArray *)getLanguageArrayFromDB;
-(void)getParseAPIDataToLanguageDS:(NSArray *)arraData;
-(BOOL)isLanguageDataExistInCoreData;
-(Language *)getDefaultLanguageObject;
-(void)setDefaultLanguage:(DEFUALT_LANGUAGE_TYPE)defaultLanugageType withLanguageDict:(NSDictionary *)dict;
@end
