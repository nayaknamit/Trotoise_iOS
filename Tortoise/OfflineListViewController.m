//
//  OfflineListViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "OfflineListViewController.h"
#import "HomeViewTableViewCell.h"
#import "MonumentList+CoreDataProperties.h"
#import "MonumentDetail1ViewController.h"
#import "Language+CoreDataProperties.h"
#import "MonumentDataManager.h"
#import "LanguageDataManager.h"
#import "OfflineImageOperations.h"
#import "KLCPopup.h"
#import "LanguagePopUpView.h"
#import "MonumentLanguageDetail+CoreDataProperties.h"
#import <FCFileManager/FCFileManager.h>
@interface OfflineListViewController ()<LanguagePopUpViewDelegate>{
    UIButton* customButton;

}

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) __block NSArray *dataArra;
@property (nonatomic,strong) LanguagePopUpView *languagePopView;
@property (nonatomic,strong) KLCPopup *klcPopLanguageView;
@end

@implementation OfflineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
    OfflineImageOperations *op = [[OfflineImageOperations alloc] init];

      _selectedLanguageFromGlobe  = (Language *)[[op getOfflineLanguageSupportListForCityName:_cityName] objectAtIndex:0];
    [self setUpNavigationBar];
    [self setUpLanguagePopUp];
    // Do any additional setup after loading the view.
}


-(void)setUpLanguagePopUp{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguagePopUp" owner:self options:nil];
    
    self.languagePopView = (LanguagePopUpView *)[arr objectAtIndex:0];
    self.languagePopView.frame = CGRectMake(self.languagePopView.frame.origin.x, self.languagePopView.frame.origin.y, 303.0f, 340.0f);
    self.languagePopView.delegate = self;
    [self.languagePopView setUpLanguageOfflinePopUpViewCity:_cityName];
    _klcPopLanguageView = [KLCPopup popupWithContentView:self.languagePopView];
//    _selectedLanguageFromGlobe =
    
 
;
    
}

-(NSArray *)getDataArra{
    
   OfflineImageOperations *oo = [OfflineImageOperations sharedManager];
    return  [oo getMonumentListArraWithCityName:_cityName];
}

-(void)setUpData{
    if(self.dataArra !=nil){
        self.dataArra = nil;
    }
    self.dataArra = [self getDataArra];
    [self.tableView reloadData];
    
    
}
-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontOswaldRegular:22], NSFontAttributeName, nil]];
    
    
    
    Language *defaultLang =_selectedLanguageFromGlobe; //[[LanguageDataManager sharedManager] getDefaultLanguageObject];
    
    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
    //    [customButton setTitle:@"En" forState:UIControlStateNormal];
    NSString *languageLocale = [defaultLang.localeCode capitalizedString];
//    languageLocale = @"En";
    [customButton setTitle:[NSString stringWithFormat:@" %@",languageLocale] forState:UIControlStateNormal];
    [customButton setTitle:[NSString stringWithFormat:@" %@",languageLocale] forState:UIControlStateHighlighted];
    
    [customButton.titleLabel setFont:[UIFont TrotoiseFontCondensedRegular:16]];
    [customButton sizeToFit];
    //    [customButton.titleLabel sizeToFit];
    [customButton addTarget:self action:@selector(customLanguageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    //    customBarButtonItem.customView.frame = CGRectMake(customBarButtonItem.customView.frame.origin.x, customBarButtonItem.customView.frame.origin.y, 150, customBarButtonItem.customView.frame.size.height);
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    
    
    
}

-(void)customLanguageButtonTapped:(id)sender{
    // LanguageViewController *languageVC =   [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageViewController"];
    //
    //    [self.navigationController presentViewController:languageVC animated:YES completion:nil];
    
//
    [_klcPopLanguageView show];
}
-(void)setGlobeLanguage{
    
    if(_selectedLanguageFromGlobe ==nil){
        _selectedLanguageFromGlobe = [APP_DELEGATE getLanguage];
    }
    NSString *languageLocale = [_selectedLanguageFromGlobe.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@" %@",languageLocale] forState:UIControlStateNormal];
    [customButton setTitle:[NSString stringWithFormat:@" %@",languageLocale] forState:UIControlStateHighlighted];
    [customButton.titleLabel setFont:[UIFont TrotoiseFontCondensedRegular:16]];
    [customButton sizeToFit];
}

-(void)languagePopUpViewDidOkButonTappedWithLanguage:(Language *)languageObject{
    [_klcPopLanguageView dismiss:YES];
    
    [self.tableView reloadData];
    self.selectedLanguageFromGlobe = languageObject;
    [self setGlobeLanguage];
}
-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(Language *)languageObject{
    
    [_klcPopLanguageView dismiss:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArra.count;
    
}// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"hMVTableCell";
    
    
    HomeViewTableViewCell *cell = (HomeViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"HMVCell" owner:self options:nil];
        cell = (HomeViewTableViewCell *)[arr objectAtIndex:0];
    }
    
    MonumentList *duck = [_dataArra objectAtIndex:indexPath.section];
    [self updateTextOnTableViewCell:cell withMonumentList:duck];
    
    
    if ([FCFileManager existsItemAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:duck.thumbnail]]]) {
        NSString *testPathTemp = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:duck.thumbnail]]];
        UIImage *theImage = [UIImage imageWithContentsOfFile:testPathTemp];
        cell.placeImageView.image = theImage;
        
        
    }
//
//    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadImageWithURL:[NSURL URLWithString:duck.thumbnail]
//                          options:0
//                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
//     {
//         // progression tracking code
//     }
//                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//     {
//         if (image)
//         {
//             cell.placeImageView.image = image;
//             // do something with image
//         }
//     }];
    //    cell.placeImageView.image = [UIImage imageNamed:@"paris.png"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)updateTextOnTableViewCell:(HomeViewTableViewCell *)cell withMonumentList:(MonumentList *)monumentObj {
__block  NSString *name;
   __block NSString *desc;
    
    if ([_selectedLanguageFromGlobe.id integerValue]== LANGUAGE_DEFAULT_ID) {
        name = monumentObj.name;
        desc = monumentObj.desc;
        
        
    }else {
        
        NSArray *monDesArr = [monumentObj.multiLocaleMonument array];
        
    [monDesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MonumentLanguageDetail *objM = (MonumentLanguageDetail *)obj;
        if ([objM.locale isEqualToString:_selectedLanguageFromGlobe.transCode]) {
            name  = objM.name;
            desc = objM.desc;
            *stop = YES;

        }
        
    }];
        
    }
    cell.placeTitleLbl.text = name;
    cell.descriptionLbl.text =desc;
    

    
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MonumentDetail1ViewController *monumentDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MonumentDetail1ViewController"];
    // NSInteger row = indexPath.section;
    monumentDetailVC.monumentDetailObj = (MonumentList *)[_dataArra objectAtIndex:indexPath.section];
//    monumentDetailVC.selectedLanguageFromGlobe = _selectedLanguageFromGlobe;
    monumentDetailVC.isOfflineModeOn = YES;
    monumentDetailVC.selectedOfflineLanguageFromGlobe = _selectedLanguageFromGlobe;
    monumentDetailVC.cityName = _cityName;
    //    monumentDetailVC.homeViewLocation = _homeViewLocation;
    [self.navigationController pushViewController:monumentDetailVC animated:YES];
    
}


-(IBAction)closeBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
