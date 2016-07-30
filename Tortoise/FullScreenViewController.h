//
//  FullScreenViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 2/27/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenViewController : UIViewController
@property (nonatomic,strong) UIImageView *fullScreenImageView;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL isOffline;
-(IBAction)orientationChange:(id)sender;
@end
