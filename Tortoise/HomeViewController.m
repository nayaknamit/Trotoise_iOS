//
//  ViewController.m
//  Tortoise
//

#import "HomeViewController.h"
//#import "GoogleMaps.h"
#import "HomeViewTableViewCell.h"
#import "SWRevealViewController.h"
#import <GoogleMaps.h>
#import "TTAPIHandler.h"
#import "UIView+DragDrop.h"

#import "RadiusView.h"
#import "KLCPopup.h"
#import "MonumentList+CoreDataProperties.h"
#import "MonumentDetail1ViewController.h"

#import "LoggedInUserDS.h"
#import "LanguageDS.h"
#import "LanguageViewController.h"

#import "CustomMarkerView.h"

#import "LanguagePopUpView.h"
#import "AutoCompleteView.h"
#import "TranslatorManager.h"
#import "LanguageDataManager.h"
#import "TextToSpeech.h"
#import "Nuance+CoreDataProperties.h"
#import "Provider+CoreDataProperties.h"
#import "Language+CoreDataProperties.h"
#import "MonumentDataManager.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface HomeViewController ()<CLLocationManagerDelegate,GMSMapViewDelegate, RadiusViewDelegate,GMSAutocompleteViewControllerDelegate,TextToSpeechDelegate,GMSAutocompleteFetcherDelegate,LanguagePopUpViewDelegate,UISearchBarDelegate>
{
    BOOL drawForOnce;
    NSString *radiusValue;
    GMSAutocompleteResultsViewController *_resultsViewController;
    UISearchController *_searchController;
    GMSAutocompleteTableDataSource *_tableDataSource;
    CGFloat varientHeight;
    CGRect initialFrameRect;
    UIButton* customButton;
    GMSCircle *circle;
    float zoomScale;
    BOOL isUseExtra;
}
@property (nonatomic,strong) __block NSArray *dataArra;
@property (nonatomic,strong) IBOutlet GMSMapView *mapContainerView;
@property (nonatomic,strong) IBOutlet UITableView * tableView;
@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong) KLCPopup *klcPopView;
@property (nonatomic,strong) RadiusView *radiusView;
@property (weak,nonatomic) IBOutlet UIButton *radiusButton;
@property (nonatomic,weak) IBOutlet UILabel *lblDistanceRequired;
@property (nonatomic,strong)GMSAutocompleteFetcher* fetcher;
@property (nonatomic,strong) IBOutlet UIView *searchView;
@property (nonatomic,strong) CustomMarkerView *customMarkerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *dynamicTVHeight;
@property (nonatomic,strong) IBOutlet UIView *searchContainerView;
@property (nonatomic,strong) LanguagePopUpView *languagePopView;
@property (nonatomic,strong) KLCPopup *klcPopLanguageView;
@property (nonatomic,strong) Language *selectedLanguageFromGlobe;
@property(nonatomic,strong) KLCPopup *klcPopAutoCompleteView;
@property (nonatomic,strong) AutoCompleteView *autoCompleteView;
@property (nonatomic,strong) CLLocation *homeViewLocation;
@property (nonatomic,weak) IBOutlet UIView *viewForSearchBarDown;
@property (nonatomic,strong)TextToSpeech *textSpeech;
-(IBAction)micButtonTapped:(id)sender;
-(IBAction)radiusBtnTapped:(id)sender;
-(IBAction)currentLocationBtnTapped:(id)sender;

///Dragging


@end

@implementation HomeViewController

-(IBAction)micButtonTapped:(id)sender{
   
    
    if ([self.selectedLanguageFromGlobe.nuanceRelationship allObjects].count>0) {
        Nuance *nuanceDS = [[self.selectedLanguageFromGlobe.nuanceRelationship allObjects] objectAtIndex:0];
        
        _textSpeech = [[TextToSpeech alloc] init]; // [[TextToSpeech sharedInstance] recognizeForLanguage:nuanceDS.code6];
        _textSpeech.delegate = self;
        [_textSpeech recognizeForLanguage:nuanceDS.code6];
        
        [self.view makeToast:@"Speak here for search term"
                    duration:3.0
                    position:CSToastPositionCenter
                       title:@"Trotoise"
                       image:[UIImage imageNamed:@"Siri_icon.png"]
                       style:nil
                  completion:^(BOOL didTap) {
                      if (didTap) {
                          NSLog(@"completion from tap");
                      } else {
                          NSLog(@"completion without tap");
                      }
                  }];
        
    }

}

