//
//  UIView+DragDrop.m
//
//  Created by Ryan Meisters
//

#import "UIView+DragDrop.h"
#import <objc/runtime.h>

/**
 * A Category on UIView to add drag and drop functionality
 * to a UIView.
 *
 * Note: Uses objective-c runtime API to keep track of drop
 *   views and starting position of the drag
 */

// duration of animation back to starting position
#define RESET_ANIMATION_DURATION .5

#define STRONG_N OBJC_ASSOCIATION_RETAIN_NONATOMIC
#define ASSIGN   OBJC_ASSOCIATION_ASSIGN

//addresses used as keys for associated objects
static char _delegate, _dropViews, _startPos,_isMidHeightSet, _isHovering, _mode, _stageMidPoint, _stageTopPoint,_initialFrame;

/**
 *  Category implementation
 */


typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};
@interface UIView() <UIGestureRecognizerDelegate>
{
   
}

@property (nonatomic) CGPoint initialCenterPoint;
@end
@implementation UIView (DragDrop)



- (void) makeDraggable
{
    [self makeDraggableWithDropViews:nil delegate:nil];

}

- (void) makeDraggableWithDropViews:(NSArray *)views delegate:(id<UIViewDragDropDelegate>)delegate {
    
    //Save pertinent info
    objc_setAssociatedObject(self, &_delegate, delegate, ASSIGN);
    objc_setAssociatedObject(self, &_isHovering, @NO, STRONG_N);
    objc_setAssociatedObject(self, &_mode, @(UIViewDragDropModeNormal), STRONG_N);
    
    [self setDropViews:views];
    
    //add the pan gesture
    [self addPanGesture];
}

#pragma mark - Setters

- (void) setDelegate:(id<UIViewDragDropDelegate>)delegate
{
    objc_setAssociatedObject(self, &_delegate, delegate, ASSIGN);
}

-(void)setStageMidPoint:(CGPoint )stageMidPoint{
    NSDictionary *midPos = @{@"x": @(stageMidPoint.x), @"y": @(stageMidPoint.y)};
    objc_setAssociatedObject(self,&_stageMidPoint,midPos,STRONG_N);
    
}
-(void)setStageTopPoint:(CGPoint )stageTopPoint{
    NSDictionary *topPos = @{@"x": @(stageTopPoint.x), @"y": @(stageTopPoint.y)};
    objc_setAssociatedObject(self,&_stageTopPoint,topPos,STRONG_N);
    
}
-(void)setInitialFramePoint:(CGRect )initialFrame{
    NSDictionary *topPos = @{@"Originx": @(initialFrame.origin.x), @"Originy": @(initialFrame.origin.y),@"SizeWidth":@(initialFrame.size.width),@"Sizeheight":@(initialFrame.size.height)};
    
    objc_setAssociatedObject(self,&_initialFrame,topPos,STRONG_N);
    
}
-(void)setBOOLMidHeightSet:(BOOL)isVal{
    objc_setAssociatedObject(self, &_isMidHeightSet, @(isVal), STRONG_N);
    
}
-(BOOL)getBOOLMidHeight{
    
    return [objc_getAssociatedObject(self, &_isMidHeightSet) boolValue];
}
- (void) setDragMode:(UIViewDragDropMode)mode
{
    objc_setAssociatedObject(self, &_mode, @(mode), STRONG_N);
}

- (void) setDropViews:(NSArray*)views
{
    objc_setAssociatedObject(self, &_dropViews, views, STRONG_N);
}

#pragma mark - Private API

- (void) addPanGesture
{
    UIPanGestureRecognizer *rec;
    rec = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                  action: @selector(dragging:)];
    [self addGestureRecognizer:rec];
    rec.delegate = self;
                [self setBOOLMidHeightSet:NO];
}

// Handle UIPanGestureRecognizer events

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    CGFloat hegith = [UIScreen mainScreen].bounds.size.height/2;
//    return (self.frame.origin.y == hegith)?NO:YES;
//}

    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    static POINTMOVEDIRECTION pointMoveDirection = INITAL_POINT_DIRECTION;


- (void) dragging:(UIPanGestureRecognizer *)recognizer
{
    //get pertinent info
    id delegate        = objc_getAssociatedObject(self, &_delegate);
   // NSArray *dropViews = objc_getAssociatedObject(self, &_dropViews);
    UIViewDragDropMode mode = [objc_getAssociatedObject(self, &_mode) integerValue];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // tell the delegate we're being dragged
        if ([delegate respondsToSelector:@selector(draggingDidBeginForView:)]) {
            [delegate draggingDidBeginForView:self];
        }
        
        //save the starting position of the view
        NSDictionary *startPos = @{@"x": @(self.center.x), @"y": @(self.center.y)};
        
        objc_setAssociatedObject(self, &_startPos, startPos, STRONG_N);
        
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        
        BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
        
        if (isVerticalGesture) {
            if (velocity.y > 0) {
                direction = UIPanGestureRecognizerDirectionDown;
            } else {
                direction = UIPanGestureRecognizerDirectionUp;
            }
        }
    }
    
    //process the drag
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        
        CGPoint trans = [recognizer translationInView:self.superview];
        CGPoint currentPoint = [recognizer locationInView:self];
        
        CGFloat newX, newY;
        
        newX = self.center.x;
        newY = self.center.y;
        
