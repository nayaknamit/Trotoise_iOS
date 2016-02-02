//
//  LanguageTableView.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *tableView;

@end


@interface LanguageTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *labelLanguage;
@property  (nonatomic,weak) IBOutlet UIImageView *speakerImageView;

@end