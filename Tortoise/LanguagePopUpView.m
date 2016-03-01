//
//  LanguagePopUpView.m
//  Tortoise
//
//  Created by Namit Nayak on 2/27/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguagePopUpView.h"
#import "LanguageDS.h"
#import "LoggedInUserDS.h"
@interface LanguagePopUpView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIView *languageTapView;
@property (nonatomic,weak) IBOutlet UIImageView *speakerImageView;
@property (nonatomic,weak) IBOutlet UILabel *languageLabel;
@property (nonatomic,weak) IBOutlet UIButton *okBtn;
@property (nonatomic,weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic,weak) IBOutlet UIImageView *textImageView;
@property (nonatomic,weak) IBOutlet UIImageView *audioImageView;
@property (nonatomic,weak) IBOutlet UITableView *languageTableView;

@property (nonatomic,strong) NSMutableArray *dataArra;

@property (nonatomic,strong) LanguageDS *selectedLanguageDS;

-(IBAction)okButtonTapped:(id)sender;
-(IBAction)cancelButtonTapped:(id)sender;
@end

@implementation LanguagePopUpView

-(IBAction)okButtonTapped:(id)sender{
//     [Utilities addHUDForView:se];
    
    
    if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidOkButonTappedWithLanguage:)]) {
        [self.delegate languagePopUpViewDidOkButonTappedWithLanguage:_selectedLanguageDS];
    }
}
-(IBAction)cancelButtonTapped:(id)sender{
    if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidCancelButonTappedWithLanguage:)]) {
        [self.delegate languagePopUpViewDidCancelButonTappedWithLanguage:_selectedLanguageDS];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
    // Drawing code
}
*/
-(void)setUpLanguagePopUpView{
    
    self.dataArra = [NSMutableArray arrayWithArray:[APP_DELEGATE getLanguageDataArray]];
    [self.tableView  reloadData];
    
    [self setUpLanguageView];
    
}

-(void)setUpLanguageView{
    
    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
    
    if(loggedInUser.selectedLanguageDS){
        
        [self updateLanguageDetailsOnScreen:loggedInUser.selectedLanguageDS];
    }else{
        [APP_DELEGATE setDefaultLanguage];
        loggedInUser = [APP_DELEGATE getLoggedInUserData];
        
        [self updateLanguageDetailsOnScreen:loggedInUser.selectedLanguageDS];
        
    }
    
    
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(onTapGestureEventFired:)] ;
    [recognizer setNumberOfTapsRequired:01];
    
    [self.languageTapView addGestureRecognizer:recognizer];
    
    
}
-(void)onTapGestureEventFired:(UIGestureRecognizer *)recognizer{
    
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.tableView.hidden = NO;
    } completion:nil];
}
-(void)updateLanguageDetailsOnScreen:(LanguageDS *)languageDS{
    
    self.textImageView.image = [UIImage imageNamed:@"checkbox"];
    
    if(languageDS.nuanceRelationship !=nil){
        self.speakerImageView.hidden = NO;
        self.audioImageView.image = [UIImage imageNamed:@"checkbox"];
    }else{
        self.speakerImageView.hidden = YES;
        self.audioImageView.image = [UIImage imageNamed:@"uncheck"];
    }
    self.languageLabel.text = languageDS.name;
//    [APP_DELEGATE setSelectedLanguageData:languageDS];
    
    
    
}

#pragma mark -
#pragma TableView
#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
return _dataArra.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"languagePopupViewCell";
    
    
    LanguagePopupViewCell *cell = (LanguagePopupViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguageTableView" owner:self options:nil];
        cell = (LanguagePopupViewCell *)[arr objectAtIndex:1];
    }
    
    LanguageDS * dataStructer;
    dataStructer = [_dataArra objectAtIndex:indexPath.row];
    cell.labelLanguage.text = dataStructer.name;
    if(dataStructer.nuanceRelationship!=nil){
        cell.speakerImageView.hidden = NO;
    }else{
        cell.speakerImageView.hidden = YES;
    }
    
    
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedLanguageDS = [_dataArra objectAtIndex:indexPath.row];
//    self.languageLabel.text = dataObject.name;
    [self updateLanguageDetailsOnScreen:_selectedLanguageDS];
    [UIView animateWithDuration:1.0 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.tableView.hidden = YES;
    } completion:nil];

}


@end
@implementation LanguagePopupViewCell



@end