//
//  AutoCompleteView.m
//  Tortoise
//
//  Created by Namit Nayak on 3/5/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "AutoCompleteView.h"

@interface AutoCompleteView ()

@property (nonatomic,strong) NSMutableArray *predictionArray;

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end
@implementation AutoCompleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)setUpData:(NSArray *)predictionArray{
    if (_predictionArray ==nil) {
        _predictionArray = [NSMutableArray array];
    }else{
        [_predictionArray removeAllObjects];
    }
    
    _predictionArray = [NSMutableArray arrayWithArray:predictionArray];
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource protocol methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _predictionArray.count;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}// Default is 1 if not implemented

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//NSString *ident = @"hMVTableCell";
static NSString *cellIdentitifer = @"autoCompleteView";
    
//    UITableViewCell *cell;
    
    
    AutoCompleteViewCell *cell = (AutoCompleteViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentitifer];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AutoCompleteView" owner:self options:nil];
        cell = (AutoCompleteViewCell *)[arr objectAtIndex:1];
    }

//    for (GMSAutocompletePrediction *prediction in predictions) {
//        [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
//    }
//    
    GMSAutocompletePrediction *prediction = [_predictionArray objectAtIndex:indexPath.row];
    cell.titleLabel.attributedText =prediction.attributedPrimaryText;
    cell.descLabel.attributedText = prediction.attributedSecondaryText;
  /*  [cell.textLabel setFont:[UIFont TrotoiseFontCondensedRegular:10]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    cell.textLabel.attributedText = prediction.attributedPrimaryText;
    [cell.detailTextLabel setFont:[UIFont TrotoiseFontCondensedRegular:10]];
    [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    [cell.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
    cell.detailTextLabel.attributedText = prediction.attributedSecondaryText;
//    NSLog(@"FullString %@",prediction.attributedFullText);
    */
    return  cell;
}

#pragma mark - UITableViewDataDelegate protocol methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GMSAutocompletePrediction *prediction =[_predictionArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(onAutoCompleteResultSelect:)]) {
        [self.delegate onAutoCompleteResultSelect:prediction];
    }
    
}



@end

@implementation AutoCompleteViewCell



@end