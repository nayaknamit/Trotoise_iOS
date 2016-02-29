
//  MonumentDetail1ViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.


#import "MonumentDetail1ViewController.h"
#import "UIFont+Trotoise.h"
#import "MonumentListDS.h"
#import "ASMediaFocusManager.h"

#import "DetailTextViewTableViewCell.h"
#import "ImageScrollerTableViewCell.h"
#import "LanguageDS.h"
#import "LanguagePopUpView.h"
#import "KLCPopup.h"
#import "TTAPIHandler.h"
#import "TranslatorManager.h"
@interface MonumentDetail1ViewController ()<LanguagePopUpViewDelegate, UIScrollViewDelegate ,ImageScrollerTableViewCellDelegate>
{
    
    UIButton* customButton;
    BOOL pageControlBeingUsed;
}
@property (nonatomic,strong) LanguagePopUpView *languagePopView;
@property (nonatomic,strong) KLCPopup *klcPopLanguageView;

@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ASMediaFocusManager *mediaFocusManager;
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
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)speakerBtnTapped:(id)sender{

    
//    [[SpeechTranslator sharedInstance] initiateTransistionForText:self.monumentDetailObj.desc withLanguageCode: withVoiceName:<#(NSString *)#>]
    
}
-(IBAction)mapDirectionButtonTapped:(id)sender{
    
    double lat = [self.monumentDetailObj.latitude doubleValue];
    double lon = [self.monumentDetailObj.longitude doubleValue];
    
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps:"]]) {
    NSString *str = [NSString stringWithFormat:@"comgooglemaps:?q=%@&center=%f,%f&zoom=12&views=traffic",self.monumentDetailObj.name,lat,lon];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url] ;
        } else {
            NSLog(@"Can't use comgooglemaps:");
        }
    
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self setUpLanguagePopUp];
    
    self.imageViews = [NSMutableArray array];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//
    self.tableView.estimatedRowHeight = 240;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded ];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

//    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded ];
    
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
    }else if(indexPath.row ==1){
        return UITableViewAutomaticDimension;
        // */
    }
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
        [imageSceollrCell setUpScrollViewImages];
        imageSceollrCell.delegate = self;
        return imageSceollrCell;
    }else if(indexPath.row == 1){
        
        NSString *CellIdentifier = @"DetailTextView";
        DetailTextViewTableViewCell * detailCell = (DetailTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
////        detailCell.dynamicTVHeight.constant  = detailCell.frame.size.height
//        
////        NSString *convertedToParagph = [NSString stringWithFormat:@"%@",self.monumentDetailObj.desc];
////        convertedToParagph = [convertedToParagph stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\r"];
//       
//        
//        SSDynamicLabel *labelDy = [SSDynamicLabel labelWithFont:@"RobotoCondensed-Regular" baseSize:16.0f];
//        labelDy.textColor = [UIColor darkGrayColor];
//        labelDy.numberOfLines = 250;
//        labelDy.textAlignment = NSTextAlignmentLeft;
////        labelDy.lineBreakMode = NSLineBreakByTruncatingTail;
//        [labelDy setFrame:(CGRect){
//            {10, 10},
//            {CGRectGetWidth(self.view.frame) ,240}
//        }];
//
//        
//        labelDy.dynamicAttributedText = nil;
//        labelDy.text = self.monumentDetailObj.desc;
//        [detailCell.contentView addSubview:labelDy];

//        detailCell.detailTextView.text =self.monumentDetailObj.desc;
        detailCell.descriptionLabel.text = self.monumentDetailObj.desc;
//        detailCell.descriptionLabel.numberOfLines = 0;
//        detailCell.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [detailCell layoutIfNeeded];
        return detailCell;
    }
  
    return cell;
}


#pragma mark - UITableViewDataDelegate protocol methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    LanguageDS *languageDS = loggedInUser.selectedLanguageDS;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontCondensedRegular:24], NSFontAttributeName, nil]];
    
    
    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
//    [customButton setTitle:@"En" forState:UIControlStateNormal];
    NSString *languageLocale = [languageDS.lang capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateNormal];
    
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];

    [customButton.titleLabel setFont:[UIFont TrotoiseFontLight:18]];
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
-(void)languagePopUpViewDidOkButonTappedWithLanguage:(LanguageDS *)languageObject{
    [_klcPopLanguageView dismiss:YES];
    [Utilities addHUDForView:self.view];
    LanguageDS *la = [APP_DELEGATE getLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
    if([languageObject.transCode isEqualToString:@"hi"]){
        
        CLLocationCoordinate2D coordinate = [APP_DELEGATE getCurrentLocationCoordinate ];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude ];
        NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude ];
        
        
        [[TTAPIHandler sharedWorker] getMonumentListByRange:lat withLongitude:longitude withrad:@"30"withLanguageLocale:@"hi" withRequestType:
         GET_MONUMENT_LIST_BY_RANGE responseHandler:^(NSArray *cityMonumentArra, NSError *error) {
             
             [APP_DELEGATE setCityMonumentListArray:cityMonumentArra];
             [cityMonumentArra enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 MonumentListDS *objMonument = (MonumentListDS *)obj;
                 if ([objMonument.monumentID integerValue] == [self.monumentDetailObj.monumentID integerValue]) {
                     self.monumentDetailObj = objMonument;
                     *stop = YES;
                     return ;
                 }
                 
             }];
             
             APP_DELEGATE.isLanguageChange = YES;
             [self.tableView reloadData];

             [Utilities hideHUDForView:self.view];
              [self setGlobeLanguage];
         }];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
        
        [[TranslatorManager sharedInstance] translateLanguage:[APP_DELEGATE getMonumentListArray] withSource:la.transCode withTarget:languageObject.transCode];
        
    }
    
    
}
-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(LanguageDS *)languageObject{
    
    [_klcPopLanguageView dismiss:YES];
}
-(void)onTranslationComplete:(NSNotification *)notification{
    
    NSArray *aarr = (NSArray *)[notification object];
    [APP_DELEGATE setCityMonumentListArray:aarr];
    
    [aarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MonumentListDS *objMonument = (MonumentListDS *)obj;
        if ([objMonument.monumentID integerValue] == [self.monumentDetailObj.monumentID integerValue]) {
            self.monumentDetailObj = objMonument;
            *stop = YES;
            return ;
        }
        
    }];
    [self.tableView reloadData];
    [self setGlobeLanguage];
                 APP_DELEGATE.isLanguageChange = YES;
    [Utilities hideHUDForView:self.view];
 
   
}


-(void)setGlobeLanguage{
    
    
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    LanguageDS *languageDS = loggedInUser.selectedLanguageDS;
    NSString *languageLocale = [languageDS.lang capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateNormal];
    
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];
    
}

@end
