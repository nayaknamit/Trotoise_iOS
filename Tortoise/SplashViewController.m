    //
//  SplashViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 10/11/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SCFacebook.h"
#import "SplashViewController.h"
#import "LanguageViewController.h"
#import "SplashTextView.h"
#import "OfflineImageOperations.h"
#import "OfflineMainListViewController.h"
@interface SplashViewController()
{
    
    CGFloat scrollViewWidth;
    BOOL pageControlBeingUsed;
}
@property (nonatomic,strong) NSArray *splashImageArra;

@property (nonatomic,strong) NSMutableArray *splashTextArra;
-(IBAction)loginButtonClicked:(id)sender;
@end

@implementation SplashViewController
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    _signInButton.colorScheme  = kGIDSignInButtonColorSchemeDark;
    _signInButton.style =kGIDSignInButtonStyleWide;
    
    self.splashImageArra = [NSArray arrayWithObjects:@"walkthrough_01",@"walkthrough_02",@"walkthrough_03",@"walkthrough_04",@"walkthrough_05", nil];
    self.splashTextArra = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_ONE,@"title",SPLASH_TEXT_DESC_ONE,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_TWO,@"title",SPLASH_TEXT_DESC_TWO,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_THREE,@"title",SPLASH_TEXT_DESC_THREEE,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_FOUR,@"title",SPLASH_TEXT_DESC_FOUR,@"desc", nil],[NSDictionary dictionaryWithObjectsAndKeys:SPLASH_TEXT_TITLE_FIVE,@"title",SPLASH_TEXT_DESC_FIVE,@"desc", nil], nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedInViaGmailSignIn:) name:@"GOOGLE_SIGIN_PROFILE" object:nil];
    
    
    [self setSplashScreen];
   
    
    if (![APP_DELEGATE isNetworkAvailable] ) {
        OfflineImageOperations *op = [[OfflineImageOperations alloc] init];
        NSArray * arra = [op getCityListArra];
        if (arra == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Internet Available" message:ERROR_NETWORK_MESSAGE_1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings",nil];
            [alertView show];
            return;
        }
        
        self.facebookBtn.hidden = YES;
        self.offlineBtn.hidden = NO;
        self.signInButton.hidden = YES;
        
        
    }else{
        self.facebookBtn.hidden = NO;
        self.signInButton.hidden = NO;
        self.offlineBtn.hidden = YES;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    if (alertView.tag == 121) {
        if (buttonIndex == 0) {
            
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        }
    } else {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
        
    }
    //code for opening settings app in iOS 8
    
    
    
}

#pragma mark - 
#pragma mark GOOGLE SIGNIN METHODS

-(void)loggedInViaGmailSignIn :(NSNotification *)notification{
    
    LanguageViewController *languageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanguageViewController"];
    [self.navigationController pushViewController:languageVC animated:YES];
    

}
/*
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {

}*/

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - FACEBOOK SignIn Methods

-(IBAction)loginButtonClicked:(id)sender
{

//    [[NSUserDefaults standardUserDefaults] setObject:_loggedInUserDS forKey:@"LoggedInUserInfo"];
   
    NSDictionary *loggedInUserDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedInUserInfo"];
    
    
    
    
    if(loggedInUserDict!=nil){
        

        [APP_DELEGATE setLoggedInUserData:loggedInUserDict isFacebookData:NO];
        
        LanguageViewController *languageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanguageViewController"];
        [self.navigationController pushViewController:languageVC animated:YES];

        
    }else{
        [SCFacebook loginCallBack:^(BOOL success, id result) {
            
            
            if (success) {
                [self getUserInfo];
            }else{
                
            }
        }];

    }
    
    
}

- (void)getUserInfo
{
    
    [SCFacebook getUserFields:@"id,cover, name, email, birthday, about, picture" callBack:^(BOOL success, id result) {
        if (success) {
            
            [APP_DELEGATE setLoggedInUserData:(NSDictionary *)result isFacebookData:YES];
            
            LanguageViewController *languageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanguageViewController"];
            [self.navigationController pushViewController:languageVC animated:YES];
            
            
            NSLog(@"%@", result);
            }else{
            
                NSLog(@"%@",[result description]);
            }
    }];
}


#pragma mark -
#pragma mark - SplashScreen Methods
-(void)setSplashScreen{
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    scrollViewWidth = self.scrollView.frame.size.width;
    CGFloat scrollViewHeight = self.scrollView.frame.size.height;
    NSInteger counter =0;
    for(NSString *imageNameString in self.splashImageArra){
      
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollViewWidth*counter, -20, scrollViewWidth, scrollViewHeight+20)];
        
        view.translatesAutoresizingMaskIntoConstraints = YES;
        view.autoresizesSubviews = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, view.frame.size.width, view.frame.size.height)];
        
        
        
        imageViewOne.translatesAutoresizingMaskIntoConstraints = YES;
        imageViewOne.image = [UIImage imageNamed:imageNameString];
        imageViewOne.autoresizesSubviews = YES;
        
        

        NSDictionary *textDict = [self.splashTextArra objectAtIndex:counter];


        
        
        
        [view addSubview:imageViewOne];
        
        SplashTextView *splashTextView = (SplashTextView *)[[[NSBundle mainBundle] loadNibNamed:@"SplashTextView" owner:self options:nil] objectAtIndex:0];

        splashTextView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2+20, [UIScreen mainScreen].bounds.size.width, 100);
        
        splashTextView.titleLabel.text =[textDict objectForKey:@"title"];
        splashTextView.descLabel.text = [textDict objectForKey:@"desc"];
        
        [view insertSubview:splashTextView aboveSubview:imageViewOne];
        
        counter++;
        [self.scrollView addSubview:view];
        
    }
    


    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.splashImageArra count], self.scrollView.frame.size.height-20);
    
    
    self.scrollView.delegate = self;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.splashImageArra count];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}






- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
  
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    pageControlBeingUsed = NO;
    
    
}

- (IBAction)changePage {
    // Update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
    // value changing. If we don't do this, a noticeable "flashing" occurs
    // as the the scroll delegate will temporarily switch back the page
    // number.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
    
    CGFloat pageWidth = self.scrollView.frame.size.width +4;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
//    NSNumber* currentIndex = [NSNumber numberWithInt:round(scrollView.contentOffset.x / pageWidth)];
    
    //Then just update your scrollviews offset with
    
    
//    [scrollView setContentOffset:CGPointMake([currentIndex intValue] * pageWidth, 0) animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.scrollView = nil;
//    self.splashImageArra = nil;
 
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender NS_AVAILABLE_IOS(5_0){
    NSLog(@"sa");
    UINavigationController *navigationC = (UINavigationController *)segue.destinationViewController;
    
    OfflineMainListViewController * offlineMLVC = (OfflineMainListViewController *)navigationC.topViewController;
    offlineMLVC.checkScreenFrom = @"SplashScreen";
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    NSLog(@"sa");

}
@end
