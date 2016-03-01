//
//  AboutUsViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/23/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
/*
 Not every holiday is a long one. Or even a planned one. But its what you discover in your journey, that makes even a business trip, your own personal holiday. Discover a story or two with Trotoise.
 
 This pocket friendly travel guide enhances your travel experience by giving you engaging and succinct information, historical facts about popular monuments and must-visits within your range of comfort.
 
 Available in audio and text in a language of your choice, Trotoise helps you make a connection with the places you travel to, making you feel quite at home.
 Unravel the sublime and the ridiculous with your very own travel guide.
 
 Log in with Google+ or Facebook, select your preferred language, choose the range or distance you are willing to go to and let Trotoise bring alive the many stories as you go about exploring the city.
 
 For more information on the terms and conditions please visit our website http://www.trotoise.com
 */

#import "AboutUsViewController.h"
#import "AboutUsTableViewCell.h"
#import "TSLabel.h"
@interface AboutUsViewController ()<TSLabelDelegate>
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIButton *continueTapBtn;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 440;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded ];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded ];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
    
}

// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" indexPath %@",[indexPath description]);
    
            NSString *CellIdentifier1 = @"AboutUsCell";
       
        AboutUsTableViewCell *cell = (AboutUsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"aboutUSCell" owner:self options:nil];
            cell = (AboutUsTableViewCell *)[arr objectAtIndex:0];
//            NSAttributedString
            NSMutableAttributedString* at2 =
            [[NSMutableAttributedString alloc] initWithString: cell.aboutUsDetailLbl.text];
            
            NSRange range = [cell.aboutUsDetailLbl.text rangeOfString:@"http://www.trotoise.com"];
            [at2 addAttribute: NSLinkAttributeName value: [NSURL URLWithString: @"http://www.trotoise.com"] range: range];
            cell.aboutUsDetailLbl.delegate = self;
            cell.aboutUsDetailLbl.attributedText = at2;
            
            [cell.aboutUsDetailLbl setLinkAttributes: @{ NSForegroundColorAttributeName : [UIColor blueColor] } forState: UIControlStateNormal];
            
        }
    [cell layoutIfNeeded];

    
    
    return cell;
}
#pragma mark - TSLabel protocol methods

- (BOOL) label:(TSLabel *)label canInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

- (BOOL) label:(TSLabel *)label shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSLog( @"%@", URL );
    return NO;
}
#pragma mark - UITableViewDataDelegate protocol methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
