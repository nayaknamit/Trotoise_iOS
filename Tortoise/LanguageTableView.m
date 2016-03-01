//
//  LanguageTableView.m
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "LanguageTableView.h"
#import "LanguageDS.h"
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
    
    self.dataArra = [NSMutableArray arrayWithArray: dataArray];
    [self.tableView  reloadData];
    
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
    NSString *ident = @"languageViewTableCell";
    
    
    LanguageTableViewCell *cell = (LanguageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LanguageTableView" owner:self options:nil];
        cell = (LanguageTableViewCell *)[arr objectAtIndex:1];
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
    
    LanguageDS *dataObject = [_dataArra objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(languageTableView:didSelectLanguageData:)]){
        
        [self.delegate languageTableView:self didSelectLanguageData:dataObject];
    }
    
}


@end

@implementation LanguageTableViewCell



@end