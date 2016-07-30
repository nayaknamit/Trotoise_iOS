//
//  LanguagePopUpView.h
//  Tortoise
//
//  Created by Namit Nayak on 2/27/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageDS.h"
@protocol LanguagePopUpViewDelegate;
@protocol LanguagePopUpViewDelegate <NSObject>
@optional

-(void)languagePopUpViewDidOkButonTappedWithLanguage:(Language *)languageObject;
-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(Language *)languageObject;

@end
@interface LanguagePopUpView : UIView
@property(nonatomic,assign)id<LanguagePopUpViewDelegate>delegate;
-(void)setUpLanguagePopUpView;
-(void)setUpLanguageOfflinePopUpViewCity:(NSString *)cityName;
-(void)initOfflineScreen :(Language *)language;

@end

@interface LanguagePopupViewCell : UITableViewCell  
@property (nonatomic,weak) IBOutlet UILabel *labelLanguage;
@property  (nonatomic,weak) IBOutlet UIImageView *speakerImageView;

@end