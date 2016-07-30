        //
//  OfflineLanguagePopUpView.m
//  Tortoise
//
//  Created by Namit Nayak on 4/21/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "OfflineLanguagePopUpView.h"


#import <GoogleMaps.h>
#import "TTAPIHandler.h"
#import "LanguagePopUpView.h"
#import "Language+CoreDataProperties.h"
#import "Nuance+CoreDataProperties.h"
#import "Provider+CoreDataProperties.h"
#import "LoggedInUserDS.h"
#import "LanguageDataManager.h"
#import "TextToSpeech.h"
#import "OfflineImageOperations.h"
#import "TranslatorManager.h"
@interface OfflineLanguagePopUpView()<UITableViewDataSource,TextToSpeechDelegate
,GMSAutocompleteFetcherDelegate,UISearchBarDelegate,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIView *languageTapView;
@property (nonatomic,weak) IBOutlet UIImageView *speakerImageView1;
@property (nonatomic,weak) IBOutlet UILabel *languageLabel;
@property (nonatomic,weak) IBOutlet UIButton *okBtn;
@property (nonatomic,weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic,weak) IBOutlet UIImageView *textImageView;
@property (nonatomic,weak) IBOutlet UIImageView *audioImageView;
@property (nonatomic,strong)GMSAutocompleteFetcher* fetcher;
@property (nonatomic) BOOL isSearchOptionStart;
@property (nonatomic,strong) NSArray *dataArra;
@property (nonatomic,strong) NSArray *dataArra1;

@property (nonatomic,strong) Language *selectedLanguageDS;
@property (nonatomic,strong) TextToSpeech *textSpeech;
@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;

-(IBAction)micButtonTapped:(id)sender;
-(IBAction)okButtonTapped:(id)sender;
-(IBAction)cancelButtonTapped:(id)sender;
@end


@implementation OfflineLanguagePopUpView



-(IBAction)micButtonTapped:(id)sender{
    
    
    
        _textSpeech = [[TextToSpeech alloc] init]; // [[TextToSpeech sharedInstance] recognizeForLanguage:nuanceDS.code6];
        _textSpeech.delegate = self;
        [_textSpeech recognizeForLanguage:@ "eng-AUS"];
        
//        [self makeToast:@"Speak here for search term"
//                    duration:2.0
//                    position:CSToastPositionCenter
//                       title:@"Trotoise"
//                       image:[UIImage imageNamed:@"Siri_icon.png"]
//                       style:nil
//                  completion:^(BOOL didTap) {
//                      if (didTap) {
//                          NSLog(@"completion from tap");
//                      } else {
//                          NSLog(@"completion without tap");
//                      }
//                  }];
//        
    
    
}

#pragma mark -
#pragma TextToSpeechDelegate
-(void)textToSpeechConversionText:(NSString *)string{
    
    _searchBar.text = string;
    
    [_searchBar becomeFirstResponder];
    [_fetcher sourceTextHasChanged:string];
    
}

-(BOOL)isCheckMaxLanguageDownloadLimit {
    
    OfflineImageOperations *op  = [OfflineImageOperations sharedManager];
    NSArray *langArr =   [op getOfflineLanguageSupportListForCityName:_searchBar.text];
    
    if (langArr.count ==5 || langArr.count >5) {
        return true;
    }
    return false;
}
-(BOOL)checkForLanguageAlreadyDownloadForCity :(NSString *)cityName {
  __block  BOOL _isdownloaded = NO;
    OfflineImageOperations *op  = [OfflineImageOperations sharedManager];
 NSArray *langArr =   [op getOfflineLanguageSupportListForCityName:cityName];
    
    [langArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        Language * langObj = (Language *)obj;
        if ([langObj.id integerValue] == [_selectedLanguageDS.id integerValue ]) {
            _isdownloaded = YES;
            *stop = YES;
        }
        
    }];
    
    
    return _isdownloaded;
    
}


