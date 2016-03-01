
//
//  FullScreenViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/27/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController ()<UIScrollViewDelegate>
{
    BOOL isPortrait;
}
-(IBAction)backButtonTapped:(id)sender;
@end

@implementation FullScreenViewController
-(IBAction)backButtonTapped:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utilities addHUDForView:_scrollView];
    isPortrait = YES;
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
//    [imageCache clearDisk];
//    [self.scrollView setMaximumZoomScale:15];
//    [self.scrollView setMinimumZoomScale:1.0];
    UIImage* image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
    
    self.fullScreenImageView = [[UIImageView alloc]initWithImage:[FullScreenViewController imageWithImage:image scaledToMaxWidth:1024 maxHeight:1024]];
// self.fullScreenImageView.center = self.scrollView.center;
    
    self.fullScreenImageView.frame = CGRectMake(-26, 0, image.size.width, image.size.height/2+120);
    self.fullScreenImageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.fullScreenImageView.autoresizesSubviews = YES;
    self.fullScreenImageView.contentMode = (UIViewContentModeCenter);
//    self.fullScreenImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.fullScreenImageView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.fullScreenImageView];
    
    self.scrollView.contentMode = (UIViewContentModeScaleAspectFit);
    self.scrollView.contentSize = CGSizeMake(self.fullScreenImageView.bounds.size.width,self.fullScreenImageView.bounds.size.height);
    self.scrollView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1;
    
//    [manager downloadImageWithURL: [NSURL URLWithString:self.imageUrl]
//                          options:0
//                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
//     {
//         // progression tracking code
//     }
//                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//     {
//         if (image)
//         {
//            
//              self.fullScreenImageView.image = image;
//             self.scrollView.contentSize = CGSizeMake(self.fullScreenImageView.frame.size.width,self.fullScreenImageView.frame.size.height);
////             self.fullScreenImageView.frame = CGRectMake(self.fullScreenImageView.frame.origin.x, self.fullScreenImageView.frame.origin.y, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
//             
//             self.fullScreenImageView.image = image;
//             [Utilities hideHUDForView:_fullScreenImageView];
//             
////             [self.scrollView setZoomScale:3.0 animated:YES];
//
//             // do something with image
//         }
//     }];
//
    
    // Do any additional setup after loading the view.
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    self.scrollView.zoomScale = 4;
    return self.fullScreenImageView;
}


- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(IBAction)orientationChange:(id)sender{
    
   if (isPortrait) {
        self.view.transform =CGAffineTransformMakeRotation(M_PI_2);
        self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        isPortrait = NO;
    }else{
        self.view.transform =CGAffineTransformMakeRotation(0);
        self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        isPortrait = YES;
    }
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
