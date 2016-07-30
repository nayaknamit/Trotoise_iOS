//
//  OfflineLanguagePopUpView.h
//  Tortoise
//
//  Created by Namit Nayak on 4/21/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OfflineLanguagePopUpViewDelegate;
@protocol OfflineLanguagePopUpViewDelegate <NSObject>
@optional

-(void)languagePopUpViewDidOkButonTappedWithLanguage:(Language *)languageObject;
-(void)languagePopUpViewOperationCompleteForCity:(NSString *)cityName;
-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(Language *)languageObject;
@end
@interface OfflineLanguagePopUpView : UIView
-(void)setSearchBarValue :(NSString *)searchBarVal;
-(void)initScreen;
@property(nonatomic,assign)id<OfflineLanguagePopUpViewDelegate>delegate;
-(void)setUpLanguagePopUpView;
@end
@interface OfflineLanguagePopupViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *labelLanguage;
@property  (nonatomic,weak) IBOutlet UIImageView *speakerImageView;

@end