#pragma mark -
#pragma TextToSpeechDelegate
-(void)textToSpeechConversionText:(NSString *)string{
    
    _searchBar.text = string;
    [_searchBar becomeFirstResponder];
    [_fetcher sourceTextHasChanged:string];

}



# pragma -

- (void)viewDidLoad {
    [super viewDidLoad];
    radiusValue = @"30";
    [self setUpNavigationBar];
    [self setUpDraggableView];
    [self setUpLanguagePopUp];
    [self setUpRadiusPopUp];
    [self setUpInitialData];
    [self setUpAutoCompleteFetcher];
    [self setUpViewTableView];
    zoomScale = 5.0;
    isUseExtra = NO;
    [self setAutoSearchHiddenViewState:YES];
    
    UITapGestureRecognizer *recg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoSearchTapBg:)];

    
    recg.numberOfTapsRequired = 1;
    
    [self.viewForSearchBarDown addGestureRecognizer:recg];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeNotifcationFromMenu:) name:@"SWIPE_LEFT_GESTURE" object:nil];
}
-(void)setAutoSearchHiddenViewState:(BOOL)_hidden{
    
    _viewForSearchBarDown.hidden = _hidden;

    
}
-(void)autoSearchTapBg:(UIGestureRecognizer *)recog{
    
    [_searchBar resignFirstResponder];
    _searchBar.text  = [APP_DELEGATE getCurrentLocationAddress];
    
}
-(void)startTranslationOnMonumentList{
    [self.navigationController.view makeToast:@"Translating Monuments List...."
                                     duration:5.0
                                     position:CSToastPositionCenter];
    
    [Utilities addHUDForView:self.view];
    
    if (_selectedLanguageFromGlobe ==nil) {
        _selectedLanguageFromGlobe = [APP_DELEGATE getLanguage];
    }
    
    [self initiateLanguageRequest:_selectedLanguageFromGlobe];

}

