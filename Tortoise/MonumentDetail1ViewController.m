
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
#import "MonumentListDS.h"
#import "SKSConfiguration.h"
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LanguageDataManager.h"
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
    [self setMonumentDsObject:self.monumentDetailObj];
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [avSession setActive:YES error:nil];
    [avSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSLog(@"volume=%f",[[AVAudioSession sharedInstance] outputVolume]);
    
    _skTransaction = nil;
    _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];

    self.imageViews = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 440;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded ];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
     return UITableViewAutomaticDimension;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" indexPath %@",[indexPath description]);
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        NSString *CellIdentifier1 = @"ImageScroller";
         ImageScrollerTableViewCell *  imageSceollrCell = (ImageScrollerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        imageSceollrCell.monumentDetailObj =  self.monumentDetailDsObj;
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
    cell.desTextView.text = self.monumentDetailDsObj.desc;
    NSArray *ss = [self.monumentDetailDsObj.desc componentsSeparatedByString:@"\\n"];
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
    if (_selectedLanguageFromGlobe ==nil) {
        _selectedLanguageFromGlobe = [[LanguageDataManager sharedManager] getDefaultLanguageObject];

    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontOswaldRegular:22], NSFontAttributeName, nil]];
    
    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
//    [customButton setTitle:@"En" forState:UIControlStateNormal];
    NSString *languageLocale = [_selectedLanguageFromGlobe.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@" %@",languageLocale] forState:UIControlStateNormal];
    
//    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];

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

-(NSString *)getLanguageLocale{
    NSString * defaultLanguageLocale = @"en";
    if ([_selectedLanguageFromGlobe.transCode isEqualToString:@"hi"]) {
        defaultLanguageLocale = @"hi";
    }
    return defaultLanguageLocale;
}

-(void)languagePopUpViewDidOkButonTappedWithLanguage:(Language *)languageObject{
    [_klcPopLanguageView dismiss:YES];
//    [Utilities addHUDForView:self.view];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _selectedLanguageFromGlobe = languageObject;
    [hud.label setFont:[UIFont TrotoiseFontLightRegular:12.0]];
    hud.label.numberOfLines = 2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
    
        __weak MonumentDetail1ViewController *weakSelf = self;
        [[TTAPIHandler sharedWorker] getMonumentDetailByMonumentID:[self.monumentDetailDsObj.monumentID stringValue] withLanguageLocale:[self getLanguageLocale] withRequestType:GET_MONUMENT_DETAIL_BY_MONUMENTID withResponseHandler:^(id obj, NSError *error) {
           
            
            
            if (![[self getLanguageLocale] isEqualToString:@"hi"]) {
                [[TranslatorManager sharedInstance] translateLanguageWithSource:@"en" withTarget:languageObject.transCode withRequestSource:TR_TRANSLATE_REQUEST_DETAIL withMonumentObj:(MonumentListDS *)obj withLoaderHandler:^(NSString *text) {
                    hud.label.text = text;
                }];
            
            }else{
                
                 weakSelf.monumentDetailDsObj = (MonumentListDS *)obj;
                [weakSelf.tableView reloadData];
                [Utilities hideHUDForView:weakSelf.view];
                [weakSelf setGlobeLanguage:languageObject];
            }
        
        }];

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
    self.monumentDetailDsObj = (MonumentListDS *)[aarr lastObject];
    
    [self.tableView reloadData];
    [self setGlobeLanguage:_selectedLanguageFromGlobe];
    [Utilities hideHUDForView:self.view];
 
   
}


-(void)setGlobeLanguage:(Language *)languageDS{
    
    
    NSString *languageLocale = [_selectedLanguageFromGlobe.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@" %@",languageLocale] forState:UIControlStateNormal];
    
//    [customButton setTitle:[NSString stringWithFormat:@"%@",languageLocale] forState:UIControlStateHighlighted];
    [customButton.titleLabel setFont:[UIFont TrotoiseFontCondensedRegular:16]];
    [customButton sizeToFit];

}
-(void)setMonumentDsObject:(MonumentList *)monumentList{
    self.monumentDetailDsObj = [[MonumentListDS alloc] init];
    
    self.monumentDetailDsObj.name = monumentList.name;
    self.monumentDetailDsObj.desc = monumentList.desc;
    self.monumentDetailDsObj.shortDesc = monumentList.shortDesc;
    self.monumentDetailDsObj.addInfo  = monumentList.addInfo;
    self.monumentDetailDsObj.latitude = monumentList.latitude;
    self.monumentDetailDsObj.longitude = monumentList.longitude;
    self.monumentDetailDsObj.monumentID = monumentList.id;
    self.monumentDetailDsObj.thumbnail = monumentList.thumbnail;
    self.monumentDetailDsObj.imageAttributes = (NSSet *)monumentList.imageAttributes;
    
    
}

#pragma 
- (UIViewController *)parentViewControllerForFullScreenManager{
    return self;
}

@end
