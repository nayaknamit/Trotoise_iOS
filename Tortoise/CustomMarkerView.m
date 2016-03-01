//
//  CustomMarkerView.m
//  Tortoise
//
//  Created by Namit Nayak on 2/12/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "CustomMarkerView.h"

@implementation CustomMarkerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _bgView.layer.borderColor = [[UIColor blackColor] CGColor];
    _bgView.layer.borderWidth = 1;
    _bgView.layer.cornerRadius = 38;
    
}



@end
