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
@property (nonatomic,strong) NSMutableArray *sourceArra;
@property (nonatomic,strong) FGTranslator *translator;
@property (nonatomic) __block NSInteger counter;
@property (nonatomic)   __block NSInteger count;
@property (nonatomic,strong)NSString *sourceResource;
@property (nonatomic,strong)NSString *targetResource;
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

        _translator =[[FGTranslator alloc] initWithGoogleAPIKey:@"AIzaSyBh3D0vDSk88NpRrNM3NNmdiQYrJVdi598"];
    }
    
    
    return self;
}


-(void)setObjectInArra:(MonumentListDS *)monListDS{
    NSLog(@"%@",monListDS.name);
    [_translatorArray addObject:monListDS];
}
-(void)translateLanguage1:(MonumentListDS *)objMonument withSource:(NSString *)source withTarget:(NSString *)target{
    
    
    NSString *formattedTranslateLanguage = [NSString stringWithFormat:@"%@_%@_%@",objMonument.name,objMonument.desc,objMonument.shortDesc];
    __weak TranslatorManager  *manager = self;

    [_translator translateText:formattedTranslateLanguage withSource:source target:target completion:^(NSError *error, NSString *translated, NSString *sourceLanguage) {
        NSLog(@"Conversion ");
        
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
        
        [manager setObjectInArra:objMon];
        _counter++;
        if(_counter != _count-1){
            
            [manager performSelector:@selector(performInDelay) withObject:nil afterDelay:3.0];
            
//            [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
        }else{
            [FGTranslator flushCache];
            [FGTranslator flushCredentials];
            [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:_translatorArray];
            _translatorArray = nil;
            _sourceArra = nil;
            NSLog(@"translation Complete");
        }
            }];
    
}


-(void)performInDelay{
    [FGTranslator flushCache];
    [FGTranslator flushCredentials];
    _translator = nil;
    
    _translator =[[FGTranslator alloc] initWithGoogleAPIKey:@"AIzaSyBh3D0vDSk88NpRrNM3NNmdiQYrJVdi598"];

    [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:_sourceResource withTarget:_targetResource];

    
}

-(void)translateLanguage:(NSArray *)monumentListDSObjArra withSource:(NSString *)source withTarget:(NSString *)target{
 
    _count = [monumentListDSObjArra count];
    
    if(![source isEqualToString:@"en"]){
        
        _sourceArra = APP_DELEGATE.defaultCityMonumentList;
        
    }else{
         _sourceArra = [NSMutableArray arrayWithArray:monumentListDSObjArra];
    }
    
    if([target isEqualToString:@"en"]){
        
            [FGTranslator flushCache];
            [FGTranslator flushCredentials];
            [[NSNotificationCenter defaultCenter] postNotificationName:GA_TRANSLATE_DONE object:APP_DELEGATE.defaultCityMonumentList];
            _translatorArray = nil;
            _sourceArra = nil;
        
        return;
    }
    
   
    _counter = 0;
    _sourceResource = source;
    _targetResource = target;
    [self translateLanguage1:[_sourceArra objectAtIndex:_counter] withSource:source withTarget:target];
    
    
   
    
    
    
    
}


@end
