//
//  MonumentDetailViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/6/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "MonumentDetailViewController.h"
#import "UIFont+Trotoise.h"
#import "MonumentListDS.h"
#import "ASMediaFocusManager.h"
@interface MonumentDetailViewController ()<UIScrollViewDelegate, ASMediasFocusDelegate>
{
    

    BOOL pageControlBeingUsed;
}
@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic,weak) IBOutlet UIImageView *placeImageView;
@property (nonatomic,weak) IBOutlet UIButton *speakerBtn;
@property (nonatomic,weak) IBOutlet UIButton *mapDirectionBtn;
@property (nonatomic,weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic,weak) IBOutlet UILabel *placeLabel;
@property (nonatomic,weak) IBOutlet UIScrollView *imageScrollerView;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) ASMediaFocusManager *mediaFocusManager;
@property (nonatomic,strong)__block NSMutableArray *imageViews;
-(IBAction)mapDirectionButtonTapped:(id)sender;
-(IBAction)speakerBtnTapped:(id)sender;
-(IBAction)closeBtnTapped:(id)sender;
@end

@implementation MonumentDetailViewController

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

-(IBAction)closeBtnTapped:(id)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)speakerBtnTapped:(id)sender{
    
}
-(IBAction)mapDirectionButtonTapped:(id)sender{
    
    double lat = [self.monumentDetailObj.latitude doubleValue];
    double lon = [self.monumentDetailObj.longitude doubleValue];
    
//    if ([[UIApplication sharedApplication] canOpenURL:
//         [NSURL URLWithString:@"comgooglemaps://"]]) {
    NSString *str = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f&zoom=12&views=traffic",self.monumentDetailObj.name,lat,lon];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url] ;
//    } else {
//        NSLog(@"Can't use comgooglemaps://");
//    }


}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    self.descriptionTextView.text= self.monumentDetailObj.desc;
    self.placeLabel.text = self.monumentDetailObj.name;
    self.imageViews = [NSMutableArray array];
    [self setUpScrollViewImages];
    
    
    // Do any additional setup after loading the view.
}

-(void)setUpScrollViewImages{
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    self.mediaFocusManager.zoomEnabled = YES;
//    [self.mediaFocusManager ]
    self.mediaFocusManager.elasticAnimation = YES;
     __block CGFloat scrollViewWidth = self.view.bounds.size.width;
   __block CGFloat scrollViewHeight = 201;
    NSArray *imageSetArray =  [self.monumentDetailObj.imageAttributes allObjects];
    if([imageSetArray count]>0){
        
        [imageSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ImageAttributeDS * imageDS = (ImageAttributeDS *)obj;
            CGRect frame;
            frame.origin.x = self.imageScrollerView.frame.size.width * idx;
            frame.size = self.imageScrollerView.frame.size;
            self.imageScrollerView.pagingEnabled = YES;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth *idx, 0, scrollViewWidth, scrollViewHeight)];

//            [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            imageView.translatesAutoresizingMaskIntoConstraints = YES;
            imageView.autoresizesSubviews = YES;
     
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//            NSString *imageViewImage = 
            
            [manager downloadImageWithURL: [NSURL URLWithString:imageDS.imageUrl]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if (image)
                 {
                     imageView.image = image;
                     // do something with image
                 }
             }];
            
            [self.imageScrollerView addSubview:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageViews addObject:imageView];
        }];
    
     
        [self.mediaFocusManager installOnViews:self.imageViews];
        
        self.imageScrollerView.contentSize = CGSizeMake(scrollViewWidth * [imageSetArray count], self.imageScrollerView.frame.size.height);
        
        
        self.imageScrollerView.delegate = self;
        
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = [imageSetArray count];

    }
    
}

#pragma mark - ASMediaFocusDelegate
// Returns the view controller in which the focus controller is going to be added.
// This can be any view controller, full screen or not.
- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager
{
    self.statusBarHidden = YES;
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    self.statusBarHidden = NO;
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    return self;
}

// Returns the URL where the media (image or video) is stored. The URL may be local (file://) or distant (http://).
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    NSInteger index;
    NSURL *url;
    
    // Here, medias are accessed through their name stored in self.mediaNames
    index = [self.imageViews indexOfObject:view];
   
  ImageAttributeDS *imageDS =  [[self.monumentDetailObj.imageAttributes allObjects] objectAtIndex:index];
    url  = [NSURL URLWithString:imageDS.imageUrl];
    
    NSString *stringUrl = [url absoluteString];
//    float width = [UIScreen mainScreen].bounds.size.width;
//    float height = [UIScreen mainScreen].bounds.size.height;
//stringUrl = [stringUrl stringByReplacingOccurrencesOfString:@"h_702" withString:[NSString stringWithFormat:@"h_%0.1f",height]];
//    stringUrl = [stringUrl stringByReplacingOccurrencesOfString:@"w_1080" withString:[NSString stringWithFormat:@"w_%0.1f",width]];
    
//    url = [NSURL URLWithString:stringUrl];
    return url;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameForView:(UIView *)view{
    
    return  [UIScreen mainScreen].bounds;
}
// Returns the title for this media view. Return nil if you don't want any title to appear.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view
{
    return @"";
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}






- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((self.imageScrollerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    pageControlBeingUsed = NO;
    
    
}
- (IBAction)changePage {
    // Update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.imageScrollerView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.imageScrollerView.frame.size;
    [self.imageScrollerView scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
    // value changing. If we don't do this, a noticeable "flashing" occurs
    // as the the scroll delegate will temporarily switch back the page
    // number.
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    CGFloat pageWidth = self.imageScrollerView.frame.size.width +4;
    int page = floor((self.imageScrollerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    //    NSNumber* currentIndex = [NSNumber numberWithInt:round(scrollView.contentOffset.x / pageWidth)];
    
    //Then just update your scrollviews offset with
    
    
    //    [scrollView setContentOffset:CGPointMake([currentIndex intValue] * pageWidth, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
