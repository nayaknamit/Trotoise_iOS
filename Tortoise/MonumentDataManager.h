//
//  MonumentDataManager.h
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonumentDataManager : NSObject
+(id)sharedManager;
-(NSArray *)getParseAPIDataToLanguageDS:(NSArray *)arraData withCustomizeData:(BOOL)isCustomzie;

@end
