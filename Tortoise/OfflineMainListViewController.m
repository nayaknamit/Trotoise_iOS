//
//  OfflineMainListViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "OfflineMainListViewController.h"
#import "OfflineMainListTableViewCell.h"
#import "MonumentList+CoreDataProperties.h"
#import "MonumentDetail1ViewController.h"
#import "Language+CoreDataProperties.h"
#import "MonumentDataManager.h"
#import "LanguageDataManager.h"
#import "KLCPopup.h"
#import "OfflineLanguagePopUpView.h"
#import "ImageAttribute+CoreDataProperties.h"
#import "OfflineListViewController.h"
#import "OfflineImageOperations.h"
#import "CityMonument+CoreDataProperties.h"
#import <FCFileManager.h>
@interface OfflineMainListViewController ()<CustomCellDeleteMethod>
@property (nonatomic,strong) KLCPopup *klcPopLanguageView;
@property (nonatomic,strong) OfflineLanguagePopUpView *offlineLanguagePopView;
@property (nonatomic,strong) NSString *cityForoperationDone;
-(IBAction)closeBtnTapped:(id)sender;
@end

@implementation OfflineMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self setUpData];
    [self setUpBigView];
    if ([_checkScreenFrom isEqualToString:@"SplashScreen"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    // Do any additional setup after loading the view.
}
-(IBAction)addBtnTapped:(id)sender{
   
    
    
    [self.offlineLanguagePopView initScreen];
    [_klcPopLanguageView show];
    
    
}
-(IBAction)closeBtnTapped:(id)sender{
    if ([_checkScreenFrom isEqualToString:@"SplashScreen"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
    
    }
}

-(BOOL)checkForLanguageAlreadyDownloadForCity :(NSString *)cityName {
    __block  BOOL _isdownloaded = NO;
    OfflineImageOperations *op  = [OfflineImageOperations sharedManager];
    NSArray *langArr =   [op getOfflineLanguageSupportListForCityName:cityName];
    


    if (langArr.count == 5 || langArr.count >5) {
        return true;
    }
    return _isdownloaded;
    
}

-(void)setUpBigView{
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"OfflineLanguagePopUp" owner:self options:nil];
    
    self.offlineLanguagePopView = (OfflineLanguagePopUpView *)[arr objectAtIndex:0];
    self.offlineLanguagePopView.frame = CGRectMake(self.offlineLanguagePopView.frame.origin.x, self.offlineLanguagePopView.frame.origin.y, 303.0f, 340.0f);
    self.offlineLanguagePopView.delegate = self;
    [self.offlineLanguagePopView setUpLanguagePopUpView];
    _klcPopLanguageView = [KLCPopup popupWithContentView:self.self.offlineLanguagePopView];
    _klcPopLanguageView.shouldDismissOnBackgroundTouch = NO;
    [self.offlineLanguagePopView setUpLanguagePopUpView ];
}
-(void)languagePopUpViewOperationCompleteForCity:(NSString *)cityName{
    [_klcPopLanguageView dismiss:YES];
    _cityForoperationDone = [cityName copy];
    [self setUpData];
}
-(NSArray *)getDataArra{
    
    
    OfflineImageOperations *ofImOp = [OfflineImageOperations sharedManager];

   return [ofImOp getCityListArra];
    
}

-(void)setUpData{
    if(self.dataArra !=nil){
        self.dataArra = nil;
    }
    
    self.dataArra = [NSMutableArray arrayWithArray:[self getDataArra]];
    [self setCopyViewVisibility];
    [self addButtonVisibleCheck];
    [self.tableView reloadData];
       
}
-(void)addButtonVisibleCheck{
    if (self.dataArra.count==5 || self.dataArra.count >5) {
        self.addBtn.enabled = false;
        self.addBtn.alpha = 0.8;
      
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have reached the maximum offline city limit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
             }else {
        
        self.addBtn.enabled = true;
        self.addBtn.alpha = 1.0;
    }
    
    
}
-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontOswaldRegular:22], NSFontAttributeName, nil]];
    
    
    
    
    
}
#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArra.count;
    
}// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"offlineMainListCell";
    
    
    OfflineMainListTableViewCell *cell = (OfflineMainListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"OfflineMainListTableViewCell" owner:self options:nil];
        cell = (OfflineMainListTableViewCell *)[arr objectAtIndex:0];
    }
    CityMonument *duck = [_dataArra objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = duck.name;
    cell.monumentCountLbl.text =[NSString stringWithFormat:@"%ld monuments available",duck.citymonumentrelationship.count];
    
//    cell.placeTitleLbl.text = duck.name;
//    cell.descriptionLbl.text =duck.desc;
//    //@"Greater Paris (the city plus surrounding departments) received 22,4 million visitors in 2014, making it one of the world's top tourist destinations. The largest numbers of foreign tourists in 2014 came from the United States (2.74 million), the U.K., Germany, Italy, Japan, Spain and China (532,000). "; //duck.shortDesc;
//    
//
    MonumentList *monumentListOb = [[duck.citymonumentrelationship allObjects] objectAtIndex:0];
    
    if ([FCFileManager existsItemAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:monumentListOb.thumbnail]]]) {
       NSString *testPathTemp = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:monumentListOb.thumbnail]]];
        UIImage *theImage = [UIImage imageWithContentsOfFile:testPathTemp];
        cell.smallMonumentImageView.image = theImage;

        
    }
    
    ImageAttribute *img = (ImageAttribute *)[monumentListOb.imageAttributes objectAtIndex:0];
    
    if ([FCFileManager existsItemAtPath:[NSString stringWithFormat:@"/OfflineData/img_attr_%@",[Utilities getFileNameFromURL:img.imageUrl]]]) {
        NSString *testPathTemp = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"/OfflineData/img_attr_%@",[Utilities getFileNameFromURL:img.imageUrl]]];
        UIImage *theImage = [UIImage imageWithContentsOfFile:testPathTemp];
        cell.mainImageView.image = theImage;
        
        
    }
    
    OfflineImageOperations *op = [OfflineImageOperations sharedManager];

    
   
    cell.languageLbl.text = [NSString stringWithFormat:@"[%@]",[op getCityLocaleArrayForCityName:duck.name]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.customDelegate = self;
    return cell;
}
-(void)editButtonTappedForCell:(UITableViewCell *)cell {
   
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CityMonument *duck = [_dataArra objectAtIndex:indexPath.section];
   
    
    [self.offlineLanguagePopView setSearchBarValue:duck.name];
    [_klcPopLanguageView show];
    
}
-(void)deleteButtonTappedForCell:(UITableViewCell *)cell{
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CityMonument *duck = [_dataArra objectAtIndex:indexPath.section];
    
    OfflineImageOperations *op =   [OfflineImageOperations sharedManager];
    if ([op deleteCityList:duck.id]) {
        [self.tableView beginUpdates];
        [_dataArra removeObjectAtIndex:indexPath.section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates] ;
        [self addButtonVisibleCheck];
        [self setCopyViewVisibility];
        [self.tableView reloadData];
    }
    
    
}

-(void)setCopyViewVisibility{
    
    if (_dataArra.count==0 || _dataArra==nil ) {
        self.noMonumentTextView.hidden = NO;
        self.tableContainerView.hidden = YES;
    }else{
        self.noMonumentTextView.hidden = YES;
        self.tableContainerView.hidden = NO;
    }
}



-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(Language *)languageObject{
    [self.tableView reloadData];
    [self setUpData];
    [_klcPopLanguageView dismiss:YES];
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 295.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    OfflineListViewController *ofcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineListViewController"];
    CityMonument *duck = [_dataArra objectAtIndex:indexPath.section];

    ofcVC.cityName = duck.name;
    
    [self.navigationController pushViewController:ofcVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
