//
//  TranslatorManager.m
//  Tortoise
//
//  Created by Namit Nayak on 2/16/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "TranslatorManager.h"
#import "MonumentList+CoreDataProperties.h"
#import "FGTranslator.h"
#import "MonumentListDS.h"
#import "LanguageDataManager.h"
#import "OfflineImageOperations.h"
#import "MonumentDataManager.h"
@interface TranslatorManager ()
@property (nonatomic,strong) NSMutableArray *translatorArray;
@property (nonatomic,strong) NSMutableArray *reTranslatorArray;

@property (nonatomic,strong) NSArray *sourceArra;
@property (nonatomic,strong) FGTranslator *translator;
@property (nonatomic) __block NSInteger counter;
@property (nonatomic)   __block NSInteger count;
@property (nonatomic,strong)NSString *sourceResource;
@property (nonatomic,strong)NSString *targetResource;
@property (nonatomic,strong)NSString *cityNameOffline ;
@property (nonatomic,strong) NSNumber *languageID;

@property (nonatomic) TRANSLATEREQUESTER translateRequestVia;
@property (nonatomic,strong) NSMutableArray *translatorSplashTextArra;
@property (nonatomic,strong) NSMutableArray *reTranslatorSplashTextArra;
@property (nonatomic,strong) NSMutableArray *translateKey;
@property (nonatomic)   __block NSInteger translateCounter;
@property (nonatomic)    NSInteger translateKeyCounter;
@property (copy) HUDTextChange hudTextHandler;
@property (nonatomic) __block NSInteger errorCounter;
@end

@implementation TranslatorManager



+(id)sharedInstance{
    
    static TranslatorManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[TranslatorManager alloc] init];
    });
    
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        [FGTranslator flushCache];
        [FGTranslator flushCredentials];
        _translatorArray = [NSMutableArray array];
        _sourceArra= [NSMutableArray array];
        _reTranslatorArray = [NSMutableArray array];
        _reTranslatorSplashTextArra = [NSMutableArray array];
        _translatorSplashTextArra = [NSMutableArray array];
        
        _translateKey = [NSMutableArray array];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_ONE];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_TWO];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_THREE];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_FOUR];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_FIVE];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_SIX];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_SEVEN];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_EIGHT];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_NINE];
        
        _translateCounter  =0;
        _translateKeyCounter = 0;
        _errorCounter = 1;
    }
    
    
    return self;
}


-(void)setObjectInArra:(MonumentList *)monListDS{
    NSLog(@"%@",monListDS.name);
    if (_translatorArray == nil) {
        _translatorArray = [NSMutableArray array];
    }
    [_translatorArray addObject:monListDS];
}
-(void)setObjectForReInitiateRequestInArra:(MonumentList *)monListDS{
    NSLog(@"%@",monListDS.name);
    [_reTranslatorArray addObject:monListDS];
}

-(void)translateLanguage1:(MonumentList *)objMonument withSource:(NSString *)source withTarget:(NSString *)target{
    
//    @try {
        NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@ _ %@ _%@",objMonument.name,[Utilities formattedStringForNewLineForString:objMonument.desc],[Utilities formattedStringForNewLineForString:objMonument.shortDesc]];
    
        __weak TranslatorManager  *manager = self;
    NSLog(@"Source : %@ Target : %@",source,target);
        [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
            NSLog(@"Conversion ");
            
            
            if (translated == nil) {
                _errorCounter ++;
                if (_errorCounter >9) {
                    [FGTranslator flushCache];
                    [FGTranslator flushCredentials];
                    [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_ERROR object:nil];
                    _translatorArray = nil;
                    _sourceArra = nil;
                    NSLog(@"translation Complete");
                    return ;
                }
                NSLog(@"Service Error %@",error.description);
                  [manager performSelector:@selector(performInDelay) withObject:nil afterDelay:0.001];
                
//                _counter++;
            }else{
                
                
                if (_translatorArray == nil) {
                    _translatorArray = [NSMutableArray array];
                }
                [_translatorArray addObject:translated];
                
                
                
                self.hudTextHandler([NSString stringWithFormat:@"%@ %ld/%lu.",MSG_MONUMENT_TRANSLATE,(long)_counter,(unsigned long)_sourceArra.count]);
                _counter++;
                if(_counter != _count){
                    
                    [manager performSelector:@selector(performInDelay) withObject:nil afterDelay:0.001];
                    
                }else{
                    [_translatorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        NSArray *divisonArray = [((NSString *)obj) componentsSeparatedByString:@"_"];
                        
                        
                        MonumentList *monumentObj  = [_sourceArra objectAtIndex:idx];
                        
                        
                        [[MonumentDataManager sharedManager] updateMonumentRecord:divisonArray withMonumentID:monumentObj.id];
                        
                        
                    }];
                    if (_translateRequestVia == TR_TRANSLATE_REQUEST_SETTINGS) {
                        [manager performSelector:@selector(performDelayTextSpeech) withObject:nil afterDelay:0.001];
                        
                    }else{
                        
                      
                        
                        
                        [FGTranslator flushCache];
                        [FGTranslator flushCredentials];
                        [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:_translatorArray];
                        _translatorArray = nil;
                        _sourceArra = nil;
                        NSLog(@"translation Complete");
                    }
                    
                }
                
            }
            
            
        }];

