//
//  OfflineMainListTableViewCell.h
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityMonument;
@protocol CustomCellDeleteMethod;
@interface OfflineMainListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallMonumentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *monumentCountLbl;

@property (weak, nonatomic) IBOutlet UILabel *languageLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) CityMonument *cityMonument;
@property (nonatomic,weak) id<CustomCellDeleteMethod> customDelegate;
- (IBAction)deleteBtnTapped:(id)sender;
- (IBAction)editBtnTapped:(id)sender;



@end
@protocol CustomCellDeleteMethod <NSObject>

@optional
-(void)deleteButtonTappedForCell:(UITableViewCell *)cell;
-(void)editButtonTappedForCell:(UITableViewCell *)cell;

@end