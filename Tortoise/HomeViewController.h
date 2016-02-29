//
//  ViewController.h
//  Tortoise
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource,UIScrollViewDelegate, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainHeightConstraint;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;

@end

