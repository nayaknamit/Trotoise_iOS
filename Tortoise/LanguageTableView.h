//
//  LanguageTableView.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LanguageDS;
@protocol LanguageTableViewDelegate;
@interface LanguageTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;

@property (nonatomic,assign) id<LanguageTableViewDelegate> delegate;
-(void)setUpLanguageData:(NSArray *)dataArray;
@end


@interface LanguageTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *labelLanguage;
@property  (nonatomic,weak) IBOutlet UIImageView *speakerImageView;

@end

@protocol LanguageTableViewDelegate <NSObject>

@optional

-(void)languageTableView:(LanguageTableView *)languageTableView didSelectLanguageData:(LanguageDS *)data;

@end