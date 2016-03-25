//
//  TextToSpeech.m
//  Tortoise
//
//  Created by Namit Nayak on 3/8/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
enum {
    SKSIdle = 1,
    SKSListening = 2,
    SKSProcessing = 3
};
typedef NSUInteger SKSState;

#import "TextToSpeech.h"
#import "SKSConfiguration.h"
@interface TextToSpeech()<SKTransactionDelegate, SKAudioPlayerDelegate>
@property (nonatomic,strong) SKSession* skSession;
@property (nonatomic,strong) SKTransaction *skTransaction;
@property (nonatomic)SKSState state;

@end

@implementation TextToSpeech
+(id)sharedInstance{
    
    static TextToSpeech *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[TextToSpeech alloc] init];
    });
    
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        _skTransaction = nil;
        _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];
        _recognitionType = SKTransactionSpeechTypeSearch;
        _endpointer = SKTransactionEndOfSpeechDetectionShort;
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

- (void)recognizeForLanguage:(NSString *)lang
{
    // Start listening to the user.
//    [_toggleRecogButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    _skTransaction = [_skSession recognizeWithType:self.recognitionType
                                         detection:self.endpointer
                                          language:lang
                                          delegate:self];
}

- (void)stopRecording
{
    // Stop recording the user.
    [_skTransaction stopRecording];
    // Disable the button until we received notification that the transaction is completed.
//    [_toggleRecogButton setEnabled:NO];
}

- (void)cancel
{
    // Cancel the Reco transaction.
    // This will only cancel if we have not received a response from the server yet.
    [_skTransaction cancel];
}
# pragma mark - SKTransactionDelegate

- (void)transactionDidBeginRecording:(SKTransaction *)transaction
{
    
    _state = SKSListening;
//    [self startPollingVolume];
//    [_toggleRecogButton setTitle:@"Listening.." forState:UIControlStateNormal];
}

- (void)transactionDidFinishRecording:(SKTransaction *)transaction
{
    
    _state = SKSProcessing;
//    [self stopPollingVolume];
//    [_toggleRecogButton setTitle:@"Processing.." forState:UIControlStateNormal];
}

- (void)transaction:(SKTransaction *)transaction didReceiveRecognition:(SKRecognition *)recognition
{
//    [self log:[NSString stringWithFormat:@"didReceiveRecognition: %@", recognition.text]];
    NSLog(@"%@",[NSString stringWithFormat:@"didReceiveRecognition: %@", recognition.text]);
    _state = SKSIdle;
    
    if ([self.delegate  respondsToSelector:@selector(textToSpeechConversionText:)]) {
        [self.delegate textToSpeechConversionText:recognition.text];
    }
}

- (void)transaction:(SKTransaction *)transaction didReceiveServiceResponse:(NSDictionary *)response
{
//    [self log:[NSString stringWithFormat:@"didReceiveServiceResponse: %@", response]];
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
//    [self log:@"didFinishWithSuggestion"];
    
    _state = SKSIdle;
//    [self resetTransaction];
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
//    [self log:[NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]];
    
    _state = SKSIdle;
//    [self resetTransaction];
}
@end
