//
//  CustomMarkerView.h
//  Tortoise
//
//  Created by Namit Nayak on 2/12/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonumentList;
@interface CustomMarkerView : UIView


@property (nonatomic,weak) IBOutlet UIImageView *placePic;
@property (nonatomic,weak) IBOutlet UILabel * titleLbl;
@property (nonatomic,weak) IBOutlet UILabel *descLbl;
@property (nonatomic,strong)  MonumentList *monumentObj;
@property (nonatomic,weak) IBOutlet UIView *bgView;
-(IBAction)btnTapped:(id)sender;
@end
