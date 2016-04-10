//
//  LanguagePopUpView.m
//  Tortoise
//
//  Created by Namit Nayak on 2/27/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguagePopUpView.h"
#import "Language+CoreDataProperties.h"
#import "Nuance+CoreDataProperties.h"
#import "Provider+CoreDataProperties.h"
#import "LoggedInUserDS.h"
#import "LanguageDataManager.h"
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

@property (nonatomic,strong) NSArray *dataArra;

@property (nonatomic,strong) Language *selectedLanguageDS;

-(IBAction)okButtonTapped:(id)sender;
-(IBAction)cancelButtonTapped:(id)sender;
@end

@implementation LanguagePopUpView

-(IBAction)okButtonTapped:(id)sender{
//     [Utilities addHUDForView:se];
  
    if (![APP_DELEGATE isNetworkAvailable]) {
      
        return;
    }
    if(_selectedLanguageDS == nil){
        if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidCancelButonTappedWithLanguage:)]) {
            [self.delegate languagePopUpViewDidCancelButonTappedWithLanguage:_selectedLanguageDS];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(languagePopUpViewDidOkButonTappedWithLanguage:)]) {
//        [self setDefaultLanguageinDB];
        
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
    
    self.dataArra = [[LanguageDataManager sharedManager] getLanguageArrayFromDB];
    [self.tableView  reloadData];
    self.tableView.hidden = YES;

    [self setUpLanguageView];
    
}

-(void)setUpLanguageView{
    
    
    [self updateLanguageDetailsOnScreen:[[LanguageDataManager sharedManager] getDefaultLanguageObject]];
//    LoggedInUserDS *loggedInUser = [APP_DELEGATE getLoggedInUserData];
//    
//    if(loggedInUser.selectedLanguageDS){
//        
//        [self updateLanguageDetailsOnScreen:loggedInUser.selectedLanguageDS];
//    }else{
////        [APP_DELEGATE setDefaultLanguage];
//        loggedInUser = [APP_DELEGATE getLoggedInUserData];
//        
//        [self updateLanguageDetailsOnScreen:loggedInUser.selectedLanguageDS];
//        
//    }
//    
    
    
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
-(void)updateLanguageDetailsOnScreen:(Language *)languageDS{
    
    self.textImageView.image = [UIImage imageNamed:@"checkbox"];
    
    if(languageDS.nuanceRelationship !=nil && languageDS.nuanceRelationship.allObjects.count >0){
        Nuance *nDS = [[languageDS.nuanceRelationship allObjects] objectAtIndex:0];
        self.speakerImageView.hidden = NO;
        self.languageLabel.text = nDS.lang;
        self.audioImageView.image = [UIImage imageNamed:@"checkbox"];
    }else{
        self.speakerImageView.hidden = YES;
         self.languageLabel.text = languageDS.name;
        self.audioImageView.image = [UIImage imageNamed:@"uncheck"];
    }
   
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
    
    Language * dataStructer;
    
    dataStructer = [_dataArra objectAtIndex:indexPath.row];
    if (dataStructer.nuanceRelationship.allObjects.count > 0) {
        NSLog(@"%@",dataStructer.name);
        
        
        Nuance *nuanceDS = [[dataStructer.nuanceRelationship allObjects] objectAtIndex:0];
        cell.labelLanguage.text = nuanceDS.lang;
        cell.speakerImageView.hidden = NO;
    }else{
        cell.labelLanguage.text = dataStructer.name;
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