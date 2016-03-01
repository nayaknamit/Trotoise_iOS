//
//  TranslatorManager.m
//  Tortoise
//
//  Created by Namit Nayak on 2/16/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "TranslatorManager.h"
#import "MonumentListDS.h"
#import "FGTranslator.h"
@interface TranslatorManager ()
@property (nonatomic,strong) NSMutableArray *translatorArray;
@property (nonatomic,strong) NSMutableArray *reTranslatorArray;

@property (nonatomic,strong) NSMutableArray *sourceArra;
@property (nonatomic,strong) FGTranslator *translator;
@property (nonatomic) __block NSInteger counter;
@property (nonatomic)   __block NSInteger count;
@property (nonatomic,strong)NSString *sourceResource;
@property (nonatomic,strong)NSString *targetResource;
@property (nonatomic) TRANSLATEREQUESTER translateRequestVia;
@property (nonatomic,strong) NSMutableArray *translatorSplashTextArra;
@property (nonatomic,strong) NSMutableArray *reTranslatorSplashTextArra;
@property (nonatomic,strong) NSMutableArray *translateKey;
@property (nonatomic)   __block NSInteger translateCounter;

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
        [_translateKey addObject:SPECH_TRANSLATION_KEY_TWO];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_THREE];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_FOUR];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_FIVE];
        [_translateKey addObject:SPECH_TRANSLATION_KEY_SIX];
        
        _translateCounter  =0;
        _translator =[[FGTranslator alloc] initWithGoogleAPIKey:_translateKey[_translateCounter]];
    }
    
    
    return self;
}


-(void)setObjectInArra:(MonumentListDS *)monListDS{
    NSLog(@"%@",monListDS.name);
    if (_translatorArray == nil) {
        _translatorArray = [NSMutableArray array];
    }
    [_translatorArray addObject:monListDS];
}
-(void)setObjectForReInitiateRequestInArra:(MonumentListDS *)monListDS{
    NSLog(@"%@",monListDS.name);
    [_reTranslatorArray addObject:monListDS];
}

-(void)translateLanguage1:(MonumentListDS *)objMonument withSource:(NSString *)source withTarget:(NSString *)target{
    
//    @try {
        NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@_%@_%@",objMonument.name,objMonument.desc,objMonument.shortDesc];
        __weak TranslatorManager  *manager = self;
        
        [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
            NSLog(@"Conversion ");
            
            
            if (translated == nil) {
                
                
                
                _counter++;
            }else{
                NSArray *divisonArray = [translated componentsSeparatedByString:@"_"];
                MonumentListDS *objMon = [[MonumentListDS alloc] init];
                
                objMon.name = [divisonArray objectAtIndex:0];
                objMon.desc  = [divisonArray objectAtIndex:1];
                objMon.shortDesc = [divisonArray objectAtIndex:2];
                MonumentListDS *monumentObj  = [_sourceArra objectAtIndex:_counter];
                objMon.imageAttributes = monumentObj.imageAttributes;
                objMon.addInfo = monumentObj.addInfo;
                objMon.latitude = monumentObj.latitude;
                objMon.longitude  = monumentObj.longitude;
                objMon.monumentID= monumentObj.monumentID;
                objMon.thumbnail = monumentObj.thumbnail;
                _counter++;
                [manager setObjectInArra:objMon];
                if(_counter != _count-1){
                    
                    [manager performSelector:@selector(performInDelay) withObject:nil afterDelay:3.0];
                    
                    //            [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
                }else{
                    
                    if (_translateRequestVia == TR_TRANSLATE_REQUEST_SETTINGS) {
                        [manager performSelector:@selector(performDelayTextSpeech) withObject:nil afterDelay:3.0];
                        
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
                     formattedTranslateLanguage = [NSString stringWithFormat:@"%@_%@",[dictText objectForKey:@"title"],[dictText objectForKey:@"desc"]];
            }else{
                      formattedTranslateLanguage = [NSString stringWithFormat:@"%@__%@_%@",formattedTranslateLanguage,[dictText objectForKey:@"title"],[dictText objectForKey:@"desc"]];
            }
    
    }];
    
             __weak TranslatorManager  *manager = self;
            [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage)   {
                NSLog(@"Conversion %@",translated);
            
                if (translated==nil) {
                       [manager performSelector:@selector(performDelayTextSpeech) withObject:nil afterDelay:3.0];
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
                [APP_DELEGATE setUpLanguageInUSerDefualts:[APP_DELEGATE getLanguage] withSplashTextArr:_translatorSplashTextArra];
                [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:_translatorArray];
                _translatorArray = nil;
                _sourceArra = nil;
                return ;

                
                
                
            }];
    
}

-(void)translateLanguageForMonumentObject:(MonumentListDS *)objMonument withSource:(NSString *)source withTarget:(NSString *)target{
    
    NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@_%@_%@",objMonument.name,objMonument.desc,objMonument.shortDesc];
    __weak TranslatorManager  *manager = self;
    
    [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
        NSLog(@"Conversion ");
        if (translated==nil) {
            
            
        }
        
        
        NSArray *divisonArray = [translated componentsSeparatedByString:@"_"];
        MonumentListDS *objMon = [[MonumentListDS alloc] init];
        
        objMon.name = [divisonArray objectAtIndex:0];
        objMon.desc  = [divisonArray objectAtIndex:1];
        objMon.shortDesc = [divisonArray objectAtIndex:2];
        MonumentListDS *monumentObj  = objMonument;
        objMon.imageAttributes = monumentObj.imageAttributes;
        objMon.addInfo = monumentObj.addInfo;
        objMon.latitude = monumentObj.latitude;
        objMon.longitude  = monumentObj.longitude;
        objMon.monumentID= monumentObj.monumentID;
        objMon.thumbnail = monumentObj.thumbnail;
        
        
            [FGTranslator flushCache];
            [FGTranslator flushCredentials];
            [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:[NSArray arrayWithObject:objMon]];
        
            NSLog(@"translation Complete");
        
    }];
    

}
-(void)performDelayTextSpeech{
    
    
    [FGTranslator flushCache];
    [FGTranslator flushCredentials];
    _translator = nil;
    
    _translator =[[FGTranslator alloc] initWithGoogleAPIKey:@"AIzaSyBh3D0vDSk88NpRrNM3NNmdiQYrJVdi598"];

    
    [self translateSplashScreenText:[APP_DELEGATE getSplashTextArray] withSource:_sourceResource withTarget:_targetResource];
    

}
-(void)performInDelay{
    [FGTranslator flushCache];
    [FGTranslator flushCredentials];
    _translator = nil;
    
    _translator =[[FGTranslator alloc] initWithGoogleAPIKey:@"AIzaSyBh3D0vDSk88NpRrNM3NNmdiQYrJVdi598"];

    [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:_sourceResource withTarget:_targetResource];
}

