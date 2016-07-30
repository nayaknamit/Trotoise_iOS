//
//  SpeechTranslator.m
//  Tortoise
//
//  Created by Namit Nayak on 2/18/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "SpeechTranslator.h"
#import "SKSConfiguration.h"

@interface SpeechTranslator ()<SKTransactionDelegate, SKAudioPlayerDelegate>
@property (nonatomic,strong) SKSession* skSession;
@property (nonatomic,strong) SKTransaction *skTransaction;
@property (nonatomic,strong)SKAudio *audioPlayingCurrently;
@end
@implementation SpeechTranslator

static SpeechTranslator *sharedInstance = nil;
static dispatch_once_t once_token = 0;

+(id)sharedInstance{

//    static dispatch_once_t pred;
//    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&once_token, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[SpeechTranslator alloc] init];
        }
       
    });
    
    return sharedInstance;
}

+(void)setSharedInstance:(SpeechTranslator *)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    sharedInstance = instance;
}

-(id)init{
    if (self = [super init]) {
         _skTransaction = nil;
        _skSession  = nil;
        _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];
        
        if (!_skSession) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"SpeechKit"
                                                               message:@"Failed to initialize SpeechKit session."
                                                              delegate:nil cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    return self;
}


-(void)initiateTransistionForText:(NSString *)transitionText withLanguageCode:(NSString *)languageCode withVoiceName:(NSString *)voiceName{
    
    if (!_skTransaction) {
     _skTransaction = [_skSession speakString:transitionText
                                    withLanguage:languageCode
                                        delegate:self];

    }
     else {
        // Cancel the TTS transaction
        [_skTransaction cancel];
        
        [self resetTransaction];
    }
}



-(void)stopAudio{
    @try {
        if (_skTransaction !=nil) {
            [_skTransaction cancel];
            [_skSession.audioPlayer stop];
            [self resetTransaction];
            //    [_skSession.audioPlayer ]
            if (_audioPlayingCurrently) {
                
                
                [_skSession.audioPlayer dequeue:_audioPlayingCurrently];
            }

        }
       
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
#pragma mark - SKTransactionDelegate

//- (void)transaction:(SKTransaction *)transaction didReceiveAudio:(SKAudio *)audio
//{
//    NSLog(@"didReceiveAudio");
////    [_skSession.audioPlayer playAudio:audio];
//
////    [self resetTransaction];
//
//}
- (void)transaction:(SKTransaction *)transaction didReceiveAudio:(SKAudio *)audio
{
    _audioPlayingCurrently = audio;
//    [_skSession.audioPlayer playAudio:audio];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"TRANSACTION_RECIEVED" object:nil];

}
- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    NSLog(@"didFinishWithSuggestion");
    
    // Notification of a successful transaction. Nothing to do here.
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"%@",[NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]);
    
    // Something went wrong. Check Configuration.mm to ensure that your settings are correct.
    // The user could also be offline, so be sure to handle this case appropriately.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRANSACTION_RECIEVED_ERROR" object:nil];
    
}

#pragma mark - SKAudioPlayerDelegate

- (void)audioPlayer:(SKAudioPlayer *)player willBeginPlaying:(SKAudio *)audio
{
    NSLog(@"willBeginPlaying");
//    [_skSession.audioPlayer playAudio:audio];    
    // The TTS Audio will begin playing.

}

- (void)audioPlayer:(SKAudioPlayer *)player didFinishPlaying:(SKAudio *)audio
{
    NSLog(@"didFinishPlaying");

    [player stop];
    // The TTS Audio has finished playing.
}

- (void)resetTransaction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _skTransaction = nil;

    }];
}

@end