-(void)offlineLangData :(NSNotification *)notification {

    
    OfflineImageOperations *op  = [OfflineImageOperations sharedManager];
    
    if (_selectedLanguageDS.nuanceRelationship.count!=0) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyForImageDownload:) name:OFFLINE_DOWNLOAD_MP3_NOTIFY object:nil];
        Nuance *naunce = [[_selectedLanguageDS.nuanceRelationship allObjects] objectAtIndex:0];
        
        [op voicePathForCity:_searchBar.text withLanguageCode4:naunce.code4];
        
    }else {
        [MBProgressHUD hideHUDForView:self animated:YES];

        if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidCancelButonTappedWithLanguage:)]) {
            [self.delegate languagePopUpViewDidCancelButonTappedWithLanguage:_selectedLanguageDS];
        }

    }
    
    
    
}

-(void)notifyForImageDownload:(NSNotification *)notify {
    [MBProgressHUD hideHUDForView:self animated:YES];

    if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidCancelButonTappedWithLanguage:)]) {
        [self.delegate languagePopUpViewDidCancelButonTappedWithLanguage:_selectedLanguageDS];
    }

}
-(void)initiateTranslationRequestForCity {

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlineLangData:) name:@"OFFLINE_DATA_LANG" object:nil];
  __block  MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [hud.label setFont:[UIFont TrotoiseFontLightRegular:12.0]];
    hud.label.numberOfLines = 3;
    [[TranslatorManager sharedInstance] translateOfflineMonumentwithTarget:_selectedLanguageDS.transCode withCityName:_searchBar.text withLanguageID:_selectedLanguageDS.id withLoaderHandler:^(NSString *text) {
        
        hud.label.text = text;
        
    }];
}


-(IBAction)okButtonTapped:(id)sender{
    //     [Utilities addHUDForView:se];
    
    if ([self checkForLanguageAlreadyDownloadForCity:_searchBar.text]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TROTOISE" message:@"Translation for this language is already done. Please choose different language for translation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        
        return;
    }
    
    if ([self isCheckMaxLanguageDownloadLimit ]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You have reached the maximum city language translations." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        
        return;
    }
    
    self.tableView.hidden = YES;
    self.isSearchOptionStart = NO;
   
   
    
    if (![APP_DELEGATE isNetworkAvailable]) {
        
        return;
    }
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    
    [hud.label setFont:[UIFont TrotoiseFontLightRegular:12.0]];
    hud.label.numberOfLines = 3;
    
//    [Utilities addHUDForView:self];
    OfflineImageOperations *op  = [OfflineImageOperations sharedManager];
    if ([op checkCityWithCityNameExist:_searchBar.text]) {
        
        
        
        if ([_selectedLanguageDS.id integerValue] != LANGUAGE_DEFAULT_ID) {
            [hud hideAnimated:YES];
            [self initiateTranslationRequestForCity];
            
            
            return;
        }
        else if([_selectedLanguageDS.localeCode isEqualToString:@"en"]){
            [hud hideAnimated:YES];
            [op updateEnglishLanguageParameterInCityWithCityName:_searchBar.text];
            [self cancelButtonTapped:nil];
            return;
            
        }
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trotoise" message:@"Above city is already downloaded. To enable it in to multiple languages, please click on Edit button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [Utilities hideHUDForView: self];
        _searchBar.text = @"";
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationComplete:) name:@"OperationComplete" object:nil];
    [[TTAPIHandler sharedWorker] getMonumentListByCityName:_searchBar.text withLanguageLocale:@"en" withRequestType:GET_MONUMENT_LIST_BY_CITY_NAME withLanguageID:_selectedLanguageDS.id withResponseHandler:^(BOOL isResultSuccess,NSInteger monumentCount, NSArray *imageURls, NSError *error) {
        NSLog(@"Service Response Namit");
        if (!isResultSuccess) {
            [Utilities hideHUDForView:self];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trotoise" message:@"Sorry! No monuments found in this city to make offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
            
            
        }else{
            
            
            
           
            hud.label.text =  [NSString stringWithFormat:@"Downloading %ld monuments.\nAssets downloaded: %@/ %lu",monumentCount,[NSString stringWithFormat:@"%d",0],(unsigned long)imageURls.count];
                if (imageURls!=nil && imageURls.count>0) {
                    OfflineImageOperations *op =  [OfflineImageOperations sharedManager];
                    
                    
                    [op hudUpdateTextWithResponseHandler:^(NSString *text) {
                    
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            // Do something...
                            dispatch_async(dispatch_get_main_queue(), ^{
// hud.label.text = [NSString stringWithFormat:@"Downloading monuments...\nTotal Download: %@/ %lu",text,(unsigned long)imageURls.count];
                            });
                        });
                       
                        NSLog(@"Count %@",text);
                    }];
                    
                    BOOL isMp3Download = NO;
                    if ([_selectedLanguageDS.id integerValue] == LANGUAGE_DEFAULT_ID) {
                        isMp3Download = YES;
                    }
                 [op downloadImageURLForNSArray:imageURls withMonumentCount:monumentCount withHUD:hud withCityName:_searchBar.text withmp3download:isMp3Download withLoaderHandler:^(NSString *text) {
                        NSLog(@"Namit %@",text);
                        [hud hideAnimated:YES];
                     if([_selectedLanguageDS.localeCode isEqualToString:@"en"]){

                     [op updateEnglishLanguageParameterInCityWithCityName:_searchBar.text];
                     }
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"OperationComplete" object:text];
                        
                    }];
                    
                }
            
        }
    }];
}

