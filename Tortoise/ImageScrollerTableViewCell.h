//
//  ImageScrollerTableViewCell.h
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonumentListDS;
@protocol ImageScrollerTableViewCellDelegate;

@interface ImageScrollerTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>


@property (nonatomic,weak) IBOutlet UIButton *speakerBtn;
@property (nonatomic,weak) IBOutlet UIButton *mapDirectionBtn;
@property (nonatomic,weak) IBOutlet UILabel *placeLabel;
@property (nonatomic,weak) IBOutlet UIScrollView *imageScrollerView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong)__block NSMutableArray *imageViews;
@property (nonatomic) BOOL isSpeakerPlaying;
@property (nonatomic,strong) MonumentListDS * monumentDetailObj;
@property (nonatomic,assign) id<ImageScrollerTableViewCellDelegate> delegate;
@property (nonatomic,strong) Language *selectedLanguage;
-(IBAction)mapDirectionButtonTapped:(id)sender;
-(IBAction)speakerBtnTapped:(id)sender;

-(void)setUpScrollViewImages;


@end


@protocol ImageScrollerTableViewCellDelegate <NSObject>
- (UIViewController *)parentViewControllerForFullScreenManager;

@optional

-(void)mediaFocusManagerWillAppearForDelegate;
-(void)mediaFocusManagerWillDisappear;

@end