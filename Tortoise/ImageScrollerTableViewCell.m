//
//  ImageScrollerTableViewCell.m
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "ImageScrollerTableViewCell.h"
#import "MonumentList+CoreDataProperties.h"
#import "LanguageDS.h"
#import "MonumentListDS.h"
#import "FullScreenViewController.h"
#import "SpeechTranslator.h"
#import "Language+CoreDataProperties.h"
#import "ImageAttribute+CoreDataProperties.h"
#import "Nuance+CoreDataProperties.h"
#import "Provider+CoreDataProperties.h"
@interface ImageScrollerTableViewCell(){
    BOOL animate;
    BOOL animationCompleting;
    BOOL animationPending;
    SpeechTranslator *translatorSpeech;
}
@end
@implementation ImageScrollerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _isSpeakerPlaying = NO;
}

-(void)initSpechTranslate {
    if (translatorSpeech==nil) {
        
        
        translatorSpeech = [SpeechTranslator sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTranslatorSpeech) name:@"NOTIFY_STOP_AUDIO" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStopIcon) name:@"TRANSACTION_RECIEVED" object:nil];
        
    }

}
-(void)changeStopIcon{
    [self stopLogoSpin];
    [_speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) spinLogoWithOptions: (UIViewAnimationOptions) options {
    NSTimeInterval fullSpinInterval = 1.0f;
    [UIView animateWithDuration: fullSpinInterval / 4.0f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.speakerBtn.transform = CGAffineTransformRotate(self.speakerBtn.transform, M_PI);
                     }
                     completion:^(BOOL finished) {
                         // if flag still set, keep spinning with constant speed
                         if (animate) {
                             [self spinLogoWithOptions: UIViewAnimationOptionCurveLinear];
                         } else if (animationPending) {
                             // another spin has been requested, so start it right back up!
                             animationPending = NO;
                             animate = YES;
                             [self spinLogoWithOptions: UIViewAnimationOptionBeginFromCurrentState];
                         } else if ((options & UIViewAnimationOptionCurveEaseOut) == 0) {
                             // one last spin, with deceleration
                             [self spinLogoWithOptions: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut];
                         } else {
                             animationCompleting = NO;
                         }
                     }];
}

- (void) stopLogoSpin {
    animate = NO;
    animationCompleting = YES;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFY_STOP_AUDIO" object:nil];
}

- (void) startLogoSpin {
    if (!animate) {
        if (animationCompleting) {
            animationPending = YES;
        } else {
            animate = YES;
            [self spinLogoWithOptions: UIViewAnimationOptionCurveEaseIn];
        }
    }
}

