//
//  OfflineListViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Language;
@interface OfflineListViewController : UIViewController
@property (nonatomic,strong) Language *selectedLanguageFromGlobe;
@property (nonatomic,strong) NSString *cityName;
-(IBAction)closeBtnTapped:(id)sender;

@end
