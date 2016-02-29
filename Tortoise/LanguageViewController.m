//
//  LanguageViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "LanguageViewController.h"
#import "TTAPIHandler.h"
#import "KLCPopup.h"
#import "LanguageTableView.h"
#import "LanguageDS.h"
#import "LoggedInUserDS.h"
#import "HomeViewController.h"
#import "LanguageDataManager.h"
#import "TranslatorManager.h"
#import "DVSwitch.h"
@interface LanguageViewController ()<LanguageTableViewDelegate>
@property (nonatomic,strong) LanguageTableView *languageTableView;
@property (nonatomic,strong) KLCPopup *klcPopView;
@property (nonatomic,weak) IBOutlet UILabel *languageLabel;
@property (nonatomic,weak) IBOutlet UIImageView *speakrImageView;
@property (nonatomic,weak) IBOutlet UIImageView *textCheckBoxImageView;
@property (nonatomic,weak) IBOutlet UIImageView *audioCheckBoxImageView;
@property (nonatomic,weak) IBOutlet UILabel *loggedInUserLbl;
@property (nonatomic,weak) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) DVSwitch *switcher;

-(IBAction)continueButtonTapped:(id)sender;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpLanguageView];
    [self setUpSwitchButton];
}


-(void)setUpSwitchButton{
     NSInteger margin = 20;
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[@"Miles", @"Kilometers"]];
    [self.switcher setFont:[UIFont TrotoiseFontOswaldRegular:8.0]];
    [self.switcher setLabelTextColorInsideSlider:[UIColor blackColor]];
    [self.switcher setLabelTextColorOutsideSlider:[UIColor blackColor]];
    [self.switcher setSliderColor:UIColorFromRGB(0x39b3c0)];
    [self.switcher setBackgroundColor:[UIColor clearColor]];//
    self.switcher.layer.borderColor = [UIColorFromRGB(0x39b3c0) CGColor]; //[[UIColor grayColor] CGColor];
    self.switcher.layer.borderWidth = 1;
    self.switcher.layer.cornerRadius = 16;
    
                               //:UIColorFromRGB(0x39b3c0)];
    
    self.switcher.frame = CGRectMake(margin, 8, 170, 30);
    [self.switchView addSubview:self.switcher];
    [self.switcher selectIndex:1 animated:YES];
    [self.switcher setPressedHandler:^(NSUInteger index) {
        if (index==0) {
            [APP_DELEGATE setRangeType:TRRANGE_MILETYPE];
        }else{
            [APP_DELEGATE setRangeType:TRRANGE_KILOMETERTYPE];
            
        }
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        
    }];

}
-(void)setUpLanguageView{
    
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    self.loggedInUserLbl.text = [NSString stringWithFormat:@"Welcome %@",loggedInUser.name];
    
    if(loggedInUser.selectedLanguageDS){
        
        [self updateLanguageDetailsOnScreen:loggedInUser.selectedLanguageDS];
    }else{
        [APP_DELEGATE setDefaultLanguage];
        loggedInUser = [APP_DELEGATE getLoggedInUserData];

        [self updateLanguageDetailsOnScreen:loggedInUser.selectedLanguageDS];

    }
    
    
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onTapGestureEventFired:)] ;
    [recognizer setNumberOfTapsRequired:01];
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguageTableView" owner:self options:nil];
    self.languageTableView =  (LanguageTableView *)[arr objectAtIndex:0];
    [self.languageDisplayView addGestureRecognizer:recognizer];
    self.languageTableView.delegate = self;
    _klcPopView = [KLCPopup popupWithContentView:self.languageTableView];
    
    [self.languageTableView setUpLanguageData:[APP_DELEGATE getLanguageDataArray]];
    
    
    if(loggedInUser.imageUrl!=nil){
        
            [self setProfileImageWithUrl:loggedInUser.imageUrl];
//        [self performSelector:@selector(performMethodAfterDelay:) withObject:loggedInUser afterDelay:0.5];
        
        
    }

}
-(void)performMethodAfterDelay:(LoggedInUserDS *)loggedInUser{

    [self setProfileImageWithUrl:loggedInUser.imageUrl];
    
}

-(void)setDefaultLanguage:(NSArray *)languageArr{
    
    [languageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LanguageDS *languageDs = (LanguageDS *)obj;
        if ([languageDs.name isEqualToString:@"English (US)"]) {
            
            [self updateLanguageDetailsOnScreen:languageDs];
            *stop = YES;
            return ;
            
        }
    }];
}
-(void)setProfileImageWithUrl:(NSURL *)url{
    
    [self.profileImageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            self.profileImageView.image = [Utilities makeRoundedImage:image radius:21];//image;
//            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
//            self.profileImageView.clipsToBounds = YES;
//            self.profileImageView.layer.borderWidth = 3.0f;
//            self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            // do something with image
        }
        
    }];
}

-(void)updateLanguageDetailsOnScreen:(LanguageDS *)languageDS{
    
    self.textCheckBoxImageView.image = [UIImage imageNamed:@"checkbox"];
    
    if(languageDS.nuanceRelationship !=nil){
        self.speakrImageView.hidden = NO;
        self.audioCheckBoxImageView.image = [UIImage imageNamed:@"checkbox"];
    }else{
        self.speakrImageView.hidden = YES;
        self.audioCheckBoxImageView.image = [UIImage imageNamed:@"uncheck"];
    }
    self.languageLabel.text = languageDS.name;
    [APP_DELEGATE setSelectedLanguageData:languageDS];


    
}

-(void)onTranslationComplete:(NSNotification *)notification{
    
    NSArray *aarr = (NSArray *)[notification object];
    [APP_DELEGATE setCityMonumentListArray:aarr];
    [Utilities hideHUDForView:self.view];

}

-(void)languageTableView:(LanguageTableView *)languageTableView didSelectLanguageData:(LanguageDS *)data{
    
    [_klcPopView dismiss:YES];
    LanguageDS *la = [APP_DELEGATE getLanguage];

    [self updateLanguageDetailsOnScreen:data];

    [APP_DELEGATE setSelectedLanguageData:data];
    
    [Utilities addHUDForView:self.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
    if([data.transCode isEqualToString:@"hi"]){
       
        CLLocationCoordinate2D coordinate = [APP_DELEGATE getCurrentLocationCoordinate ];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude ];
        NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude ];

        
        [[TTAPIHandler sharedWorker] getMonumentListByRange:lat withLongitude:longitude withrad:@"30"withLanguageLocale:@"hi" withRequestType:
         GET_MONUMENT_LIST_BY_RANGE responseHandler:^(NSArray *cityMonumentArra, NSError *error) {
             
             [APP_DELEGATE setCityMonumentListArray:cityMonumentArra];
              [Utilities hideHUDForView:self.view];
             
         }];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];

        [[TranslatorManager sharedInstance] translateLanguage:[APP_DELEGATE getMonumentListArray] withSource:la.transCode withTarget:data.transCode];
    }
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dspose of any resources that can be recreated.
}
-(void)onTapGestureEventFired:(UIGestureRecognizer *)recongixer{
    [_klcPopView show];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
