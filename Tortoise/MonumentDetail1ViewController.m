
//  MonumentDetail1ViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.


#import "MonumentDetail1ViewController.h"
#import "UIFont+Trotoise.h"
#import "MonumentList+CoreDataProperties.h"

#import "DetailTextViewTableViewCell.h"
#import "ImageScrollerTableViewCell.h"
#import "Language.h"
#import "LanguagePopUpView.h"
#import "KLCPopup.h"
#import "TTAPIHandler.h"
#import "TranslatorManager.h"
#import "SpeechTranslator.h"

#import "SKSConfiguration.h"
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>

#import "MonumentDataManager.h"
static NSString* const CellIdentifier = @"DetailTextView";

@interface MonumentDetail1ViewController ()<SKTransactionDelegate, SKAudioPlayerDelegate,LanguagePopUpViewDelegate, UIScrollViewDelegate ,ImageScrollerTableViewCellDelegate>
{
    
    UIButton* customButton;
    BOOL pageControlBeingUsed;
    SKSession* _skSession;
    SKTransaction *_skTransaction;
}



@property (nonatomic,strong) LanguagePopUpView *languagePopView;
@property (nonatomic,strong) KLCPopup *klcPopLanguageView;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong)__block NSMutableArray *imageViews;

-(IBAction)mapDirectionButtonTapped:(id)sender;
-(IBAction)speakerBtnTapped:(id)sender;
-(IBAction)closeBtnTapped:(id)sender;
@end

@implementation MonumentDetail1ViewController

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

-(IBAction)closeBtnTapped:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFY_STOP_AUDIO" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self setUpLanguagePopUp];
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [avSession setActive:YES error:nil];
    [avSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSLog(@"volume=%f",[[AVAudioSession sharedInstance] outputVolume]);
    
    _skTransaction = nil;
    _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];

    self.imageViews = [NSMutableArray array];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//
    self.tableView.estimatedRowHeight = 440;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded ];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.tableView setNeedsLayout];
//    [self.tableView layoutIfNeeded ];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   //  Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row ==0){
        return 240;
    }
//    else if(indexPath.row ==1){
////        static DetailTextViewTableViewCell *cell = nil;
////        static dispatch_once_t onceToken;
////        
////        dispatch_once(&onceToken, ^{
////            cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////        });
////        
////        [self setUpCell:cell atIndexPath:indexPath];
////        
////        return [self calculateHeightForConfiguredSizingCell:cell];
//        return UITableViewAutomaticDimension;
//    }
     return UITableViewAutomaticDimension;
    return 0;
}

// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" indexPath %@",[indexPath description]);
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        NSString *CellIdentifier1 = @"ImageScroller";
         ImageScrollerTableViewCell *  imageSceollrCell = (ImageScrollerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        imageSceollrCell.monumentDetailObj =  self.monumentDetailObj;
        imageSceollrCell.selectedLanguage = _selectedLanguageFromGlobe;
        [imageSceollrCell setUpScrollViewImages];
        imageSceollrCell.delegate = self;
        return imageSceollrCell;
    }else if(indexPath.row == 1){
        
               DetailTextViewTableViewCell * detailCell = (DetailTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        
        [self setUpCell:detailCell atIndexPath:indexPath];
        return detailCell;
    }
  
    return cell;
}
- (void)setUpCell:(DetailTextViewTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.descriptionLabel.text = self.monumentDetailObj.desc;
    cell.desTextView.text = self.monumentDetailObj.desc;
    NSArray *ss = [self.monumentDetailObj.desc componentsSeparatedByString:@"\\n"];
    NSMutableString *string = [NSMutableString stringWithFormat:@""];
    for (NSString *a in ss){
        [string appendString:[NSString stringWithFormat:@"%@ \n",a]];
        
        
    }
    [cell.desTextView setFont:[UIFont TrotoiseFontCondensedRegular:14]];
    [cell. desTextView layoutIfNeeded];
    cell.desTextView.text = (NSString *)string;
    
    //@"There are many variations of passages of Lorem Ipsum available, \n \n \n but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.";
}


- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - UITableViewDataDelegate protocol methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    if (_selectedLanguageFromGlobe ==nil) {
     _selectedLanguageFromGlobe =   loggedInUser.selectedLanguageDS;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontCondensedRegular:24], NSFontAttributeName, nil]];
    
    
    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
