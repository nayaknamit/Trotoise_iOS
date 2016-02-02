//
//  ProfileTableViewCell.m
//  Tortoise
//
//  Created by Namit Nayak on 10/11/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)init{
    
    if (self=[super init]) {
        self.profilePicImgView.layer.cornerRadius = self.profilePicImgView.frame.size.width / 2;
        self.profilePicImgView.clipsToBounds = YES;
        self.profilePicImgView.layer.borderWidth = 3.0f;
        self.profilePicImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
