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
#import "LoggedInUserDS.h"
#import "GetInspiredViewController.h"
#import "LanguageViewController.h"
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
    
    LoggedInUserDS *loggedInUserData = [APP_DELEGATE getLoggedInUserData];
    
    
    _menuOptsArra =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:loggedInUserData.name,@"profileName",loggedInUserData.email,@"email",loggedInUserData.coverImageUrl,@"cover",loggedInUserData.imageUrl,@"profilePic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Get Inspired",@"menuName",@"ic_slideshow.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"About Us",@"menuName",@"ic_about_us.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Rate Us",@"menuName",@"ic_feedback.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Language",@"menuName",@"language.png",@"menuPic", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Logout",@"menuName",@"logout.png",@"menuPic", nil], nil];

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
            return 224;
            break;
                        
        default:
            return 69;
            break;
    }
    return 69;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data;
    
   
        data = [_menuOptsArra objectAtIndex:indexPath.row];

    
   
    
    
    switch (indexPath.row) {
        case 0:
        {
          ProfileTableViewCell *   cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell" forIndexPath:indexPath];
            cell.userNameLbl.text = [data objectForKey:@"profileName"];
            cell.emailLbl.text = [data objectForKey:@"email"];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:(NSURL *)[data objectForKey:@"profilePic"]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if (image)
                 {
                    cell.profilePicImgView.image = image;
                     cell.profilePicImgView.layer.cornerRadius = cell.profilePicImgView.frame.size.width / 2;
                     cell.profilePicImgView.clipsToBounds = YES;
                     cell.profilePicImgView.layer.borderWidth = 3.0f;
                     cell.profilePicImgView.layer.borderColor = [UIColor whiteColor].CGColor;

                     // do something with image
                 }
             }];
            
            [manager downloadImageWithURL:(NSURL *)[data objectForKey:@"cover"]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if (image)
                 {
                     cell.coverPicImgView.image = image;
                     // do something with image
                 }
             }];

            
            
            return cell;
        }
            break;
        case 1:
        {
            NSString *CellIdentifier = @"MenuTableViewCell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            break;
        case 2:
        {
            NSString *CellIdentifier = @"MenuTableViewCell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            
            break;
        case 3:
        {
            NSString *CellIdentifier = @"MenuTableViewCell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            break;
        case 4:
        {
            NSString *CellIdentifier = @"MenuTableViewCell4";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            break;
        case 5:
        {
            NSString *CellIdentifier = @"MenuTableViewCell5";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            break;
        default:
        {
//            MenuTableViewCell *   cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];
//            cell.menuImageView.image = [UIImage imageNamed:[data objectForKey:@"menuPic"]];
//            cell.menuLabel.text = [data objectForKey:@"menuName"];
//            return cell;

        }
            break;
    }
    
    
    // Configure the cell...
    
    return nil;
}
#pragma mark TABLEVIEW DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
    case 5:
        {
            [APP_DELEGATE logOutUser];
        }
            break;
            
        default:
            break;
    }
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
