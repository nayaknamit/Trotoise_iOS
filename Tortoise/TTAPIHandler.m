//
//  TTAPIHandler.m
//  Tortoise
//
//  Created by Namit Nayak on 10/15/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//

#import "TTAPIHandler.h"
#import "AFNetworking.h"
#import "LanguageDataManager.h"
#import "MonumentListDS.h"
#import "MonumentDataManager.h"
#import "OfflineImageOperations.h"
static NSString *const TTAPIHandlerBaseDomain = @"http://52.16.49.213";
static NSString *const TTAPIHandlerBaseURL = @"/Trotoise.Services_new/Monument.asmx/";
static NSString *const TTAPIHandlerExtendBaseURL = @"/Trotoise.Services_new/Monument.asmx/";
//http://52.16.49.213/Trotoise.Services_new/Monument.asmx/GetLanguageList
//static NSString *const TTAPIHandlerBaseDomain = @"http://52.16.49.213";
//static NSString *const TTAPIHandlerBaseURL = @"/Trotoise.Services/Monument.asmx";


static NSString *const TTAPIHandlerMethodGET = @"GET";
static NSString *const TTAPIHandlerMethodPOST = @"POST";
//static NSUInteger const TTAPIHandlerDefaultCount = 50;

#define SERVICE_GETMONUMENTLISTBYCITYID @"GetMonumentListOnCityId?id="
@interface TTAPIHandler()

@property (nonatomic, strong) NSString *httpClient;
@property (nonatomic,strong) NSString *localeForOffline;
@property (nonnull,strong) NSNumber *languageOfflineID;
@property (nonatomic) NSInteger countForMonument;
@end

@implementation TTAPIHandler


+ (id)sharedWorker
{
    static TTAPIHandler *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[TTAPIHandler alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        NSString *baseURL = [NSString stringWithFormat:@"%@%@",TTAPIHandlerBaseDomain,TTAPIHandlerBaseURL];
//        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        self.httpClient = baseURL;
//        [self.httpClient  ]
//        [self.httpClient setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//        [self.httpClient setDefaultHeader:@"client123" value:@"token"];
//        [self.httpClient setDefaultHeader:@"client123" value:@"clientID"];
//        [self.httpClient setDefaultHeader:@"BedBathUS" value:@"X-bbb-site-id"];
//        [self.httpClient setDefaultHeader:@"MobileApp" value:@"v"];
//        
//        [self.httpClient setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
    }
    
    return self;
}

- (void)getMonumentListByCityID:(NSString*)cityID withRequestType:(REQUEST_TYPE)requestType responseHandler:(TTCityMonumentListResponse)responseHandler{
    
    
   
    
    // 2
    
    NSString *aPath = @"GetMonumentListOnCityId";
    
    NSDictionary *aParametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:cityID,@"id" , nil];
   
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *aURLRequest = [manager.requestSerializer  requestWithMethod:TTAPIHandlerMethodGET URLString:self.httpClient parameters:aParametersDictionary error:nil];
    
    
    [aURLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //[self.httpClient requestWithMethod:TTAPIHandlerMethodGET path:aPath parameters:aParametersDictionary];

    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aURLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
  
    // execute the operation
    [operation start];

    
}
- (void)getMonumentListByRange:(NSString*)latitude withLongitude:(NSString*)longitude withrad:(NSString *)rad withLanguageLocale:(NSString *)locale withRequestType:(REQUEST_TYPE)requestType responseHandler:(TTCityMonumentListResponse)responseHandler{
    
    NSString *aPath = @"GetMonumentListByRange";
    TRRANGETYPE rangeTyp = [APP_DELEGATE getRangeType];
    NSString * radius = rad;
    
    if (rangeTyp == TRRANGE_MILETYPE) {
        double ra = [rad doubleValue];
        ra = ra * 1.60;
        radius = [NSString stringWithFormat:@"%.f",ra];
    }
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@",TTAPIHandlerBaseDomain,TTAPIHandlerExtendBaseURL,aPath];
    
    
    self.httpClient = baseURL;
    
     NSDictionary *aParametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:latitude,@"lat",longitude,@"lng",radius,@"rad",locale,@"lang" , nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    NSMutableURLRequest *aURLRequest = [manager.requestSerializer  requestWithMethod:TTAPIHandlerMethodGET URLString:self.httpClient parameters:aParametersDictionary error:nil];

    [aURLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aURLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *ss = [self processJSONResponse:responseObject forRequest:requestType];
        BOOL isResultSuccess = NO;
        if (ss.count>0) {
            isResultSuccess = YES;
        }
        responseHandler(isResultSuccess,nil);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        responseHandler(nil, error);
    }];
    
    
    
    
    // execute the operation
    [operation start];
    
}
-(void)getMonumentListByCityName:(NSString *)cityName withLanguageLocale:(NSString *)locale withRequestType:(REQUEST_TYPE)requestType withLanguageID:(NSNumber *)languageID withResponseHandler:(TTOfflineCityMonumentListResponse)responseHandler{
    NSString *aPath = @"GetMonumentListOnCityName";
    
    _languageOfflineID = languageID;
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@",TTAPIHandlerBaseDomain,TTAPIHandlerExtendBaseURL,aPath];
    
    
    self.httpClient = baseURL;
    _localeForOffline = locale;
    NSDictionary *aParametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:cityName,@"name",locale,@"lang" , nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest *aURLRequest = [manager.requestSerializer  requestWithMethod:TTAPIHandlerMethodGET URLString:self.httpClient parameters:aParametersDictionary error:nil];
    
    [aURLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aURLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *ss = [self processJSONResponse:responseObject forRequest:requestType];
        BOOL isResultSuccess = NO;
        if (ss.count>0) {
            isResultSuccess = YES;
        }
        responseHandler(isResultSuccess,_countForMonument,ss,nil);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        responseHandler(NO,0,nil, error);
    }];
    
    
    
    
    // execute the operation
    [operation start];


}

