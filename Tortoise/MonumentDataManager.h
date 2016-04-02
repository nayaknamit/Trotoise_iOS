//
//  MonumentDataManager.h
//  Tortoise
//
//  Created by Namit Nayak on 2/4/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MonumentList,MonumentListDS;
@interface MonumentDataManager : NSObject
+(id)sharedManager;
-(BOOL)getParseAPIDataToMonumentDS:(NSArray *)arraData withCustomizeData:(BOOL)isCustomzie;
-(void)flushMonumentList;
-(NSArray *)getMonumentListArra;
-(MonumentList *)getMonumentListDetailObjectForID:(NSNumber *)monumentID;
-(BOOL)updateMonumentRecord:(NSArray *)arrayObject withMonumentID:(NSNumber *)monumentID;
-(MonumentListDS *)createMonumentDSObjectForMonumentDetailRequest:(NSDictionary *)dict;
@end