//    [customButton setTitle:@"En" forState:UIControlStateNormal];
    NSString *languageLocale = [_selectedLanguageFromGlobe.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateNormal];
    
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];

    [customButton.titleLabel setFont:[UIFont TrotoiseFontCondensedRegular:16]];
    [customButton sizeToFit];
    [customButton addTarget:self action:@selector(customLanguageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    
}
-(void)customLanguageButtonTapped:(id)sender{
    // LanguageViewController *languageVC =   [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageViewController"];
    //
    //    [self.navigationController presentViewController:languageVC animated:YES completion:nil];
    [_klcPopLanguageView show];
}
#pragma ImageScrollerTableViewCellDelegate METHODS

-(void)mediaFocusManagerWillAppearForDelegate{
    self.statusBarHidden = YES;
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}
-(void)mediaFocusManagerWillDisappear{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

-(UIViewController *)parentViewControllerForMediaFocusManager{
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return self;
}



/*
 #pragma mark - Navigation
 
  In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  Get the new view controller using [segue destinationViewController].
  Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark LanguagePopView Delegate
-(void)setUpLanguagePopUp{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguagePopUp" owner:self options:nil];
    
    self.languagePopView = (LanguagePopUpView *)[arr objectAtIndex:0];
    self.languagePopView.frame = CGRectMake(self.languagePopView.frame.origin.x, self.languagePopView.frame.origin.y, 303.0f, 340.0f);
    self.languagePopView.delegate = self;
    [self.languagePopView setUpLanguagePopUpView];
    _klcPopLanguageView = [KLCPopup popupWithContentView:self.languagePopView];
    
    
}
-(void)languagePopUpViewDidOkButonTappedWithLanguage:(Language *)languageObject{
    [_klcPopLanguageView dismiss:YES];
    [Utilities addHUDForView:self.view];
    _selectedLanguageFromGlobe = languageObject;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
    if([languageObject.transCode isEqualToString:@"hi"]){
        
        CLLocationCoordinate2D coordinate = [APP_DELEGATE getCurrentLocationCoordinate ];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude ];
        NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude ];
        
        __weak MonumentDetail1ViewController *weakSelf = self;

        [[TTAPIHandler sharedWorker] getMonumentListByRange:lat withLongitude:longitude withrad:@"30"withLanguageLocale:@"hi" withRequestType:
         GET_MONUMENT_LIST_BY_RANGE responseHandler:^(BOOL isResultSuccess, NSError *error) {
             
             weakSelf.monumentDetailObj = (MonumentList *)[[MonumentDataManager sharedManager] getMonumentListDetailObjectForID:weakSelf.monumentDetailObj.id];
             [weakSelf.tableView reloadData];

             [Utilities hideHUDForView:self.view];
             [weakSelf setGlobeLanguage:languageObject];
         }];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
//        [[TranslatorManager sharedInstance] translateLanguageForMonumentObject:self.monumentDetailObj withSource:la.transCode withTarget:languageObject.transCode];
        [[TranslatorManager sharedInstance] translateLanguage:[NSArray arrayWithObjects:self.monumentDetailObj, nil]withSource:@"en" withTarget:languageObject.transCode withRequestSource:TR_TRANSLATE_REQUEST_DETAIL];
        
    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GA_TRANSLATE_DONE object:nil];
}
-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(Language *)languageObject{
    
    [_klcPopLanguageView dismiss:YES];
}
-(void)onTranslationComplete:(NSNotification *)notification{
    
    NSArray *aarr = (NSArray *)[notification object];
//    [APP_DELEGATE setCityMonumentListArray:aarr];
    __weak MonumentDetail1ViewController *weakSelf = self;
    [aarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MonumentListDS *objMonument = (MonumentListDS *)obj;
       
//        if ([objMonument.monumentID integerValue] == [weakSelf.monumentDetailObj.monumentID integerValue]) {
//            weakSelf.monumentDetailObj = objMonument;
//            *stop = YES;
//            return ;
//        }
        
    }];
    [self.tableView reloadData];
    [self setGlobeLanguage:_selectedLanguageFromGlobe];
    [Utilities hideHUDForView:self.view];
 
   
}


-(void)setGlobeLanguage:(LanguageDS *)languageDS{
    
    
    NSString *languageLocale = [_selectedLanguageFromGlobe.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateNormal];
    
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];
    
}


@end
