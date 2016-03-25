//
//  DetailTextViewTableViewCell.h
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTextViewTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,weak) IBOutlet UITextView *desTextView;
@end