//        if (mode == UIViewDragDropModeNormal || mode == UIViewDragDropModeRestrictY) newY += trans.y;
//        if (mode == UIViewDragDropModeNormal || mode == UIViewDragDropModeRestrictX) newX += trans.x;
//        
        
        NSDictionary *stageTopPos = objc_getAssociatedObject(self, &_stageTopPoint);
        
        
        CGFloat x2 = [stageTopPos[@"x"] floatValue];
        CGFloat y2 = [stageTopPos[@"y"] floatValue];
        CGPoint stageTopPoint = CGPointMake(x2, y2);
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
            CGRect oldFrame  = self.frame;
            
            if (direction == UIPanGestureRecognizerDirectionDown) {
                NSDictionary *initialFrm = objc_getAssociatedObject(self, &_initialFrame);
                

                [self setBOOLMidHeightSet:NO];
                [self updateConstraintsIfNeeded];
             [delegate sendUpdatedHeightForTableView:[initialFrm[@"Sizeheight"] floatValue] withPointDirection:INITAL_POINT_DIRECTION];
            
            }else if(direction == UIPanGestureRecognizerDirectionUp){
                
                
                CGFloat hegith = [UIScreen mainScreen].bounds.size.height/2;
                NSLog(@"BOOL MID HEIGHT %d",[self getBOOLMidHeight]);
               
                if(self.frame.origin.y > hegith  && recognizer.state != UIGestureRecognizerStateChanged && ![self getBOOLMidHeight]){
                    self.frame = CGRectMake(oldFrame.origin.x, hegith, oldFrame.size.width, ([UIScreen mainScreen].bounds.size.height - currentPoint.y));
                    if([delegate respondsToSelector:@selector(sendUpdatedHeightForTableView:withPointDirection:)]){
            
                        [delegate sendUpdatedHeightForTableView:hegith withPointDirection:MIDWAY_POINT_DIRECTION];
                    }
                    
                    [self setBOOLMidHeightSet:YES];

                
                }else if(self.frame.origin.y == hegith && recognizer.state != UIGestureRecognizerStateChanged && [self getBOOLMidHeight]){
                    self.frame = CGRectMake(oldFrame.origin.x, stageTopPoint.y, oldFrame.size.width, ([UIScreen mainScreen].bounds.size.height));
                    [self setBOOLMidHeightSet:NO];
                    if([delegate respondsToSelector:@selector(draggingDidEndViewFrameSet:)]){
                        [delegate draggingDidEndViewFrameSet:self.frame];
                        
                    }
                    if([delegate respondsToSelector:@selector(sendUpdatedHeightForTableView:withPointDirection:)]){
                        
                        [delegate sendUpdatedHeightForTableView:([UIScreen mainScreen].bounds.size.height - stageTopPoint.y) withPointDirection:TOP_WAY_POINT_DIRECTION];
                    }
                }
            
            }
            

            
            
        } completion:nil];
        
        
        //reset the gesture's translation
        [recognizer setTranslation:CGPointZero inView:self.superview];
    }
    
    // if the drag is over, check if we were dropped on a dropview
    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        BOOL goBack = NO;
        if ( [delegate respondsToSelector:@selector(viewShouldReturnToStartingPosition:)] ) {
            [delegate viewShouldReturnToStartingPosition:self];
        }
        
//
    }
}

-(void)OnScrollMoreTapWithCurrentPoint:(CGPoint)currentPoint {
    id delegate        = objc_getAssociatedObject(self, &_delegate);

    CGFloat hegith = [UIScreen mainScreen].bounds.size.height/2;

//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    self.frame = CGRectMake(self.frame.origin.x, hegith, self.frame.size.width, ([UIScreen mainScreen].bounds.size.height - currentPoint.y));
    if([delegate respondsToSelector:@selector(sendUpdatedHeightForTableView:withPointDirection:)]){
        
        [delegate sendUpdatedHeightForTableView:hegith withPointDirection:MIDWAY_POINT_DIRECTION];
    }
    
} completion:^(BOOL finished) {
    [self setBOOLMidHeightSet:YES];

}];
    
  
    

}

@end