-(void)swipeNotifcationFromMenu:(id)notification{
    [self.revealViewController revealToggle:nil];
    
}
-(void)setUpInitialData{
    [self setUpMapData];

    if  ([APP_DELEGATE getUserDefaultLanguageIsChached] && _currentTranslatorRequestType ==TR_TRANSLATE_REQUEST_NONE)
        
   {
       _currentTranslatorRequestType = TR_TRANSLATE_REQUEST_SETTINGS;
       APP_DELEGATE.isLanguageChange = NO;
       [self startTranslationOnMonumentList];
   }
    
    

}
-(NSArray *)getDataArra{
    
    return [[MonumentDataManager sharedManager] getMonumentListArra];
    
}
-(void)setUpMapData{
    
    
    if(self.dataArra !=nil){
        self.dataArra = nil;
    }
    self.dataArra = [self getDataArra];
    [self.tableView reloadData];
    if (self.homeViewLocation==nil) {
        CLLocationCoordinate2D coord = [APP_DELEGATE getCurrentLocationCoordinate];
        self.homeViewLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    [self mapSetUpWithLatitude:self.homeViewLocation.coordinate.latitude withLongitude:self.homeViewLocation.coordinate.longitude];
    TRRANGETYPE range = [APP_DELEGATE getRangeType];
    if (range == TRRANGE_MILETYPE) {
        _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ mi range.",(unsigned long)_dataArra.count,radiusValue];
        
    }else {
        _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ km range.",(unsigned long)_dataArra.count,radiusValue];
        
    }
    //    _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ km range.",(unsigned long)_dataArra.count,radiusValue];
    
    _searchBar.text = [APP_DELEGATE getCurrentLocationAddress];
    

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

//    [_mapContainerView removeObserver:self forKeyPath:@"myLocation"];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [_mainView setBOOLMidHeightSet:NO];
    [self setGlobeLanguage];
//    if(APP_DELEGATE.isLanguageChange){
//        if(self.dataArra !=nil){
//            self.dataArra = nil;
//        }
//        self.dataArra = [NSMutableArray arrayWithArray:[APP_DELEGATE getMonumentListArray]];
//        [self.tableView reloadData];
//        APP_DELEGATE.isLanguageChange = NO;
//    }

}
-(void)setUpDraggableView{
//    [_mainView ]
    [_mainView makeDraggable];
    [_mainView setDelegate:(id)self];
    [_mainView setDragMode:UIViewDragDropModeRestrictY];
    [_mainView setStageTopPoint:self.mapContainerView.frame.origin];
    initialFrameRect = _mainView.frame;
    [_mainView setInitialFramePoint:_mainView.frame ];

}
-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontOswaldRegular:22], NSFontAttributeName, nil]];
    
    
    
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    Language *defaultLang = [[LanguageDataManager sharedManager] getDefaultLanguageObject];
    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateSelected];
    NSString *languageLocale = [defaultLang.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateNormal];
    
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];
    [customButton.titleLabel setFont:[UIFont TrotoiseFontCondensedRegular:16]];
    [customButton sizeToFit];
    [customButton addTarget:self action:@selector(customLanguageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    for (id object in [[[_searchBar subviews] objectAtIndex:0] subviews])
    {
        if ([object isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageViewObject = (UIImageView *)object;
            [imageViewObject removeFromSuperview];
            break;
        }
    }
    self.revealViewController.rightViewRevealOverdraw = 0.0f;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}
-(void)customLanguageButtonTapped:(id)sender{
// LanguageViewController *languageVC =   [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageViewController"];
//  
//    [self.navigationController presentViewController:languageVC animated:YES completion:nil];
    [_klcPopLanguageView show];
}
-(IBAction)radiusBtnTapped:(id)sender{
    [_klcPopView show];
}
-(IBAction)currentLocationBtnTapped:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if(btn.tag ==1002)
    {
//        [self setUpAutoComplete];
        
    }else{
        
        __weak HomeViewController *weakSelf = self;
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
            if (error != nil) {
                NSLog(@"Current Place error %@", [error localizedDescription]);
                return;
            }
            GMSPlaceLikelihood *likelihood =   [likelihoodList.likelihoods objectAtIndex:0];
            
            GMSPlace *place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
            [APP_DELEGATE setCurrentLocationAddress:place.formattedAddress];
            weakSelf.searchBar.text = place.formattedAddress;
//            CLLocation* location;// = place.coordinate;
            [APP_DELEGATE setCurrentLocationCoordinate:place.coordinate];
       weakSelf.homeViewLocation = [[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
            
            
            //Adding HUD View
            [Utilities addHUDForView:weakSelf.view];
            //NEED TO CALL WEBSERVICE
            [weakSelf callMonumentAPIForLocation];
        }];

    }

}

-(void)callMonumentAPIForLocation{
    
    NSString *lat = [NSString stringWithFormat:@"%f",self.homeViewLocation.coordinate.latitude ];
    NSString *longitude = [NSString stringWithFormat:@"%f",self.homeViewLocation.coordinate.longitude ];
    
        __weak HomeViewController *weakSelf = self;
    [[TTAPIHandler sharedWorker] getMonumentListByRange:lat  withLongitude:longitude withrad:radiusValue withLanguageLocale:@"en"  withRequestType:GET_MONUMENT_LIST_BY_RANGE responseHandler:^(BOOL isResultSuccess, NSError *error) {
        if (error!=nil) {
            
           
            [weakSelf.navigationController.view makeToast:@"Unable to load Monuments List."
                                             duration:1.0
                                             position:CSToastPositionCenter];
            weakSelf.dataArra = nil;
            [weakSelf.tableView reloadData];
            TRRANGETYPE range = [APP_DELEGATE getRangeType];
            if (range == TRRANGE_MILETYPE) {
                _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ mi range.",(unsigned long)0,radiusValue];
                
            }else {
                _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ km range.",(unsigned long)0,radiusValue];
                
            }
            
            
        }else{
            if(_dataArra){
                _dataArra = nil;
            }
            if (isResultSuccess) {
                _dataArra = [[MonumentDataManager sharedManager] getMonumentListArra];
            }
            
//            _dataArra =  [NSMutableArray arrayWithArray:cityMonumentArra];
//            APP_DELEGATE.defaultCityMonumentList = _dataArra;
            
            if (![_selectedLanguageFromGlobe.transCode isEqualToString:@"en"] && ( [APP_DELEGATE getUserDefaultLanguageIsChached] || _currentTranslatorRequestType == TR_TRANSLATE_REQUEST_HOME || _currentTranslatorRequestType == TR_TRANSLATE_REQUEST_SETTINGS )) {
                
                [Utilities hideHUDForView:weakSelf.view];

                    [weakSelf startTranslationOnMonumentList];
                return ;
            }else{
                [weakSelf.tableView reloadData];
                drawForOnce = NO;
                [weakSelf mapSetUpWithLatitude:weakSelf.homeViewLocation.coordinate.latitude withLongitude:weakSelf.homeViewLocation.coordinate.longitude];
                
                
                TRRANGETYPE range = [APP_DELEGATE getRangeType];
                if (range == TRRANGE_MILETYPE) {
                    _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ mi range.",(unsigned long)_dataArra.count,radiusValue];
                    
                }else {
                    _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ km range.",(unsigned long)_dataArra.count,radiusValue];
                    
                }
            }
            
        }
       
//        _lblDistanceRequired.text = [NSString stringWithFormat:@"%lu monuments found in %@ km range.",(unsigned long)_dataArra.count,radiusValue];
        
        [Utilities hideHUDForView:weakSelf.view];
    }];
}
-(void)setUpRadiusPopUp{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RadiusView" owner:self options:nil];

    self.radiusView = (RadiusView *)[arr objectAtIndex:0];
   
    self.radiusView.frame = CGRectMake(self.radiusView.frame.origin.x, self.radiusView.frame.origin.y, 297.0f, 163.0f);
    self.radiusView.titleLbl.text = SCAN_MONUMENT_KM;
    TRRANGETYPE rangeType = [APP_DELEGATE getRangeType];
    if (rangeType == TRRANGE_MILETYPE) {
        self.radiusView.titleLbl.text = SCAN_MONUMENT_MILE;
  
    }
    self.radiusView.delegate = self;
   _klcPopView = [KLCPopup popupWithContentView:self.radiusView];
    
}

//-(void)


-(void)drawCircleOnMap{
    
    NSInteger radiusInteger = [radiusValue integerValue];
    
    TRRANGETYPE range = [APP_DELEGATE getRangeType];
    if (range == TRRANGE_MILETYPE) {
        radiusInteger = radiusInteger *1.6;
    }
    if (circle==nil) {
        circle = [GMSCircle circleWithPosition:self.homeViewLocation.coordinate
                                        radius:1000*radiusInteger];
        
    UIColor *color =  UIColorFromRGB(0x3bb3c2);
        circle.fillColor = [color colorWithAlphaComponent:0.2];
        circle.strokeColor = UIColorFromRGB(0x3bb3c2);
        circle.strokeWidth = 0;
        
    
    }else{
        [self setCirclePosition:self.homeViewLocation.coordinate];
        [self setCircleRadius:radiusInteger];
        
    }
    circle.map = _mapContainerView;
 }
-(void)setCirclePosition:(CLLocationCoordinate2D)coordinate{
    
    if (circle!=nil) {
        
        [circle setPosition:coordinate];
    }
}
-(void)setCircleRadius:(NSInteger)radius{
    if (circle != nil) {
//        this.circle.setRadius(radius * METERS_TO_KMS * 1.05);
        TRRANGETYPE range = [APP_DELEGATE getRangeType];
        float radiusInt = [radiusValue floatValue];
        if (range == TRRANGE_MILETYPE) {
            radiusInt = radiusInt * 1.6;
        }
        [circle setRadius:(1000*radiusInt*1.05)];
                           
 
    }
}

-(void)zoomToFitGoogleMap{
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.homeViewLocation.coordinate coordinate:self.homeViewLocation.coordinate];

    [_mapContainerView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:3]];
    
}




