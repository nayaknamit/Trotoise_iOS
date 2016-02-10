//
//  LanguageViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguageViewController.h"
#import "TTAPIHandler.h"
#import "KLCPopup.h"
#import "LanguageTableView.h"
#import "LanguageDS.h"
#import "LoggedInUserDS.h"
#import "HomeViewController.h"
#import "LanguageDataManager.h"
@interface LanguageViewController ()<LanguageTableViewDelegate>
@property (nonatomic,strong) LanguageTableView *languageTableView;
@property (nonatomic,strong) KLCPopup *klcPopView;
@property (nonatomic,weak) IBOutlet UILabel *languageLabel;
@property (nonatomic,weak) IBOutlet UIImageView *speakrImageView;
@property (nonatomic,weak) IBOutlet UIImageView *textCheckBoxImageView;
@property (nonatomic,weak) IBOutlet UIImageView *audioCheckBoxImageView;
@property (nonatomic,weak) IBOutlet UILabel *loggedInUserLbl;
@property (nonatomic,weak) IBOutlet UIImageView *profileImageView;
-(IBAction)continueButtonTapped:(id)sender;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpLanguageView];
    
}



-(void)setUpLanguageView{
    
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    [APP_DELEGATE setDefaultLanguage];
    self.loggedInUserLbl.text = [NSString stringWithFormat:@"Welcome %@",loggedInUser.name];
    
    
    
    if(loggedInUser.selectedLanguageDS){
        
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
            self.profileImageView.image = image;
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
            self.profileImageView.clipsToBounds = YES;
            self.profileImageView.layer.borderWidth = 3.0f;
            self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
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
-(IBAction)continueButtonTapped:(id)sender{
   
    
}
-(void)languageTableView:(LanguageTableView *)languageTableView didSelectLanguageData:(LanguageDS *)data{
    
    [_klcPopView dismiss:YES];
    [self updateLanguageDetailsOnScreen:data];
    
    [APP_DELEGATE setSelectedLanguageData:data];
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
