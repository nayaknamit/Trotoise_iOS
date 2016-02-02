//
//  RadiusView.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RadiusViewDelegate;
@interface RadiusView : UIView

@property (nonatomic,strong)IBOutlet UISlider *slider;
@property (nonatomic,strong)IBOutlet UILabel *sliderLabel;
@property (nonatomic,strong) IBOutlet UIButton *okBtn;
@property (nonatomic,strong) IBOutlet UIButton *cancelBtn;

@property (nonatomic,weak) id<RadiusViewDelegate> delegate;

-(IBAction)okBtnTapped:(id)sender;
-(IBAction)cancelBtnTapped:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

-(id)initWithFrame:(CGRect)frame;


- (void) setDelegate:(id<RadiusViewDelegate>)delegate;

@end
@protocol RadiusViewDelegate <NSObject>
@optional

-(void)radiusViewDidOkButonTappedWithSliderValue:(CGFloat)sliderValue;
-(void)radiusViewDidCancelButonTappedWithSliderValue:(CGFloat)sliderValue;

@end