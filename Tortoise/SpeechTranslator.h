//
//  SpeechTranslator.h
//  Tortoise
//
//  Created by Namit Nayak on 2/18/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpeechKit/SpeechKit.h>
@interface SpeechTranslator : NSObject


+(id)sharedInstance;
-(void)initiateTransistionForText:(NSString *)transitionText withLanguageCode:(NSString *)languageCode withVoiceName:(NSString *)voiceName;

-(void)stopAudio;
@end