-(IBAction)cancelButtonTapped:(id)sender{
    if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidCancelButonTappedWithLanguage:)]) {
        [self.delegate languagePopUpViewDidCancelButonTappedWithLanguage:_selectedLanguageDS];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 // Drawing code
 }
 */
-(void)setUpLanguagePopUpView{
    
    self.dataArra = [[LanguageDataManager sharedManager] getLanguageArrayFromDB];
    [self.tableView  reloadData];
    self.tableView.hidden = YES;
    
    for (id object in [[[_searchBar subviews] objectAtIndex:0] subviews])
    {
        if ([object isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageViewObject = (UIImageView *)object;
            [imageViewObject removeFromSuperview];
            break;
        }
    }
    [self setUpAutoCompleteFetcher];
    
    [self setUpLanguageView];
    _searchBar.text = @"";
    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.cornerRadius =  4;

}

-(void)setUpLanguageView{
    
    
    [self updateLanguageDetailsOnScreen:[[LanguageDataManager sharedManager] getDefaultOfflineLanguageObject]];
    
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onTapGestureEventFired:)] ;
    [recognizer setNumberOfTapsRequired:01];
    
    [self.languageTapView addGestureRecognizer:recognizer];
    
    
}
-(void)onTapGestureEventFired:(UIGestureRecognizer *)recognizer{
    
    
    OfflineImageOperations *op  = [OfflineImageOperations sharedManager];
    NSArray *langArr =   [op getOfflineLanguageSupportListForCityName:_searchBar.text];
    
//    if (langArr.count < 1) {
//        return;
//    }
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _isSearchOptionStart = NO;
        [self.tableView reloadData];
        
        self.tableView.hidden = NO;
    } completion:nil];
}
-(void)updateLanguageDetailsOnScreen:(Language *)languageDS{
    
    self.textImageView.image = [UIImage imageNamed:@"checkbox"];
    
    if(languageDS.nuanceRelationship !=nil && languageDS.nuanceRelationship.allObjects.count >0){
        Nuance *nDS = [[languageDS.nuanceRelationship allObjects] objectAtIndex:0];
        self.speakerImageView1.hidden = NO;
        self.languageLabel.text = nDS.lang;
        self.audioImageView.image = [UIImage imageNamed:@"checkbox"];
    }else{
        self.speakerImageView1.hidden = YES;
        self.languageLabel.text = languageDS.name;
        self.audioImageView.image = [UIImage imageNamed:@"uncheck"];
    }
    _selectedLanguageDS = languageDS;
    
    //    [APP_DELEGATE setSelectedLanguageData:languageDS];
    
    
    
}
-(void)initScreen {
    _searchBar.text =@"";
    _isSearchOptionStart = NO;
    [_searchBar setUserInteractionEnabled:YES];
    _selectedLanguageDS = [[LanguageDataManager sharedManager] getDefaultOfflineLanguageObject];
    [self updateLanguageDetailsOnScreen:_selectedLanguageDS];
}
-(void)setSearchBarValue :(NSString *)searchBarVal{
    
    _searchBar.text = searchBarVal;
    [_searchBar setUserInteractionEnabled:NO];
}
#pragma mark -
#pragma TableView
#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (!_isSearchOptionStart)?_dataArra.count:_dataArra1.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"OfflineLanguagePopupViewCell";
    
    
    OfflineLanguagePopupViewCell *cell = (OfflineLanguagePopupViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"OfflineLanguagePopUp" owner:self options:nil];
        cell = (OfflineLanguagePopupViewCell *)[arr objectAtIndex:1];
        cell.speakerImageView.hidden = YES;

    }
    if (!_isSearchOptionStart) {
        Language * dataStructer;
        
        dataStructer = [_dataArra objectAtIndex:indexPath.row];
        if (dataStructer.nuanceRelationship.allObjects.count > 0) {
            NSLog(@"%@",dataStructer.name);
            
            
            Nuance *nuanceDS = [[dataStructer.nuanceRelationship allObjects] objectAtIndex:0];
            cell.labelLanguage.text = nuanceDS.lang;
            cell.speakerImageView.hidden = NO;
        }else{
            cell.labelLanguage.text = dataStructer.name;
            cell.speakerImageView.hidden = YES;
        }
    }else{
        cell.speakerImageView.hidden = YES;

        GMSAutocompletePrediction *prediction = [_dataArra1 objectAtIndex:indexPath.row];
        cell.labelLanguage.attributedText =prediction.attributedPrimaryText;
    }
    
    
    
    
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isSearchOptionStart) {
        [_searchBar resignFirstResponder];
        GMSAutocompletePrediction *prediction = [_dataArra1 objectAtIndex:indexPath.row];

        [self initiateRequestForSelectedCityPrediction:prediction];
        
       
        
    }else{
        _selectedLanguageDS = [_dataArra objectAtIndex:indexPath.row];
        //    self.languageLabel.text = dataObject.name;
        [self updateLanguageDetailsOnScreen:_selectedLanguageDS];
        [UIView animateWithDuration:1.0 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.tableView.hidden = YES;
        } completion:nil];
        
    }
    
}

