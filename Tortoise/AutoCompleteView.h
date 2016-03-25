//
//  AutoCompleteView.h
//  Tortoise
//
//  Created by Namit Nayak on 3/5/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps.h>

@protocol AutoCompleteViewDelegate;
@interface AutoCompleteView : UIView <UITableViewDataSource,UITableViewDelegate>

-(void)setUpData:(NSArray *)predictionArray;
@property (nonatomic,weak) id <AutoCompleteViewDelegate>delegate;
@end

@interface AutoCompleteViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *descLabel;

@end

@protocol AutoCompleteViewDelegate <NSObject>

@optional

-(void)onAutoCompleteResultSelect:(GMSAutocompletePrediction *)prediction;

@end