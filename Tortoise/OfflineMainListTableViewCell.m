//
//  OfflineMainListTableViewCell.m
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "OfflineMainListTableViewCell.h"

@implementation OfflineMainListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init{
    
    if (self=[super init]) {
        self.smallMonumentImageView.layer.cornerRadius = self.smallMonumentImageView.frame.size.width / 2;
        self.smallMonumentImageView.clipsToBounds = YES;
        self.smallMonumentImageView.layer.borderWidth = 3.0f;
        
        self.smallMonumentImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (IBAction)deleteBtnTapped:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trotoise" message:@"You are about to remove an offline city. If removed city will not be available in Offline mode. \n\nDo you really want to remove this city from Offline list?" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"DELETE", nil];
    [alertView show];
    
    
}
- (IBAction)editBtnTapped:(id)sender{
    if ([self.customDelegate respondsToSelector:@selector(editButtonTappedForCell:)]){
        [self.customDelegate editButtonTappedForCell:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1){
        if ([self.customDelegate respondsToSelector:@selector(deleteButtonTappedForCell:)]){
            [self.customDelegate deleteButtonTappedForCell:self];
        }
        
    }
    
}
@end
