//
//  LanguageTableView.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguageTableView.h"

@interface LanguageTableView ()

@property (nonatomic,strong) NSMutableArray *dataArra;
@end
@implementation LanguageTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setUpLanguageData:(NSArray *)dataArray{
    
    
    
}



#pragma mark -
#pragma TableView 
#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArra.count;
    
}// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"languageViewTableCell";
    
    
    LanguageTableViewCell *cell = (LanguageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguageTableView" owner:self options:nil];
        cell = (LanguageTableViewCell *)[arr objectAtIndex:1];
    }
    
    NSDictionary *duck = [_dataArra objectAtIndex:indexPath.section];
    cell.labelLanguage.text = @"English(Australia)";
    
    
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112.0f;
}
@end

@implementation LanguageTableViewCell



@end