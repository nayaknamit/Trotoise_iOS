//
//  HomeViewTableViewCell.h
//  Tortoise
//

#import <UIKit/UIKit.h>

@interface HomeViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;

@end