-(void)resetMapView{
    
    [_mapContainerView clear];
    circle = NULL;
//    [_mapContainerView.clearsContextBeforeDrawing
}


-(void)mapSetUpWithLatitude:(CLLocationDegrees)_latitude withLongitude:(CLLocationDegrees)_longitude{
    @try {
        [self resetMapView];
        
        
        _mapContainerView.clearsContextBeforeDrawing = YES;
        MonumentList *obj = (MonumentList *)[_dataArra lastObject];
        double latitude = [obj.latitude doubleValue];
        double longitude = [obj.longitude doubleValue];
        
        GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:_latitude
                                                                        longitude:_longitude
                                                                             zoom:1];
        _mapContainerView.delegate = self;
        [_mapContainerView setCamera:cameraPosition];
        //  [_mapContainerView animateToLocation:]
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
        
        [_mapContainerView.settings setCompassButton:YES];
        [_mapContainerView.settings setMyLocationButton:YES];
        
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:self.homeViewLocation.coordinate coordinate:coord];
        
        
        
        for(MonumentList * obj in _dataArra){
            MonumentList *mm = (MonumentList *)obj;
            double latitude1 = [mm.latitude doubleValue];
            double longitude1 = [mm.longitude doubleValue];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(latitude1, longitude1);
            marker.userData = mm;
            //marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
            marker.map = _mapContainerView;
            marker.icon = [GMSMarker markerImageWithColor:UIColorFromRGB(0x69afe2)];
            bounds = [bounds includingCoordinate:marker.position];
            
        }
        if ([radiusValue integerValue]<100) {
            [_mapContainerView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:120]];
            [_mapContainerView animateWithCameraUpdate:[GMSCameraUpdate zoomTo:9]];
            
        }else{
            [_mapContainerView animateWithCameraUpdate:[GMSCameraUpdate zoomTo:7.5]];
            [_mapContainerView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:120]];
            
            
        }
        
        [self drawCircleOnMap];
        
        

    }
    @catch (NSException *exception) {
        
        NSLog(@"%@",[exception description]);
    }
    @finally {
        

    }
    


}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    

    _customMarkerView =  [[[NSBundle mainBundle] loadNibNamed:@"CustomMarkerView" owner:self options:nil] objectAtIndex:0];
    MonumentList *mds = (MonumentList *)marker.userData;
    _customMarkerView.titleLbl.text =mds.name;
    _customMarkerView.descLbl.text = mds.desc;
    _customMarkerView.monumentObj = mds;
    _customMarkerView.placePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mds.thumbnail]]];
    _customMarkerView.layer.cornerRadius = 16;
    _customMarkerView.delegate = self;
    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:[mds.latitude doubleValue]
                                                            longitude:[mds.longitude doubleValue]
                                                                 zoom:13];
    [_mapContainerView setCamera:sydney];

