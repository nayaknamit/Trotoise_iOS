//
//  UIView+DragDrop.h
//
//  Created by Ryan Meisters.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM( NSInteger, UIViewDragDropMode) {
    UIViewDragDropModeNormal,
    UIViewDragDropModeRestrictY,
    UIViewDragDropModeRestrictX
};
typedef NS_ENUM(NSUInteger,POINTMOVEDIRECTION) {
    INITAL_POINT_DIRECTION,
    MIDWAY_POINT_DIRECTION,
    TOP_WAY_POINT_DIRECTION
};
@protocol UIViewDragDropDelegate;

/**
 *  A Category that adds Drag and drop functionality to UIView
 */
@interface UIView (DragDrop)

/**
 *  Set up drag+drop
 *  @params
 *    views: NSArray of drop views
 *    delegate: id delegate conforming to UIViewDragDropDelegave protocol
 */
- (void) makeDraggableWithDropViews:(NSArray *)views delegate:(id<UIViewDragDropDelegate>)delegate;

- (void) makeDraggable;

- (void) setDelegate:(id<UIViewDragDropDelegate>)delegate;
-(void)setInitialFramePoint:(CGRect )initialFrame;
- (void) setDragMode:(UIViewDragDropMode)mode;
-(void)setInitialFramePoint:(CGRect )initialFrame;
- (void) setDropViews:(NSArray*)views;
-(void)setStageTopPoint:(CGPoint )stageTopPoint;
-(void)setStageMidPoint:(CGPoint)stageMidPoint;
//-(void)setStageTopPoint:(CGPoint)point;
//-(CGPoint)getStageMidPoint;
//-(CGPoint)getStageTopPoint;
-(void)setBOOLMidHeightSet:(BOOL)isVal;
-(BOOL)getBOOLMidHeight;
@end

/**
 *  The UIViewDragDropDelegate Protocol
 */
@protocol UIViewDragDropDelegate <NSObject>

- (void) view:(UIView *)view wasDroppedOnDropView:(UIView *)drop;

@optional

- (BOOL) viewShouldReturnToStartingPosition:(UIView*)view;

- (void) draggingDidBeginForView:(UIView*)view;
- (void) draggingDidEndWithoutDropForView:(UIView*)view;
-(void)draggingDidEndViewFrameSet:(CGRect)viewFrame;
-(void)sendUpdatedHeightForTableView:(CGFloat)height withPointDirection:(POINTMOVEDIRECTION)direction;
- (void) view:(UIView *)view didHoverOverDropView:(UIView *)dropView;
- (void) view:(UIView *)view didUnhoverOverDropView:(UIView *)dropView;

@end