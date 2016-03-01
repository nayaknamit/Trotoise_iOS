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
@end
@implementation SpeechTranslator


+(id)sharedInstance{
    
    static SpeechTranslator *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[SpeechTranslator alloc] init];
    });
    
    return sharedInstance;
}
-(id)init{
    if (self = [super init]) {
         _skTransaction = nil;
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
        // Start a TTS transaction
    _skTransaction = [_skSession speakString:transitionText
                                    withLanguage:languageCode
                                        delegate:self];
   
//        _skTransaction = [_skSession speakString:transitionText withVoice:voiceName delegate:self];
        
       
        
    } else {
        // Cancel the TTS transaction
        [_skTransaction cancel];
        
        [self resetTransaction];
    }
}



-(void)stopAudio{
    
    [_skSession.audioPlayer stop];
}
#pragma mark - SKTransactionDelegate

- (void)transaction:(SKTransaction *)transaction didReceiveAudio:(SKAudio *)audio
{
    NSLog(@"didReceiveAudio");
    
//    [self resetTransaction];
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
    
    [self resetTransaction];
}

#pragma mark - SKAudioPlayerDelegate

- (void)audioPlayer:(SKAudioPlayer *)player willBeginPlaying:(SKAudio *)audio
{
    NSLog(@"willBeginPlaying");
    
    // The TTS Audio will begin playing.
}

- (void)audioPlayer:(SKAudioPlayer *)player didFinishPlaying:(SKAudio *)audio
{
    NSLog(@"didFinishPlaying");
    
    // The TTS Audio has finished playing.
}

- (void)resetTransaction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _skTransaction = nil;

    }];
}

@end