-(void)translateLanguage:(NSArray *)monumentListDSObjArra withSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType{
 
    _translateRequestVia = requestType;

    switch (requestType) {
        case TR_TRANSLATE_REQUEST_DETAIL:
        {
            [self initiateRequestForDetialPageTranslationForTarget:target withSource:source withMonumentObject:[monumentListDSObjArra objectAtIndex:0]];
           
            
        }
            break;
         default:
        
        {
            
            _count = [monumentListDSObjArra count];
            
            if(![source isEqualToString:@"en"]){
                
                _sourceArra = APP_DELEGATE.defaultCityMonumentList;
                
            }else{
                _sourceArra = [NSMutableArray arrayWithArray:monumentListDSObjArra];
            }
            
            if([target isEqualToString:@"en"]){
                
                [FGTranslator flushCache];
                [FGTranslator flushCredentials];
                [[NSUserDefaults standardUserDefaults] setBool:NO
                                                        forKey:@"isLanguageCache"];

                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"languageCache"];
                [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:APP_DELEGATE.defaultCityMonumentList];
                _translatorArray = nil;
                _sourceArra = nil;
                
                
                return;
            }
            
            
            _counter = 0;
            _sourceResource = source;
            _targetResource = target;
           
            
            _translator = nil;
            
            _translator =[[FGTranslator alloc] initWithGoogleAPIKey:@"AIzaSyBh3D0vDSk88NpRrNM3NNmdiQYrJVdi598"];
            

            [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
            
            

            
        }
        break;
    }
    
    
    
    
    
    
}

-(void)initiateRequestForDetialPageTranslationForTarget :(NSString *)target withSource:(NSString *)source withMonumentObject:(MonumentListDS *)monumentDS{
    
    __block  MonumentListDS *defualtLanguageMonument;
    
    [APP_DELEGATE.defaultCityMonumentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MonumentListDS *monumentObjViaRequest = monumentDS;//[monumentListDSObjArra objectAtIndex:0];
        
        MonumentListDS * monumentObjFromList = (MonumentListDS *)obj;
        
        if ([monumentObjFromList.monumentID integerValue] == [monumentObjViaRequest.monumentID integerValue]) {
            defualtLanguageMonument = monumentObjFromList;
            *stop = YES;
            return ;
            
        }
    }];
    if ([target isEqualToString:@"en"]) {
        [FGTranslator flushCache];
        [FGTranslator flushCredentials];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:[NSArray arrayWithObjects:defualtLanguageMonument, nil]];
        _translatorArray = nil;
        _sourceArra = nil;
    }else{
        
        [FGTranslator flushCache];
        [FGTranslator flushCredentials];
        _translator = nil;
        
        _translator =[[FGTranslator alloc] initWithGoogleAPIKey:@"AIzaSyBh3D0vDSk88NpRrNM3NNmdiQYrJVdi598"];

        [self translateLanguageForMonumentObject:defualtLanguageMonument withSource:source withTarget:target];
    }
}

@end
