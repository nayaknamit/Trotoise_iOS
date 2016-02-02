//
//  ViewController.h
//  Tortoise
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource,UIScrollViewDelegate, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

