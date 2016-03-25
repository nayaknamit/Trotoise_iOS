
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
//    UIImage* image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
    
    NSString *imageURLModified =[ self.imageUrl stringByReplacingOccurrencesOfString:@"h_720" withString:[NSString stringWithFormat:@"h_%0.f",[UIScreen mainScreen].bounds.size.height+40]];
    
    
//    self.fullScreenImageView = [[UIImageView alloc]initWithImage:[FullScreenViewController imageWithImage:image scaledToMaxWidth:1024 maxHeight:[UIScreen mainScreen].bounds.size.height]];
// self.fullScreenImageView.center = self.scrollView.center;[UIImage imageNamed:@"EsselWorld1.jpg"]
    self.fullScreenImageView = [[UIImageView alloc]init];

    self.fullScreenImageView.frame = CGRectMake(self.fullScreenImageView.frame.origin.x,self.fullScreenImageView.frame.origin.y, 1080, [UIScreen mainScreen].bounds.size.height);
    
[Utilities downloadImageWithURL:[NSURL URLWithString:imageURLModified] completionBlock:^(BOOL succeeded, UIImage *image) {
    self.fullScreenImageView.image = image;

//    [self.scrollView ]
    
}];
    self.fullScreenImageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.fullScreenImageView.autoresizesSubviews = YES;
    //    self.fullScreenImageView.contentMode = (UIViewContentModeCenter);
    self.fullScreenImageView.contentMode =UIViewContentModeTopLeft;
    
    //    self.fullScreenImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.fullScreenImageView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.fullScreenImageView];
    
    self.scrollView.contentMode = (UIViewContentModeScaleAspectFit);
    self.scrollView.contentSize = CGSizeMake(self.fullScreenImageView.bounds.size.width-40,self.fullScreenImageView.bounds.size.height);
    self.scrollView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1;
    
    [self.scrollView layoutIfNeeded];
//    self.fullScreenImageView.frame = CGRectMake(-26, 0, image.size.width, image.size.height/2+120);
    
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