-(void)initiateRequestForSelectedCityPrediction:( GMSAutocompletePrediction *)prediction {
//    [[GMSPlacesClient sharedClient] lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
//        NSLog(@"Primary Attribute %@",prediction.attributedPrimaryText);
//        if (error!=nil) {
//            //            [Utilities hideHUDForView:weakSelf.view];
//        }else{
//            
//            if (result !=nil) {
//               
//                NSLog(@"lat : %f long : %f",result.coordinate.latitude,result.coordinate.longitude);
//                
//               [[GMSGeocoder geocoder] reverseGeocodeCoordinate:result.coordinate completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
//                   
//                   for (GMSAddress *addressObj in [response results]) {
//                       NSLog(@"locality %@",addressObj.locality);
//                       _searchBar.text = addressObj.locality;
//                       _tableView.hidden = YES;
//                       break;
//                   }
//                   
//               } ];
//                
//                
//            }
//        }
    
    
    
    
    
    
    
//    }];
    _searchBar.text = [prediction.attributedPrimaryText string];
_tableView.hidden = YES;
}

-(void)operationComplete:(NSNotification *)notification{
    
    if ([_selectedLanguageDS.id integerValue] != LANGUAGE_DEFAULT_ID && [_selectedLanguageDS.id integerValue] != 45) {
        [self initiateTranslationRequestForCity];
        
        return;
    }
    
    if ([_selectedLanguageDS.id integerValue] == 45) {
        [[TTAPIHandler sharedWorker] getMonumentListByCityName:_searchBar.text withLanguageLocale:@"hi" withRequestType:GET_MONUMENT_LIST_BY_CITY_NAME withLanguageID:_selectedLanguageDS.id  withResponseHandler:^(BOOL isResultSuccess,NSInteger monumentCount, NSArray *imageURls, NSError *error) {
            
            [ self offlineLangData:nil];
        }];
        
    }else{
        self.tableView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(languagePopUpViewOperationCompleteForCity:)]) {
            [Utilities hideHUDForView:self];
            
            [self.delegate languagePopUpViewOperationCompleteForCity:[notification object]];
            
        }
    }
    
    
}


