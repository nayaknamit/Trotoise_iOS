
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
    [Utilities addHUDForView:_fullScreenImageView];
    isPortrait = YES;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [self.scrollView setMaximumZoomScale:15];
    [self.scrollView setMinimumZoomScale:1.0];
    
    [manager downloadImageWithURL: [NSURL URLWithString:self.imageUrl]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image)
         {
             
             self.scrollView.contentSize = CGSizeZero;//CGSizeMake(image.size.width,image.size.height);
             
             
             self.fullScreenImageView.image = image;
             [Utilities hideHUDForView:_fullScreenImageView];
             
//             [self.scrollView setZoomScale:3.0 animated:YES];

             // do something with image
         }
     }];

    
    // Do any additional setup after loading the view.
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
