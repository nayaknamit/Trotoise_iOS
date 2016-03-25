//
//  TextToSpeech.h
//  Tortoise
//
//  Created by Namit Nayak on 3/8/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpeechKit/SpeechKit.h>
@protocol TextToSpeechDelegate;
@interface TextToSpeech : NSObject
+(id)sharedInstance;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *recognitionType;
@property (assign, nonatomic) SKTransactionEndOfSpeechDetection endpointer;

@property (assign) id<TextToSpeechDelegate> delegate;
- (void)recognizeForLanguage:(NSString *)lang;


@end

@protocol TextToSpeechDelegate <NSObject>
@optional
-(void)textToSpeechConversionText:(NSString *)string;

@end