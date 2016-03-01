//
//  ImageScrollerViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 2/29/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollerViewController : UIViewController
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;

@property  (nonatomic,strong) NSString *titleText;
@property (nonatomic,strong) NSString *imageNameString;
@end
