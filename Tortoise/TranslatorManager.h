//
//  TranslatorManager.h
//  Tortoise
//
//  Created by Namit Nayak on 2/16/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MonumentListDS;
@interface TranslatorManager : NSObject

+(id)sharedInstance;

-(void)translateLanguage:(NSArray *)monumentListDSObjArra withSource:(NSString *)source withTarget:(NSString *)target;

@end