#pragma mark -
#pragma mark UISEARCH BAR IMPLEMENTATION
-(void)setUpAutoCompleteFetcher{
    
    // Set bounds to inner-west Sydney Australia.
   //NEED TO SET CURRENT LOCATION
//    CLLocationCoordinate2D neBoundsCorner ;
    // CLLocationCoordinate2DMake(-33.843366, 151.134002);
    CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(-33.875725, 151.200349);

    CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(-33.875725, 151.200349);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                       coordinate:swBoundsCorner];
    
    // Set up the autocomplete filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterGeocode;
    
    // Create the fetcher.
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:bounds
                                                       filter:filter];
    _fetcher.delegate = self;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar                     // called when text starts editing
{
   
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                      // called when text ends editing
{
    
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = [APP_DELEGATE getCurrentLocationAddress];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [_fetcher sourceTextHasChanged:searchBar.text];
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    [_fetcher sourceTextHasChanged:searchText];
}
-(void)animateTextField:(UISearchBar*)textField up:(BOOL)up
{
//    const int movementDistance = -190; // tweak as needed
//    const float movementDuration = 0.0f; // tweak as needed
//    
//    int movement = (up ? movementDistance : -movementDistance);
//    
//    [UIView beginAnimations: @"animateTextField" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
}
#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    NSMutableString *resultsStr = [NSMutableString string];
    for (GMSAutocompletePrediction *prediction in predictions) {
        [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
    }
    
    if (predictions.count>0) {
        _isSearchOptionStart = YES;
        
        self.dataArra1 = [NSMutableArray arrayWithArray:predictions];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
//        [_klcPopAutoCompleteView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
        
//        [self.autoCompleteView setUpData:predictions];
    }else{
        
//        [_klcPopAutoCompleteView dismiss:YES];
    }
    
    
    NSLog(@"%@", resultsStr);
}

-(void)onAutoCompleteResultSelect:(GMSAutocompletePrediction *)prediction{
    [_searchBar resignFirstResponder];
    
//    [_klcPopAutoCompleteView dismiss:YES];
    
    
//    __weak HomeViewController *weakSelf = self;
    [[GMSPlacesClient sharedClient] lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
//        [Utilities addHUDSearchMonumentForView:weakSelf.view];
        if (error!=nil) {
//            [Utilities hideHUDForView:weakSelf.view];
        }else{
            
            if (result !=nil) {
                NSLog(@"Place name %@", result.name);
                NSLog(@"Place address %@", result.formattedAddress);
                NSLog(@"Place attributions %@", result.attributions.string);
                _searchBar.text = result.formattedAddress;
                [APP_DELEGATE setCurrentLocationAddress:result.formattedAddress];
                NSLog(@"lat : %f long : %f",result.coordinate.latitude,result.coordinate.longitude);
                
                //    CLLocation* location;// = place.coordinate;
//                weakSelf.homeViewLocation = [[CLLocation alloc] initWithLatitude:result.coordinate.latitude longitude:result.coordinate.longitude];
                
//                [weakSelf callMonumentAPIForLocation];
//                isUseExtra = NO;
                
            }
        }
        
        
    }];
    
}


- (void)didFailAutocompleteWithError:(NSError *)error {
    //    _resultText.text = [NSString stringWithFormat:@"%@", error.localizedDescription];
}

@end

@implementation OfflineLanguagePopupViewCell



@end