//    CLLocationCoordinate2D coord;
//    coord.latitude =[mds.latitude doubleValue];
//    coord.longitude = [mds.longitude doubleValue];
//    [_mapContainerView animateToLocation:coord];

    return _customMarkerView;
}
- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    MonumentDetail1ViewController *monumentDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MonumentDetail1ViewController"];
    // NSInteger row = indexPath.section;
    monumentDetailVC.monumentDetailObj = (MonumentList *)marker.userData;
    monumentDetailVC.selectedLanguageFromGlobe = _selectedLanguageFromGlobe;

    [self.navigationController pushViewController:monumentDetailVC animated:YES];
    
}


- (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker{
//    TRRANGE_MILETYPE
//    CLLocationCoordinate2D locationCord = [APP_DELEGATE getCurrentLocationCoordinate];
    GMSCameraPosition *sydney = [GMSCameraPosition cameraWithLatitude:self.homeViewLocation.coordinate.latitude
                                                            longitude:self.homeViewLocation.coordinate.longitude
                                                                 zoom:9.5];
    [_mapContainerView setCamera:sydney];
}
- (void)observeValueForKeyPath:(NSString *)keyPath

                      ofObject:(id)object

                        change:(NSDictionary *)change

                       context:(void *)context {

    NSLog(@"Change in Dic %@",[change description]);
    
}








- (BOOL) viewShouldReturnToStartingPosition:(UIView*)view
{
    
    return NO;
}

-(void)sendUpdatedHeightForTableView:(CGFloat)height withPointDirection:(POINTMOVEDIRECTION)direction{
    //
    if(direction == INITAL_POINT_DIRECTION){
        self.dynamicTVHeight.constant = 0;
        _mainView.frame = CGRectMake(initialFrameRect.origin.x,[UIScreen mainScreen].bounds.size.height-self.searchContainerView.frame.size.height-12, initialFrameRect.size.width, initialFrameRect.size.height);
        
    }else{
        self.dynamicTVHeight.constant = height-self.searchContainerView.frame.size.height-12;

    }
    
    //    self.dynamicTVHeight.multiplier = [NSNumber num]0.5;
    [self.tableView updateConstraintsIfNeeded];
    
    
}

-(void)sendUpdatedHeightForTableView:(CGFloat)height{
    

    
//    [self.tableView setNeedsDisplay];
    
}


- (void) draggingDidBeginForView:(UIView*)view
{
    
}

- (void) draggingDidEndWithoutDropForView:(UIView*)view
{
   
}

- (void) view:(UIView *)view didHoverOverDropView:(UIView *)dropView
{
   
    
}

- (void) view:(UIView *)view didUnhoverOverDropView:(UIView *)dropView
{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;                                               // any offset changes
//{
//    
//    
//}

#pragma mark - CLLOCATION MANAGER INITIALIATION 


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
    
    cell.placeTitleLbl.text = duck.name;
    cell.descriptionLbl.text =duck.desc;
    //@"Greater Paris (the city plus surrounding departments) received 22,4 million visitors in 2014, making it one of the world's top tourist destinations. The largest numbers of foreign tourists in 2014 came from the United States (2.74 million), the U.K., Germany, Italy, Japan, Spain and China (532,000). "; //duck.shortDesc;
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:duck.thumbnail]
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image)
         {
             cell.placeImageView.image = image;
             // do something with image
         }
     }];
