//
//  HomeViewTableViewCell.m
//  Tortoise
//

#import "HomeViewTableViewCell.h"

@implementation HomeViewTableViewCell

-(id)init{
    
    if (self=[super init]) {
        self.placeImageView.layer.cornerRadius = self.placeImageView.frame.size.width / 2;
        self.placeImageView.clipsToBounds = YES;
        self.placeImageView.layer.borderWidth = 3.0f;
        self.placeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}
@end
