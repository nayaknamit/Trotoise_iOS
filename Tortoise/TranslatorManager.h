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
   TR_TRANSLATE_REQUEST_SETTINGS = 0,
    TR_TRANSLATE_REQUEST_HOME = 1,
   TR_TRANSLATE_REQUEST_DETAIL = 2
};
@class MonumentListDS;
@interface TranslatorManager : NSObject

+(id)sharedInstance;

-(void)translateLanguageForMonumentObject:(MonumentListDS *)objMonument withSource:(NSString *)source withTarget:(NSString *)target;
-(void)translateLanguage:(NSArray *)monumentListDSObjArra withSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType;
@end
