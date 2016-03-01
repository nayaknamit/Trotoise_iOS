//
//  GetInspiredViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/10/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "GetInspiredViewController.h"

@interface GetInspiredViewController ()
{
    
    CGFloat scrollViewWidth;
    BOOL pageControlBeingUsed;
}
@property (nonatomic,strong) NSArray *splashImageArra;
@end

@implementation GetInspiredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splashImageArra = [NSArray arrayWithObjects:@"walkthrough_01",@"walkthrough_02",@"walkthrough_03",@"walkthrough_04",@"walkthrough_05", nil];
    [self setSplashScreen];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - SplashScreen Methods
-(void)setSplashScreen{
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    scrollViewWidth = self.scrollView.frame.size.width;
    CGFloat scrollViewHeight = self.scrollView.frame.size.height;
    NSInteger counter =0;
    for(NSString *imageNameString in self.splashImageArra){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollViewWidth*counter, -20, scrollViewWidth, scrollViewHeight+20)];
        
        view.translatesAutoresizingMaskIntoConstraints = YES;
        view.autoresizesSubviews = YES;
        
        UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, view.frame.size.width, view.frame.size.height)];
        
        
        
        imageViewOne.translatesAutoresizingMaskIntoConstraints = YES;
        imageViewOne.image = [UIImage imageNamed:imageNameString];
        imageViewOne.autoresizesSubviews = YES;
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,[UIScreen mainScreen].bounds.size.height/2+40,imageViewOne.frame.size.width-10,70)];
        lblTitle.numberOfLines = 3;
        
        lblTitle.textAlignment = NSTextAlignmentCenter;
        [lblTitle setFont:[UIFont TrotoiseFontCondensedRegular:14]];
        NSDictionary *textDict = [[APP_DELEGATE getSplashTextArray] objectAtIndex:counter];
        
        
        //        lblTitle.text = @"We never run out of stories to tell. You \n never run out of places to see.";
        [lblTitle setText:[textDict objectForKey:@"title"]];
        
        //        lblTitle.backgroundColor = [UIColor blackColor];
        lblTitle.textColor = [UIColor darkGrayColor];
        lblTitle.translatesAutoresizingMaskIntoConstraints = YES;
        lblTitle.autoresizesSubviews = YES;
        
        UILabel *lblDes = [[UILabel alloc] initWithFrame:CGRectMake(0,lblTitle.frame.origin.y+lblTitle.frame.size.height-35,imageViewOne.frame.size.width,70)];
        lblDes.numberOfLines = 3;
        
        lblDes.textAlignment = NSTextAlignmentCenter;
        [lblDes setFont:[UIFont TrotoiseFontLightItalic:12]];
        //        lblTitle.text = @"We never run out of stories to tell. You \n never run out of places to see.";
        [lblDes setText:[textDict objectForKey:@"desc"]];
        //        lblTitle.backgroundColor = [UIColor blackColor];
        lblDes.textColor = [UIColor darkGrayColor];
        lblDes.translatesAutoresizingMaskIntoConstraints = YES;
        lblDes.autoresizesSubviews = YES;
        
        [view addSubview:imageViewOne];
        [view insertSubview:lblTitle aboveSubview:imageViewOne];
        
        [view insertSubview:lblDes aboveSubview:imageViewOne];
        //        [imageViewOne insertSubview:lblTitle atIndex:100];
        
        
        //        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RadiusView" owner:self options:nil];
        //      ImageScrollerViewController *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageScrollerViewController"];
        
        //      imageVC.titleText = @"Helloo Namit Nayak We never run out of stories to tell. You \n never run out of places to see.";
        //        imageVC.imageNameString = imageNameString;
        //
        //        imageVC.view.frame = CGRectMake(scrollViewWidth*counter, -20,scrollViewWidth, scrollViewHeight+20);
        
        counter++;
        [self.scrollView addSubview:view];
        
    }
       self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.splashImageArra count], self.scrollView.frame.size.height);
    
    
    self.scrollView.delegate = self;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.splashImageArra count];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}






- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    pageControlBeingUsed = NO;
    
    
}

- (IBAction)changePage {
    // Update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
    // value changing. If we don't do this, a noticeable "flashing" occurs
    // as the the scroll delegate will temporarily switch back the page
    // number.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    CGFloat pageWidth = self.scrollView.frame.size.width +4;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    //    NSNumber* currentIndex = [NSNumber numberWithInt:round(scrollView.contentOffset.x / pageWidth)];
    
    //Then just update your scrollviews offset with
    
    
    //    [scrollView setContentOffset:CGPointMake([currentIndex intValue] * pageWidth, 0) animated:YES];
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
