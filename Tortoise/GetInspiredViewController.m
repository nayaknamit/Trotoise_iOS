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
    
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)]
    ;
    
    imageViewOne.translatesAutoresizingMaskIntoConstraints = YES;
    imageViewOne.image = [UIImage imageNamed:self.splashImageArra[0]];
    imageViewOne.autoresizesSubviews = YES;
    
    
    
    
    UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
    
    
    imageViewTwo.image = [UIImage imageNamed:self.splashImageArra[1]];
    
    
    UIImageView *imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake((scrollViewWidth)*2, 0, scrollViewWidth, scrollViewHeight)];
    
    
    
    imageViewThree.image = [UIImage imageNamed:self.splashImageArra[2]];
    
    UIImageView *imageViewFour = [[UIImageView alloc] initWithFrame:CGRectMake((scrollViewWidth)*3, 0, scrollViewWidth, scrollViewHeight)];
    
    
    
    imageViewFour.image = [UIImage imageNamed:self.splashImageArra[3]];
    
    UIImageView *imageViewFive = [[UIImageView alloc] initWithFrame:CGRectMake((scrollViewWidth)*4, 0, scrollViewWidth, scrollViewHeight)];
    
    
    
    imageViewFive.image = [UIImage imageNamed:self.splashImageArra[4]];
    
    [self.scrollView addSubview:imageViewOne];
    [self.scrollView addSubview:imageViewTwo];
    [self.scrollView addSubview:imageViewThree];
    [self.scrollView addSubview:imageViewFour];
    [self.scrollView addSubview:imageViewFive];
    //
    
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
