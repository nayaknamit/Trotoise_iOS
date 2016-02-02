//
//  LanguageDataManager.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageDataManager : NSObject
+(id)sharedManager;
-(NSArray *)getParseAPIDataToLanguageDS:(NSArray *)arraData;
@end