//    cell.placeImageView.image = [UIImage imageNamed:@"paris.png"];
[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   MonumentDetail1ViewController *monumentDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MonumentDetail1ViewController"];
   // NSInteger row = indexPath.section;
    monumentDetailVC.monumentDetailObj = (MonumentList *)[_dataArra objectAtIndex:indexPath.section];
    monumentDetailVC.selectedLanguageFromGlobe = _selectedLanguageFromGlobe;
    [self.navigationController pushViewController:monumentDetailVC animated:YES];
    
}



#pragma mark -
#pragma mark RadiusView Delegate Method
-(void)radiusViewDidOkButonTappedWithSliderValue:(CGFloat)sliderValue{
    NSLog(@"Radius View Ok Button Pressed slider Value %0.f",sliderValue);
    radiusValue = [NSString stringWithFormat:@"%0.f",sliderValue];

//    CLLocationCoordinate2D coordinate = [APP_DELEGATE getCurrentLocationCoordinate];
//    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    
    //NEED TO CALL WEBSERVICE
    
    //ADDING HUD
    [Utilities addHUDForView:self.view];
    
    [self callMonumentAPIForLocation];
    
    
    [_klcPopView dismiss:YES];

    
}
-(void)radiusViewDidCancelButonTappedWithSliderValue:(CGFloat)sliderValue{
    [_klcPopView dismiss:YES];

}

#pragma mark -
#pragma mark DRAGGING METHODS


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
    self.selectedLanguageFromGlobe = languageObject;
    _currentTranslatorRequestType = TR_TRANSLATE_REQUEST_HOME;

    [self initiateLanguageRequest:languageObject];
    [self setGlobeLanguage];
}
-(void)initiateLanguageRequest:(LanguageDS *)languageObject{
    
    
    
    
    if([languageObject.transCode isEqualToString:@"hi"]){
        
        CLLocationCoordinate2D coordinate = [APP_DELEGATE getCurrentLocationCoordinate ];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude ];
        NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.longitude ];
                __weak HomeViewController *weakSelf = self;
        [[TTAPIHandler sharedWorker] getMonumentListByRange:lat withLongitude:longitude withrad:radiusValue withLanguageLocale:@"hi" withRequestType:
         GET_MONUMENT_LIST_BY_RANGE responseHandler:^(BOOL isResultSuccess, NSError *error) {
//             [self setGlobeLanguage];
//             [APP_DELEGATE setCityMonumentListArray:cityMonumentArra];
             [weakSelf setUpInitialData];
             [Utilities hideHUDForView:self.view];
             
         }];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTranslationComplete:) name:GA_TRANSLATE_DONE object:nil];
        
        [[TranslatorManager sharedInstance] translateLanguage:APP_DELEGATE.defaultCityMonumentList withSource:@"en" withTarget:languageObject.transCode withRequestSource:_currentTranslatorRequestType];
        
