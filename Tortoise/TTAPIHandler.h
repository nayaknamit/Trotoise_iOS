//
//  TTAPIHandler.h
//  Tortoise
//
//  Created by Namit Nayak on 10/15/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MonumentCityRequest.h"

typedef enum {
    GET_MONUMENT_LIST_BY_CITYID=0,
    GET_LANGUAGE_MAPPING =1,
    GET_MONUMENT_DETAIL_BY_MONUMENTID,
    GET_MONUMENT_LIST,
    GET_MONUMENT_LIST_BY_RANGE,
    GET_MONUMENT_LIST_BY_CITY_NAME,
    GET_MONUMENT_LIST_BY_COUNTRY_ID,
    
}REQUEST_TYPE;

typedef void (^TTCityMonumentListResponse)( BOOL isResultSuccess, NSError *error);
typedef void (^TTLanguageMappingResponse)( BOOL isLanguageSetup, NSError *error);
typedef void (^TTMonumentDetailResponse)( NSDictionary * cityMonumentDict, NSError *error);

@interface TTAPIHandler : NSObject


+ (id)sharedWorker;

- (void)getMonumentListByCityID:(NSString*)cityID withRequestType:(REQUEST_TYPE)requestType responseHandler:(TTCityMonumentListResponse)responseHandler;
//- (void)getMonumentListByRange:(NSString*)latitude withLongitude:(NSString*)longitude withrad:(NSString *)rad withRequestType:(REQUEST_TYPE)requestType responseHandler:(TTCityMonumentListResponse)responseHandler;

-(void)getMonumentListByCityName:(NSString *)cityName withRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTCityMonumentListResponse)responseHandler;

-(void)getMonumentListByCountryID:(NSString *)countryID withRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTCityMonumentListResponse)responseHandler;

-(void)getLanguageMappingwithRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTLanguageMappingResponse)responseHandler;
- (void)getMonumentListByRange:(NSString*)latitude withLongitude:(NSString*)longitude withrad:(NSString *)rad withLanguageLocale:(NSString *)locale withRequestType:(REQUEST_TYPE)requestType responseHandler:(TTCityMonumentListResponse)responseHandler;
-(void)getMonumentDetailByMonumentID:(NSString *)monumentID withRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTMonumentDetailResponse)responseHandler;


@end
