//
//  RadiusView.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "RadiusView.h"

@implementation RadiusView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        self.frame = frame;
    }
    return self;
}

-(IBAction)okBtnTapped:(id)sender{
    if([self.delegate respondsToSelector:@selector(radiusViewDidOkButonTappedWithSliderValue:)]){
        
        [self.delegate radiusViewDidOkButonTappedWithSliderValue:[self.sliderLabel.text floatValue]];
    }
}
-(IBAction)cancelBtnTapped:(id)sender{
    if([self.delegate respondsToSelector:@selector(radiusViewDidCancelButonTappedWithSliderValue:)]){
        [self.delegate radiusViewDidCancelButonTappedWithSliderValue:[self.sliderLabel.text floatValue]];

    }
}

-(IBAction)sliderValueChanged:(id)sender{
    
     self.sliderLabel.text = [NSString stringWithFormat:@"%0.f", self.slider.value];
    
}

@end
