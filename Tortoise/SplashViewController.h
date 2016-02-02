//
//  SplashViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 10/11/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
@interface SplashViewController : UIViewController <UIScrollViewDelegate ,GIDSignInUIDelegate>

@property(nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) IBOutlet UIButton *nextBtn;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
- (IBAction)changePage;

@end
