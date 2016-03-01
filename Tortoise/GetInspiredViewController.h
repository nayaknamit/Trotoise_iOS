//
//  GetInspiredViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 2/10/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetInspiredViewController : UIViewController <UIScrollViewDelegate>
@property(nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) IBOutlet UIButton *nextBtn;
@end