//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//    
//    }
    
}

-(void)translateSplashScreenText:(NSArray *)speechArray withSource:(NSString *)source withTarget:(NSString *)target{
    NSArray *executedArray  =[speechArray copy];
    
   __block NSString *formattedTranslateLanguage=@"";
        [executedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dictText = (NSDictionary *)obj;
            if (idx==0) {
                     formattedTranslateLanguage = [NSString stringWithFormat:@"%@ _ %@",[dictText objectForKey:@"title"],[dictText objectForKey:@"desc"]];
            }else{
                      formattedTranslateLanguage = [NSString stringWithFormat:@"%@ __%@ _ %@",formattedTranslateLanguage,[dictText objectForKey:@"title"],[dictText objectForKey:@"desc"]];
            }
    
    }];
    
             __weak TranslatorManager  *manager = self;
            [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)   {
                NSLog(@"Conversion %@",translated);
            
                if (translated==nil) {
                       [manager performSelector:@selector(performDelayTextSpeech) withObject:nil afterDelay:0.0];
                    return ;
                }
                
                NSArray *divisonArr = [translated componentsSeparatedByString:@"__"];
                [divisonArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  
                    NSString * trans = (NSString *)obj;
                    NSArray *transArr = [trans componentsSeparatedByString:@"_"];
                    
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:transArr[0],@"title",transArr[1],@"desc", nil];
                    [_translatorSplashTextArra addObject:dict];
                    
                }];
                
                [FGTranslator flushCache];
                [FGTranslator flushCredentials];
                [APP_DELEGATE setSplashTextWithLanguageChange:_translatorSplashTextArra];
                [APP_DELEGATE setUpLanguageInUSerDefualts:[[LanguageDataManager sharedManager] getDefaultLanguageObject] withSplashTextArr:_translatorSplashTextArra];
                [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:_translatorArray];
                _translatorArray = nil;
                _sourceArra = nil;
                return ;

                
                
                
            }];
    
}

