//
//  LanguageViewController.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguageViewController.h"
#import "TTAPIHandler.h"
#import "KLCPopup.h"
#import "LanguageTableView.h"
#import "LanguageDS.h"
@interface LanguageViewController ()<LanguageTableViewDelegate>
@property (nonatomic,strong) LanguageTableView *languageTableView;
@property (nonatomic,strong) KLCPopup *klcPopView;
@property (nonatomic,weak) IBOutlet UILabel *languageLabel;
@property (nonatomic,weak) IBOutlet UIImageView *speakrImageView;
@property (nonatomic,weak) IBOutlet UIImageView *textCheckBoxImageView;
@property (nonatomic,weak) IBOutlet UIImageView *audioCheckBoxImageView;



@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(onTapGestureEventFired:)] ;
    
    
    [recognizer setNumberOfTapsRequired:01];
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguageTableView" owner:self options:nil];
    self.languageTableView =  (LanguageTableView *)[arr objectAtIndex:0];
    [self.languageDisplayView addGestureRecognizer:recognizer];
    self.languageTableView.delegate = self;
    _klcPopView = [KLCPopup popupWithContentView:self.languageTableView];

    
    
    [[TTAPIHandler sharedWorker] getLanguageMappingwithRequestType:GET_LANGUAGE_MAPPING withResponseHandler:^(NSArray *languageMappingArra, NSError *error) {
        NSLog(@"LanguageDescription %@",[languageMappingArra description]);
        [self.languageTableView setUpLanguageData:languageMappingArra];

        
    }];
}

-(void)languageTableView:(LanguageTableView *)languageTableView didSelectLanguageData:(LanguageDS *)data{
    
    [_klcPopView dismiss:YES];
    self.textCheckBoxImageView.image = [UIImage imageNamed:@"checkbox"];
    
    if(data.nuanceRelationship !=nil){
        self.speakrImageView.hidden = NO;
        self.audioCheckBoxImageView.image = [UIImage imageNamed:@"checkbox"];
    }else{
        self.speakrImageView.hidden = YES;
        self.audioCheckBoxImageView.image = [UIImage imageNamed:@"uncheck"];
    }
    self.languageLabel.text = data.name;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dspose of any resources that can be recreated.
}
-(void)onTapGestureEventFired:(UIGestureRecognizer *)recongixer{
    [_klcPopView show];
    
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
