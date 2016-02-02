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
#import "UIFont+Trotoise.h"
#import "RadiusView.h"
#import "KLCPopup.h"
@interface HomeViewController ()<CLLocationManagerDelegate,GMSMapViewDelegate, RadiusViewDelegate>
{
    

}
@property (nonatomic,strong) NSMutableArray *dataArra;
@property (nonatomic,strong) IBOutlet GMSMapView *mapContainerView;
@property (nonatomic,strong) IBOutlet UITableView * tableView;
@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong) KLCPopup *klcPopView;
@property (nonatomic,strong) RadiusView *radiusView;
@property (weak,nonatomic) IBOutlet UIButton *radiusButton;
-(void)setUpLocationManager;



-(IBAction)radiusBtnTapped:(id)sender;
-(IBAction)currentLocationBtnTapped:(id)sender;
///Dragging


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavigationBar];
    [self setUpRadiusPopUp];
    [self setUpDraggableView];
    
    [self setUpLocationManager];
    
    [self dummyData];
    
    [[TTAPIHandler sharedWorker] getMonumentListByCityID:@"3102" withRequestType:GET_MONUMENT_LIST_BY_CITYID responseHandler:^(NSArray *cityMonumentArra, NSError *error) {
        
        NSLog(@"einsde");
        
    }];
}
-(void)setUpDraggableView{
    
    [_mainView makeDraggable];
    [_mainView setDelegate:self];
    [_mainView setDragMode:UIViewDragDropModeRestrictY];
    [_mainView setStageTopPoint:self.mapContainerView.frame.origin];

}
-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontCondensedRegular:24], NSFontAttributeName, nil]];
    
    
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
    [customButton setTitle:@"En" forState:UIControlStateNormal];
    [customButton.titleLabel setFont:[UIFont TrotoiseFontLight:18]];
    [customButton sizeToFit];
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
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}
-(IBAction)radiusBtnTapped:(id)sender{
    [_klcPopView show];
}
-(IBAction)currentLocationBtnTapped:(id)sender{
    
}
-(void)setUpRadiusPopUp{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RadiusView" owner:self options:nil];

    self.radiusView = (RadiusView *)[arr objectAtIndex:0];
    self.radiusView.frame = CGRectMake(self.radiusView.frame.origin.x, self.radiusView.frame.origin.y, 297.0f, 163.0f);
    self.radiusView.delegate = self;
   _klcPopView = [KLCPopup popupWithContentView:self.radiusView];
    
}
-(void)mapSetUpWithLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude{
    
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:latitude
                                          longitude:longitude
                                               zoom:4.0];
    _mapContainerView.delegate = self;
    [_mapContainerView setCamera:cameraPosition];
//    [_mapContainerView setMyLocationEnabled:YES];
    [_mapContainerView.settings setCompassButton:YES];
    [_mapContainerView.settings setMyLocationButton:YES];
    
    // Listen to the myLocation property of GMSMapView.
    [_mapContainerView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    
    // Creates a marker in the center of the map.
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = @"Trotoise";
    marker.snippet = @"Trotoise";
    marker.map = _mapContainerView;
//    [self addSubview:_mapView];

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
-(void)draggingDidEndViewFrameSet:(CGRect)viewFrame{
//    self.tableView.frame = viewFrame
    [UIView animateWithDuration:0.1 animations:^{
        self.bottomConstraint.constant= -viewFrame.size.height;
//        [self updateViewConstraints];
    }];
    
    //CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, viewFrame.size.height);
    
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

-(void)setUpLocationManager{
    
    _locationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
//        [_locationManager requestAlwaysAuthorization];
        
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [_locationManager startUpdatingLocation];
        _locationManager.delegate = self;
        
    }
    
    
}
#pragma mark - CLLOCATION DELEGATE
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation* location = [locations objectAtIndex:0];
    [self mapSetUpWithLatitude:location.coordinate.latitude withLongitude:location.coordinate.longitude];
    
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
    
    NSDictionary *duck = [_dataArra objectAtIndex:indexPath.section];
    
    cell.placeTitleLbl.text = [duck objectForKey:@"title"];
    cell.descriptionLbl.text = [duck objectForKey:@"description"];
    cell.placeImageView.image = [UIImage imageNamed:@"paris.png"];

    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112.0f;
}


//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    NSLog(@"%f",velocity.y);
//    if(velocity.y>2){
//     self.tableView.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.width);
//        
//    [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//        
//        self.topConstraint.constant = -20 + (self.view.frame.size.height/2);
//        
//        self.heightConstraint.constant = self.view.frame.size.height/2;
//
//        [self.tableView layoutSubviews];
//
//    } completion:^(BOOL finished) {
//        
//    }];
//        
//    }
//    
//}
#pragma Mark #

-(void)dummyData{
   NSString *des = @" Greater Paris (the city plus surrounding departments) received 22,4 million visitors in 2014, making it one of the world's top tourist destinations. The largest numbers of foreign tourists in 2014 came from the United States (2.74 million), the U.K., Germany, Italy, Japan, Spain and China (532,000). Arrivals from the U.K, Germany, Russia and Japan dropped from 2013, while arrivals from the Near and Middle East grew by twenty percent.";
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict33 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict44 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict333 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    NSDictionary *dict444 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Paris",@"title",des,@"description", nil];
    _dataArra = [NSMutableArray arrayWithObjects:dict,dict1,dict2,dict3,dict4,dict33,dict44,dict333,dict444, nil];
    
}

#pragma mark -
#pragma mark RadiusView Delegate Method
-(void)radiusViewDidOkButonTappedWithSliderValue:(CGFloat)sliderValue{
    NSLog(@"Radius View Ok Button Pressed slider Value %0.f",sliderValue);
}
-(void)radiusViewDidCancelButonTappedWithSliderValue:(CGFloat)sliderValue{
    [_klcPopView dismiss:YES];

}

#pragma mark - 
#pragma mark DRAGGING METHODS 




@end