-(void)translateLanguageForMonumentObject:(MonumentListDS *)objMonument withSource:(NSString *)source withTarget:(NSString *)target{
    
    NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@ _ %@ _ %@",[Utilities formattedStringForNewLineForString:objMonument.name],[Utilities formattedStringForNewLineForString:objMonument.desc],[Utilities formattedStringForNewLineForString:objMonument.shortDesc]];
//    __weak TranslatorManager  *manager = self;
    self.hudTextHandler([NSString stringWithFormat:@"%@ 0/1.",MSG_MONUMENT_TRANSLATE]);

    [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
        NSLog(@"Conversion ");
        if (translated==nil) {
            [self inititalizeTranslator];
            [self translateLanguageForMonumentObject:objMonument withSource:source withTarget:target];
            return ;
        }
        self.hudTextHandler([NSString stringWithFormat:@"%@ 1/1.",MSG_MONUMENT_TRANSLATE]);
        
        NSArray *divisonArray = [translated componentsSeparatedByString:@"_"];
        
        
        MonumentListDS *objMon = [[MonumentListDS alloc] init];
        objMon.name = [divisonArray objectAtIndex:0];
        objMon.desc  = [divisonArray objectAtIndex:1];
        objMon.shortDesc = [divisonArray objectAtIndex:2];
        objMon.imageAttributes = objMonument.imageAttributes;
        objMon.addInfo = objMonument.addInfo;
        objMon.latitude = objMonument.latitude;
        objMon.longitude  = objMonument.longitude;
        objMon.monumentID= objMonument.monumentID;
        objMon.thumbnail = objMonument.thumbnail;
        
        
        
        [FGTranslator flushCache];
        [FGTranslator flushCredentials];
        [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:[NSArray arrayWithObject:objMon]];
        NSLog(@"translation Complete");
        
    }];
    

}
-(void)performDelayTextSpeech{
    [self inititalizeTranslator];
    [self translateSplashScreenText:[NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_ONE,@"title",SPLASH_TEXT_DESC_ONE,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_TWO,@"title",SPLASH_TEXT_DESC_TWO,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_THREE,@"title",SPLASH_TEXT_DESC_THREEE,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_FOUR,@"title",SPLASH_TEXT_DESC_FOUR,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_FIVE,@"title",SPLASH_TEXT_DESC_FIVE,@"desc", nil], nil] withSource:_sourceResource withTarget:_targetResource];
}
-(void)performInDelay{
    [self inititalizeTranslator];
    [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:_sourceResource withTarget:_targetResource];
}





