//
//  MenuTableViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 10/11/15.
//  Copyright © 2015 Namit Nayak. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ProfileTableViewCell.h"
#import "MenuTableViewCell.h"
#import "ShareTableViewCell.h"
@interface MenuTableViewController ()
@property (nonatomic,strong) NSArray *menuOptsArra;
@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    _menuOptsArra =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Namit Nayak",@"profileName",@"man.png",@"profilePic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"My Account",@"menuName",@"menu1.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"My Itinerary",@"menuName",@"menu2.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"My Buddy",@"menuName",@"menu3.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Offline Mode",@"menuName",@"menu4.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Offline Mode",@"menuName",@"menu4.png",@"menuPic", nil], nil];

    [self.tableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuOptsArra.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return 120;
            break;
            case 5:
            return 170;
            
        default:
            return 100;
            break;
    }
    return 88;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data;
    
   
        data = [_menuOptsArra objectAtIndex:indexPath.row];

    
   
    
    
    switch (indexPath.row) {
        case 0:
        {
          ProfileTableViewCell *   cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell" forIndexPath:indexPath];
            cell.profilePicImgView.image = [UIImage imageNamed:[data objectForKey:@"profilePic"]];
            cell.userNameLbl.text = [data objectForKey:@"profileName"];
            return cell;
        }
            break;
        case 5:
        {
            ShareTableViewCell *   cell = (ShareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ShareTableViewCell" forIndexPath:indexPath];
            return cell;

        }
            break;
        default:
        {
            MenuTableViewCell *   cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];
            cell.menuImageView.image = [UIImage imageNamed:[data objectForKey:@"menuPic"]];
            cell.menuLabel.text = [data objectForKey:@"menuName"];
            return cell;

        }
            break;
    }
    
    
    // Configure the cell...
    
    return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
