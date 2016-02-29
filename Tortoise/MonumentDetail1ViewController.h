//
//  MonumentDetail1ViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonumentListDS;
@interface MonumentDetail1ViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MonumentListDS * monumentDetailObj;
@end