-(void)getMonumentListByCountryID:(NSString *)countryID withRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTCityMonumentListResponse)responseHandler{
    
//    NSString *aPath = @"GetMonumentListOnCountryId";
//    
//    NSDictionary *aParametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:countryID,@"id" , nil];
//    
//    NSMutableURLRequest *aURLRequest = [self.httpClient requestWithMethod:TTAPIHandlerMethodGET path:aPath parameters:aParametersDictionary];
//    
//    AFJSONRequestOperation *anOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:aURLRequest
//                                                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                                                                                              
//                                                                                              
//                                                                                              //                                                                                              responseHandler(anArray, nil);
//                                                                                          }
//                                                                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                                                              responseHandler(nil, error);
//                                                                                          }];
//    // execute the operation
//    [anOperation start];
}

-(void)getLanguageMappingwithRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTLanguageMappingResponse)responseHandler{
    
    NSString *aPath = @"GetLanguageList";
    
    NSDictionary *aParametersDictionary = nil;
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@",TTAPIHandlerBaseDomain,TTAPIHandlerExtendBaseURL,aPath];
   
    
    self.httpClient = baseURL;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest *aURLRequest = [manager.requestSerializer  requestWithMethod:TTAPIHandlerMethodGET URLString:self.httpClient parameters:aParametersDictionary error:nil];
    
    [aURLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aURLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self processJSONResponse:responseObject forRequest:requestType];
        responseHandler(YES,nil);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        responseHandler(nil, error);
    }];

    
  
    // execute the operation
    [operation start];
}

-(void)getMonumentDetailByMonumentID:(NSString *)monumentID withLanguageLocale:(NSString *)locale withRequestType:(REQUEST_TYPE)requestType withResponseHandler:(TTMonumentDetailResponse)responseHandler{
    NSString *aPath = @"GetMonumentDetail";
    
    NSDictionary *aParametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:monumentID,@"id",locale,@"lang" , nil];
    
    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@",TTAPIHandlerBaseDomain,TTAPIHandlerBaseURL,aPath];
    
    self.httpClient = baseURL;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest *aURLRequest = [manager.requestSerializer  requestWithMethod:TTAPIHandlerMethodGET URLString:self.httpClient parameters:aParametersDictionary error:nil];
    
    [aURLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aURLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        MonumentListDS *ss = [self processJSONResponse:responseObject forRequest:requestType];
        responseHandler(ss,nil);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        responseHandler(nil, error);
    }];
    
    
    
    
    // execute the operation
    [operation start];

    

}


- (id)processJSONResponse:(id)JSON forRequest:(REQUEST_TYPE)request
{
    
    if(request == GET_LANGUAGE_MAPPING){
        
        if([JSON isKindOfClass:[NSDictionary class]]){
            NSArray *languageArray  = [JSON objectForKey:@"data"];
            [[LanguageDataManager sharedManager] getParseAPIDataToLanguageDS:languageArray];
        }
        
    }
    else if (request == GET_MONUMENT_LIST_BY_RANGE){
        
        if([JSON isKindOfClass:[NSDictionary class]]){
            
            NSArray *monumentListResultArra = [JSON objectForKey:@"data"];
          
            if (monumentListResultArra.count>0) {
             BOOL isMonument = [[MonumentDataManager sharedManager] getParseAPIDataToMonumentDS:monumentListResultArra withCustomizeData:YES];
                if (isMonument){
                    return monumentListResultArra;
                }else{
                    return nil;
                }
            }
            return nil;
        }
    }else if(request == GET_MONUMENT_DETAIL_BY_MONUMENTID){
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = [JSON objectForKey:@"data"];
            MonumentListDS *mm = [[MonumentDataManager sharedManager] createMonumentDSObjectForMonumentDetailRequest:resultDict];
            return mm;
        }
    }else if(request == GET_MONUMENT_LIST_BY_CITY_NAME) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = [JSON objectForKey:@"data"];
            if (isNull([JSON objectForKey:@"data"])) {
                return nil;
            }
            
            NSArray *checkMonumentArr = [resultDict objectForKey:@"monumentList"];
            if ([checkMonumentArr count] == 0)  {
                _countForMonument = 0;
                return nil;
            
            }
            _countForMonument = [checkMonumentArr count];
            OfflineImageOperations *op =     [[OfflineImageOperations alloc] init];
            
            if([_languageOfflineID integerValue] == 45 && [_localeForOffline isEqualToString:@"hi"]){
                [op addHindiLanguageData:resultDict forLocaleLang:_localeForOffline withLanguageCode:_languageOfflineID];
                return nil;
            }else{
                NSArray *imageURls = [op  getImagUrlByParseCityDataFromJson:resultDict forLocaleLang:_localeForOffline];
            return imageURls;
            }
            
            //[op parseCityDataFromJson:resultDict forLocaleLang:_localeForOffline];
            
            
        }
    }
    return nil;
}

@end
