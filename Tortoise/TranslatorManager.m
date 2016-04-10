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
@property (nonatomic) TRANSLATEREQUESTER translateRequestVia;
@property (nonatomic,strong) NSMutableArray *translatorSplashTextArra;
@property (nonatomic,strong) NSMutableArray *reTranslatorSplashTextArra;
@property (nonatomic,strong) NSMutableArray *translateKey;
@property (nonatomic)   __block NSInteger translateCounter;
@property (nonatomic)    NSInteger translateKeyCounter;
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
        _translateKeyCounter = 0;
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
        
        [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
            NSLog(@"Conversion ");
            
            
            if (translated == nil) {
                
                NSLog(@"Service Error %@",error.description);
                  [manager performSelector:@selector(performInDelay) withObject:nil afterDelay:0.001];
                
//                _counter++;
            }else{
                NSArray *divisonArray = [translated componentsSeparatedByString:@"_"];
               
                 MonumentList *monumentObj  = [_sourceArra objectAtIndex:_counter];
                [[MonumentDataManager sharedManager] updateMonumentRecord:divisonArray withMonumentID:monumentObj.id];
                    _counter++;
                if(_counter != _count){
                    
                    [manager performSelector:@selector(performInDelay) withObject:nil afterDelay:0.001];
                    
                }else{
                    
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
    
    [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
        NSLog(@"Conversion ");
        if (translated==nil) {
            
        }
        
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
    [self translateSplashScreenText:[APP_DELEGATE getSplashTextArray] withSource:_sourceResource withTarget:_targetResource];
}
-(void)performInDelay{
    [self inititalizeTranslator];
    [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:_sourceResource withTarget:_targetResource];
}

-(void)translateLanguageWithSource:(NSString *)source withTarget:(NSString *)target withRequestSource:(TRANSLATEREQUESTER)requestType withMonumentObj:(MonumentListDS *)monumentObj{
 
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
            
//            if([target isEqualToString:@"en"] && [source isEqualToString:@"en"]){
//                
//                [FGTranslator flushCache];
//                [FGTranslator flushCredentials];
//                [[NSUserDefaults standardUserDefaults] setBool:NO
//                                                        forKey:@"isLanguageCache"];
//
//                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"languageCache"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:_sourceArra];
//                _translatorArray = nil;
//                _sourceArra = nil;
//                
//                
//                return;
//            }
            
            
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

@end
