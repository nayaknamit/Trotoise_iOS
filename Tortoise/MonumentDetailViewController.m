//
//  MonumentDetailViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 2/6/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "MonumentDetailViewController.h"
#import "UIFont+Trotoise.h"
#import "MonumentListDS.h"
@interface MonumentDetailViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *placeImageView;
@property (nonatomic,weak) IBOutlet UIButton *speakerBtn;
@property (nonatomic,weak) IBOutlet UIButton *mapDirectionBtn;
@property (nonatomic,weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic,weak) IBOutlet UILabel *placeLabel;

-(IBAction)mapDirectionButtonTapped:(id)sender;
-(IBAction)speakerBtnTapped:(id)sender;

@end

@implementation MonumentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    self.descriptionTextView.text= self.monumentDetailObj.desc;
    self.placeLabel.text = self.monumentDetailObj.name;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    
    [manager downloadImageWithURL:[NSURL URLWithString:self.monumentDetailObj.thumbnail]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image)
         {
             self.placeImageView.image = image;
             // do something with image
         }
     }];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpNavigationBar{
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.title = @"TROTOISE";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont TrotoiseFontCondensedRegular:24], NSFontAttributeName, nil]];
    
    
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:[UIImage imageNamed:@"ic_language"] forState:UIControlStateNormal];
    [customButton setTitle:@"En" forState:UIControlStateNormal];
    [customButton.titleLabel setFont:[UIFont TrotoiseFontLight:18]];
    [customButton sizeToFit];
    UIBarButtonItem* customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
    
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
