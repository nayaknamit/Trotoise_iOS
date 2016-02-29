//
//  CustomMarkerView.h
//  Tortoise
//
//  Created by Namit Nayak on 2/12/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomMarkerViewDelegate;

@class MonumentListDS;
@interface CustomMarkerView : UIView


@property (nonatomic,weak) IBOutlet UIImageView *placePic;
@property (nonatomic,weak) IBOutlet UILabel * titleLbl;
@property (nonatomic,weak) IBOutlet UILabel *descLbl;
@property (nonatomic,strong)  MonumentListDS *monumentObj;
@property (nonatomic,weak) id<CustomMarkerViewDelegate> delegate;
@property (nonatomic,weak) IBOutlet UIView *bgView;
-(IBAction)btnTapped:(id)sender;
@end
@protocol CustomMarkerViewDelegate <NSObject>
@optional

-(void)customMarkerViewButonTappedWithMonumentObject:(MonumentListDS*)monumentObj;

@end