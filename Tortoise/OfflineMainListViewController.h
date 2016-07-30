//
//  OfflineMainListViewController.h
//  Tortoise
//
//  Created by Namit Nayak on 4/20/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineMainListViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) __block NSMutableArray *dataArra;
@property (nonatomic,weak) IBOutlet UIButton *addBtn;
@property (nonatomic,strong) NSString *checkScreenFrom;
-(IBAction)addBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backbutton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *noMonumentTextView;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;

@end
