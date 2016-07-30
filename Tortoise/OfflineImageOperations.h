//
//  OfflineImageOperations.h
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Voice;
@interface OfflineImageOperations : NSObject
typedef void (^HUDTextChange)(NSString *text);

@property (nonatomic,strong) __block NSMutableArray *imageUrls;
@property (nonatomic) NSInteger counter;
+(id)sharedManager;
-(NSArray *)getImagUrlByParseCityDataFromJson:(NSDictionary *)data forLocaleLang:(NSString *)localeCode;


-(NSString *)getCityLocaleArrayForCityName :(NSString *)cityName ;
@property (copy) HUDTextChange hudTextHandler;
-(NSArray *)getCityWithCityName:(NSString *)cityName;
-(BOOL)deleteCityList:(NSNumber *)cityID;
-(NSArray *)getMonumentListArraWithCityName :(NSString *)cityName;
-(NSArray *)getCityListArra;
-(Voice *)getVoiceObjectForMonument:(NSNumber *)MonumentID;
-(BOOL)checkCityWithCityNameExist:(NSString *)cityName;
-(void)hudUpdateTextWithResponseHandler:(HUDTextChange)handler;
-(void)addMultiLingualData:(NSArray *)dataArray withLocale:(NSString *)locale withCity:(NSString *)cityName withLanguageID:(NSNumber *)languageID;
-(NSArray *)getOfflineLanguageSupportListForCityName:(NSString *)cityName;
-(void)downloadMultiLingualMp3ForArray:(NSArray *)urlArray withHandler: (HUDTextChange)handler;
-(void)voicePathForCity:(NSString *)cityName withLanguageCode4:(NSString *)code4;
-(void)downloadImageURLForNSArray:(NSArray *)urlArray withMonumentCount:(NSInteger)count withHUD:(MBProgressHUD *)hud withCityName:(NSString *)cityName withmp3download:(BOOL)ismp3Download withLoaderHandler:(HUDTextChange)handler;
-(void)addHindiLanguageData:(NSDictionary *)data forLocaleLang:(NSString *)localeCode withLanguageCode:(NSNumber*)languageID;
-(BOOL)updateEnglishLanguageParameterInCityWithCityName:(NSString *)cityName;
@end