//        [self setGlobeLanguage];
    }
}
-(void)languagePopUpViewDidCancelButonTappedWithLanguage:(Language *)languageObject{
    
      [_klcPopLanguageView dismiss:YES];
}
-(void)setGlobeLanguage{
    
    if(_selectedLanguageFromGlobe ==nil){
        _selectedLanguageFromGlobe = [APP_DELEGATE getLanguage];
    }
    NSString *languageLocale = [_selectedLanguageFromGlobe.localeCode capitalizedString];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateNormal];
    [customButton setTitle:[NSString stringWithFormat:@"  %@",languageLocale] forState:UIControlStateHighlighted];

}
-(void)onTranslationComplete:(NSNotification *)notification{
    
    NSArray *aarr = (NSArray *)[notification object];
//    [APP_DELEGATE setCityMonumentListArray:aarr];
    
//    [self setGlobeLanguage];
    [Utilities hideHUDForView:self.view];
  [self setUpMapData];
//    [self setUpInitialData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GA_TRANSLATE_DONE object:nil];
}


#pragma mark -
#pragma  UISEARCHBAR DELEGATE
-(void)setUpViewTableView{
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AutoCompleteView" owner:self options:nil];
    
    self.autoCompleteView = (AutoCompleteView *)[arr objectAtIndex:0];
    self.autoCompleteView.frame = CGRectMake(self.autoCompleteView.frame.origin.x, 0, 250.0f, 180.0f);
    self.autoCompleteView.delegate = self;
    _klcPopAutoCompleteView = [KLCPopup popupWithContentView:self.autoCompleteView];
    _klcPopAutoCompleteView.maskType = KLCPopupMaskTypeNone;

    
}
-(void)setUpAutoCompleteFetcher{
    
    // Set bounds to inner-west Sydney Australia.
    CLLocationCoordinate2D neBoundsCorner =self.homeViewLocation.coordinate;// CLLocationCoordinate2DMake(-33.843366, 151.134002);
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar                     // called when text starts editing
{
       [self setAutoSearchHiddenViewState:NO];
    [self animateTextField:searchBar up:YES];

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                      // called when text ends editing
{
       [self setAutoSearchHiddenViewState:YES];
    [self animateTextField:searchBar up:NO];

    
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
 
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if ([searchText isEqualToString:@""]) {
//        
//        [searchBar resignFirstResponder];
//        searchBar.text = [APP_DELEGATE getCurrentLocationAddress];
//        [_klcPopAutoCompleteView dismiss:YES];
//    }else{
        [_fetcher sourceTextHasChanged:searchText];
//    }
    
}
-(void)animateTextField:(UISearchBar*)textField up:(BOOL)up
{
    const int movementDistance = -190; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    NSMutableString *resultsStr = [NSMutableString string];
    for (GMSAutocompletePrediction *prediction in predictions) {
        [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
    }
    
    if (predictions.count>0) {
    [_klcPopAutoCompleteView showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
        
    [self.autoCompleteView setUpData:predictions];
    }else{
        
        [_klcPopAutoCompleteView dismiss:YES];
    }
    

    NSLog(@"%@", resultsStr);
}

-(void)onAutoCompleteResultSelect:(GMSAutocompletePrediction *)prediction{
    [_searchBar resignFirstResponder];

    [_klcPopAutoCompleteView dismiss:YES];
    
    
            __weak HomeViewController *weakSelf = self;
    [[GMSPlacesClient sharedClient] lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
         [Utilities addHUDForView:weakSelf.view];
        if (error!=nil) {
            [Utilities hideHUDForView:weakSelf.view];
        }else{
            
            if (result !=nil) {
                NSLog(@"Place name %@", result.name);
                NSLog(@"Place address %@", result.formattedAddress);
                NSLog(@"Place attributions %@", result.attributions.string);
                _searchBar.text = result.formattedAddress;
                NSLog(@"lat : %f long : %f",result.coordinate.latitude,result.coordinate.longitude);
                
                //    CLLocation* location;// = place.coordinate;
                weakSelf.homeViewLocation = [[CLLocation alloc] initWithLatitude:result.coordinate.latitude longitude:result.coordinate.longitude];
               
                [weakSelf callMonumentAPIForLocation];
                isUseExtra = NO;
                
            }
        }
        
        
    }];
    
}


- (void)didFailAutocompleteWithError:(NSError *)error {
    //    _resultText.text = [NSString stringWithFormat:@"%@", error.localizedDescription];
}
@end