-(void)translateLanguageWithSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType withMonumentObj:(MonumentListDS *)monumentObj withLoaderHandler:(HUDTextChange)handler{
    
    _translateRequestVia = requestType;
    self.hudTextHandler = handler;
    _sourceArra = [[MonumentDataManager sharedManager] getMonumentListArra];
    
    switch (requestType) {
        case TR_TRANSLATE_REQUEST_DETAIL:
        {
            
            [self initiateRequestForDetialPageTranslationForTarget:target withSource:source withMonumentObject:monumentObj];
            
            
        }
            break;
        default:
            
        {
            
            _count = [_sourceArra count];
            
            
            _counter = 0;
            _sourceResource = source;
            _targetResource = target;
            
            [self inititalizeTranslator];
            
            [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
        }
            break;
    }
    
    
    
    

}
-(void)translateLanguageWithSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType withMonumentObj:(MonumentListDS *)monumentObj {
 
    _translateRequestVia = requestType;

    _sourceArra = [[MonumentDataManager sharedManager] getMonumentListArra];
    
    switch (requestType) {
        case TR_TRANSLATE_REQUEST_DETAIL:
        {
            
            [self initiateRequestForDetialPageTranslationForTarget:target withSource:source withMonumentObject:monumentObj];
           
            
        }
            break;
         default:
        
        {
            
            _count = [_sourceArra count];
            
            
            _counter = 0;
            _sourceResource = source;
            _targetResource = target;
           
            [self inititalizeTranslator];

            [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
        }
        break;
    }
    
    
    
    
    
    
}
-(void)inititalizeTranslator{
    if (_translator) {
        _translator = nil;

    }
    [FGTranslator flushCache];
    [FGTranslator flushCredentials];
    
    _translator =[[FGTranslator alloc] initWithGoogleAPIKey:[self getTranslateKey]];

}

-(void)initiateRequestForDetialPageTranslationForTarget :(NSString *)target withSource:(NSString *)source withMonumentObject:(MonumentListDS *)monumentDS{
    
    if ([target isEqualToString:@"en"] && [source isEqualToString:@"en"]) {
        [FGTranslator flushCache];
        [FGTranslator flushCredentials];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:[NSArray arrayWithObjects:monumentDS, nil]];
        _translatorArray = nil;
        _sourceArra = nil;
    }else{
        
        [self inititalizeTranslator];
        [self translateLanguageForMonumentObject:monumentDS withSource:source withTarget:target];
    }
}

-(NSString *)getTranslateKey{
    if (_translateKeyCounter>=[_translateKey count]) {
        _translateKeyCounter = 0;
    }
    
    NSString *getKey =  [_translateKey objectAtIndex:_translateKeyCounter];
    _translateKeyCounter++;
    return getKey;
    
}



#pragma offline Flow 


-(void)translateOfflineMonumentwithTarget:(NSString *)target withCityName:(NSString *)cityName  withLanguageID :(NSNumber *)languageID withLoaderHandler:(HUDTextChange)handler{
    _cityNameOffline = cityName;

    self.hudTextHandler = handler;
    
    _languageID = languageID;
    
    
    OfflineImageOperations *op  = [[OfflineImageOperations alloc] init];
    
    
    _sourceArra = [op getMonumentListArraWithCityName:cityName];
    _translatorArray = [NSMutableArray array];
    _count = [_sourceArra count];
    
    
    _counter = 0;
    _errorCounter = 0;
    _targetResource = target;
    
    [self inititalizeTranslator];
    
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 4;
//    
//    
//    //  documentsPath =   [FCFileManager pathForDocumentsDirectoryWithPath:@"/OfflineData];
//    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//        
//        }];
//    }];
    
//    for (MonumentList *monumentList in _sourceArra) {
//        
//        NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
//            
//            [FGTranslator flushCache];
//            [FGTranslator flushCredentials];
//            
//            FGTranslator *translatorOffline =[[FGTranslator alloc] initWithGoogleAPIKey:[self getTranslateKey]];
//             NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@ _ %@ _%@",monumentList.name,[Utilities formattedStringForNewLineForString:monumentList.desc],[Utilities formattedStringForNewLineForString:monumentList.shortDesc]];
//            [translatorOffline translateText:formattedTranslateLanguage withSource:@"en" target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
//                [resultDataArray addObject:translated];
//            }];
//            
//        }];
//        [operation setCompletionBlock:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // code here
//                NSLog(@"Count %lu",(unsigned long)resultDataArray.count);
//            });
//            
//        }];
//        [completionOperation addDependency:operation];
//       
//        
//    }
//    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
//    [queue addOperation:completionOperation];

    
//    [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
    [self translateOfflineMonument:[_sourceArra objectAtIndex:_counter] withTarget:target];
    
    
}


-(void)performInDelayOffline{
    [self inititalizeTranslator];
    [self translateOfflineMonument:[_sourceArra objectAtIndex:_counter]  withTarget:_targetResource];
}

-(void)translateOfflineMonument:(MonumentList *)objMonument   withTarget:(NSString *)target {
    
    //    @try {
    
    
    
//    NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@ _ %@ _%@",objMonument.name,[Utilities formattedStringForNewLineForString:objMonument.desc],[Utilities formattedStringForNewLineForString:objMonument.shortDesc]];
        NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@ _ %@ ",objMonument.name,[Utilities formattedStringForNewLineForString:objMonument.desc]];
    __weak TranslatorManager  *manager = self;
    NSLog(@"Source : English Target : %@",target);
    [_translator translateText:formattedTranslateLanguage withSource:@"en" target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
        NSLog(@"Conversion %@",translated);
        
        
        if (translated == nil) {
            _errorCounter ++;
            if (_errorCounter >9) {
                [FGTranslator flushCache];
                [FGTranslator flushCredentials];
                [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_ERROR object:nil];
                _translatorArray = nil;
                _sourceArra = nil;
                NSLog(@"translation Complete");
                return ;
            }
            NSLog(@"Service Error %@",error.description);
            [manager performSelector:@selector(performInDelayOffline) withObject:nil afterDelay:0];
            
            //                _counter++;
        }else{
            
            
            if (_translatorArray == nil) {
                _translatorArray = [NSMutableArray array];
            }
            translated = [NSString stringWithFormat:@"%@",translated];
          
            [_translatorArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:translated,@"translated",objMonument.id, @"monumentID",nil]];
            
            _counter++;
            self.hudTextHandler([NSString stringWithFormat:@"%@ %ld/%lu.",MSG_MONUMENT_TRANSLATE,(long)_counter,(unsigned long)_sourceArra.count]);
            
            if(_counter != _count){
                
                [manager performSelector:@selector(performInDelayOffline) withObject:nil afterDelay:0];
                
            }else {
                
              OfflineImageOperations *op =  [[OfflineImageOperations alloc] init];
                [op addMultiLingualData:_translatorArray withLocale:target withCity:_cityNameOffline withLanguageID:_languageID];
                
            }
            
        }
        
        
    }];
 }




@end