-(IBAction)speakerBtnTapped:(id)sender{
    
       [self initSpechTranslate];
    if (!_isSpeakerPlaying) {
        [_speakerBtn setImage:[UIImage imageNamed:@"ic_action_cached.png"] forState:UIControlStateNormal];
        [self startLogoSpin];
        
        if([_selectedLanguage.nuanceRelationship allObjects].count!=0){
            Nuance *nuanceDS = [[_selectedLanguage.nuanceRelationship allObjects] objectAtIndex:0];
            Provider *providerDS = (Provider *)[[nuanceDS.provider allObjects] objectAtIndex:0];
            [translatorSpeech initiateTransistionForText:self.monumentDetailObj.desc withLanguageCode:nuanceDS.code6 withVoiceName:providerDS.voice];
            
        _isSpeakerPlaying = YES;
        }else{
              UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Trotoise"
                                                               message:@"Audio facility is not avaialable for current selected language."
                                                              delegate:nil cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
            [_speakerBtn setImage:[UIImage imageNamed:@"playSound.png"] forState:UIControlStateNormal];
            
            _isSpeakerPlaying = NO;
            [self startLogoSpin];
            [self stopLogoSpin];
        }
        
    }else{
        //[self startLogoSpin];
        //[self stopLogoSpin];
        [_speakerBtn setImage:[UIImage imageNamed:@"playSound.png"] forState:UIControlStateNormal];

        
        _isSpeakerPlaying = NO;
        [self stopTranslatorSpeech];
    }
}
-(void)stopTranslatorSpeech{
    if (translatorSpeech){
        [translatorSpeech stopAudio];
        [SpeechTranslator setSharedInstance:nil];
        translatorSpeech = nil;

    }
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(IBAction)mapDirectionButtonTapped:(id)sender{
    
    double lat = [self.monumentDetailObj.latitude doubleValue];
    double lon = [self.monumentDetailObj.longitude doubleValue];
    
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
    NSString *str = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f&zoom=12&views=traffic",self.monumentDetailObj.name,lat,lon];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url] ;
        } else {
//            NSString *addressOnMap = @"cupertino";  //place name
            NSString* addr = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f",lat,lon];
            NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:url];
                NSLog(@"Can't use comgooglemaps://");
        }
    
    
}
-(void)setUpScrollViewImages{
    self.imageViews = [NSMutableArray array];

    self.placeLabel.text = self.monumentDetailObj.name;
    

    __block CGFloat scrollViewWidth = [UIScreen mainScreen].bounds.size.width+10;
    __block CGFloat scrollViewHeight = 249;
    NSArray *imageSetArray =  [self.monumentDetailObj.imageAttributes allObjects];
    if([imageSetArray count]>0){
        
//        __weak ImageScrollerTableViewCell *weakSelf = self;
       
        if (imageSetArray.count>1) {
            self.pageControl.hidden = NO;
        }else{
            self.pageControl.hidden = YES;
            
        }
        UIGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageScrollerTapGesture:)];
        [self.imageScrollerView addGestureRecognizer:tapGestureRecongnizer];

        
        [imageSetArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ImageAttribute * imageDS = (ImageAttribute *)obj;
            
            
            CGRect frame;
            frame.origin.x = self.imageScrollerView.frame.size.width * idx;
            frame.size = self.imageScrollerView.frame.size;
            self.imageScrollerView.pagingEnabled = YES;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth *idx, 0, scrollViewWidth, scrollViewHeight)];
            
            imageView.tag = 100+idx;
            
            
            imageView.translatesAutoresizingMaskIntoConstraints = YES;
            imageView.autoresizesSubviews = YES;
            
            [Utilities addHUDForView:imageView];
           
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            if (![APP_DELEGATE isNetworkAvailable]) {
                [Utilities hideHUDForView:imageView];
                UIImage *image =[UIImage imageNamed:@"splash_logo.png"];
                imageView.image =image;
                imageView.frame = CGRectMake(self.imageScrollerView.frame.size.width/2, self.imageScrollerView.frame.size.height/2, 100,100 );
                imageView.alpha = 0.5;
                
                [self.imageScrollerView addSubview:imageView];
                return ;
                
            }
            [manager downloadImageWithURL: [NSURL URLWithString:imageDS.imageUrl]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                 if (image)
                 {
                     imageView.image = image;
                     [Utilities hideHUDForView:imageView];
                    

                     // do something with image
                 }else {
                     [Utilities hideHUDForView:imageView];
                     
                     imageView.image = [UIImage imageNamed:@"splash_logo.png"];
                     imageView.alpha = 0.5;
                 }
             }];
            
            [self.imageScrollerView addSubview:imageView];
            //            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageViews addObject:imageView];
        }];
        
        
        
        self.imageScrollerView.contentSize = CGSizeMake(scrollViewWidth * [imageSetArray count], self.imageScrollerView.frame.size.height);
        
        
        self.imageScrollerView.delegate = (id)self;
        
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = [imageSetArray count];
        
    }
    
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    
//    return YES;
//}
-(void)imageScrollerTapGesture:(UIGestureRecognizer*)recognizer{
    
  
//
//    NSLog(@"%@",imageDS.imageUrl);
    CGPoint location = [recognizer locationInView:self.imageScrollerView];
    for (UIImageView *imageView in self.imageViews) {
        if (CGRectContainsPoint(imageView.frame, location)) {
            // here is the imageView being tapped
            NSLog(@"%ld",(long)imageView.tag);
            
            
            NSInteger index = imageView.tag-100;
            NSArray *imageSetArray = [self.monumentDetailObj.imageAttributes allObjects];
            
            ImageAttribute * imageDS = (ImageAttribute *)[imageSetArray objectAtIndex:index];
//        FullScreenViewController *fullScreenVC = []
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FullScreenViewController *fullScreenVC = [storyBoard instantiateViewControllerWithIdentifier:@"FullScreenViewController"];
            
            fullScreenVC.imageUrl = imageDS.imageUrl;
            if ([self.delegate respondsToSelector:@selector(parentViewControllerForFullScreenManager)]) {
                [[self.delegate parentViewControllerForFullScreenManager].navigationController presentViewController:fullScreenVC animated:YES completion:nil];
                
            }
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}





- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    
//    CGFloat pageWidth = self.view.frame.size.width;
//    int page = floor((self.imageScrollerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.pageControl.currentPage = page;
//    pageControlBeingUsed = NO;
//    
    
}
- (IBAction)changePage {
    // Update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.imageScrollerView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.imageScrollerView.frame.size;
    [self.imageScrollerView scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
    // value changing. If we don't do this, a noticeable "flashing" occurs
    // as the the scroll delegate will temporarily switch back the page
    // number.
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
    CGFloat pageWidth = self.imageScrollerView.frame.size.width +4;
    int page = floor((self.imageScrollerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    //    NSNumber* currentIndex = [NSNumber numberWithInt:round(scrollView.contentOffset.x / pageWidth)];
    
    //Then just update your scrollviews offset with
    
    
    //    [scrollView setContentOffset:CGPointMake([currentIndex intValue] * pageWidth, 0) animated:YES];
}



@end
