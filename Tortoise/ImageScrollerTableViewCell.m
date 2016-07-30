//
//  ImageScrollerTableViewCell.m
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "ImageScrollerTableViewCell.h"
#import "MonumentList+CoreDataProperties.h"
#import "LanguageDS.h"
#import "MonumentListDS.h"
#import "FullScreenViewController.h"
#import "SpeechTranslator.h"
#import "Language+CoreDataProperties.h"
#import "ImageAttribute+CoreDataProperties.h"
#import "Nuance+CoreDataProperties.h"
#import <FCFileManager.h>
#import "Provider+CoreDataProperties.h"
#import "Voice+CoreDataProperties.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MonumentLanguageDetail+CoreDataProperties.h"
#import "CityMonument+CoreDataProperties.h"
#import "OfflineImageOperations.h"
@interface ImageScrollerTableViewCell(){
    BOOL animate;
    BOOL animationCompleting;
    BOOL animationPending;
   
}
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong)  SpeechTranslator *translatorSpeech;
@end
@implementation ImageScrollerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _isSpeakerPlaying = NO;
}

-(void)initSpechTranslate {
    if (_translatorSpeech==nil) {
        
        
        _translatorSpeech = [SpeechTranslator sharedInstance];
//        _translatorSpeech = [[SpeechTranslator alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTranslatorSpeech) name:@"NOTIFY_STOP_AUDIO" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStopIcon) name:@"TRANSACTION_RECIEVED" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStopErrorIcon) name:@"TRANSACTION_RECIEVED_ERROR" object:nil];
        
        
        
    }

}
-(void)changeStopIcon{
    [self stopLogoSpin];
//    [_speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
    
}
-(void)changeStopErrorIcon{
    //    [_speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
    [_speakerBtn setImage:[UIImage imageNamed:@"playSound.png"] forState:UIControlStateNormal];
    
    [self makeToast:@"Issue while connecting server. Please try later"
                                          duration:1.5
                                          position:CSToastPositionTop];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) spinLogoWithOptions: (UIViewAnimationOptions) options {
    NSTimeInterval fullSpinInterval = 2.0f;
  __weak ImageScrollerTableViewCell *weakSelf = self;
    [UIView animateWithDuration: fullSpinInterval / 4.0f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         weakSelf.speakerBtn.transform = CGAffineTransformRotate(weakSelf.speakerBtn.transform, M_PI);
                     }
                     completion:^(BOOL finished) {
                         // if flag still set, keep spinning with constant speed
                         if (animate) {
                             NSLog(@"1");
                             [weakSelf spinLogoWithOptions: UIViewAnimationOptionCurveLinear];
                         } else if (animationPending) {
                             // another spin has been requested, so start it right back up!
                             animationPending = NO;
                             animate = YES;
                             [weakSelf spinLogoWithOptions: UIViewAnimationOptionBeginFromCurrentState];
                                                          NSLog(@"2");
                         } else if ((options & UIViewAnimationOptionCurveEaseOut) == 0) {
                             // one last spin, with deceleration
                             [weakSelf spinLogoWithOptions: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut];
                                                          NSLog(@"3");
                         } else {
                             animationCompleting = NO;
                                                          NSLog(@"4");
                             [weakSelf.speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
                             [_speakerBtn setUserInteractionEnabled:YES];

                         }
                     }];
}

- (void) stopLogoSpin {
    animate = NO;
    animationCompleting = YES;
  
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

//- (void) spinLogoWithOptions: (UIViewAnimationOptions) options {
//    __weak ImageScrollerTableViewCell *weakSelf = self;
//
//    NSTimeInterval fullSpinInterval = 2.0f;
//    [UIView animateWithDuration: fullSpinInterval / 4.0f
//                          delay: 0.0f
//                        options: options
//                     animations: ^{
//                         weakSelf.speakerBtn.transform = CGAffineTransformRotate(self.speakerBtn.transform, M_PI);
//                     }
//                     completion:^(BOOL finished) {
//                         // if flag still set, keep spinning with constant speed
//                         if (animate) {
//                             [weakSelf spinLogoWithOptions: UIViewAnimationOptionCurveLinear];
//                         } else if (animationPending) {
//                             // another spin has been requested, so start it right back up!
//                             animationPending = NO;
//                             animate = NO;
//                             [weakSelf spinLogoWithOptions: UIViewAnimationOptionBeginFromCurrentState];
//                         } else if ((options & UIViewAnimationOptionCurveEaseOut) == 0) {
//                             // one last spin, with deceleration
//                             [weakSelf spinLogoWithOptions: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut];
//                         } else {
//                             animationCompleting = NO;
//                             [weakSelf.speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
//
//                         }
//                     }];
//    
//    
//}
//
//- (void) stopLogoSpin {
////    if (!animate) {
////        animate = YES;
////         [_speakerBtn setImage:[UIImage imageNamed:@"ic_action_cached.png"] forState:UIControlStateNormal];
////        [self spinLogoWithOptions: UIViewAnimationOptionCurveEaseIn];
//////        _speakerBtn.enabled =NO;
////    }
//////    _speakerBtn.enabled =YES;
////    animate = NO;
////    animationCompleting = YES;
////    [_speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
//    
//}
//
//- (void) startLogoSpin {
////    if (!animate) {
////        if (animationCompleting) {
////            animationPending = YES;
////        } else {
////            animate = YES;
//////            _speakerBtn.enabled = YES;
//////             [_speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
////            [self spinLogoWithOptions: UIViewAnimationOptionCurveEaseIn];
////        }
////    
////    }
//    
//    [_speakerBtn setImage:[UIImage imageNamed:@"ic_speaker_stop.png"] forState:UIControlStateNormal];
//}
-(void)setSpeakerbtnAttr:(BOOL)isAttr {
    if (isAttr) {
        
    
    self.speakerBtn.alpha = 1.0;
    self.speakerBtn.enabled = true;
    
}else {
    self.speakerBtn.alpha = 0.6;
    self.speakerBtn.enabled = false;
}

}
-(void)checkButtonForMp3 {
if([_selectedLanguage.nuanceRelationship allObjects].count!=0){
  
    if (_isOfflineMode) {
//        OfflineImageOperations *op = [[OfflineImageOperations alloc] init];
//        
//        CityMonument *city = [[op getCityWithCityName:_cityName] lastObject];
//        if (city!=nil) {
//            
//            NSString * filevoicePath  = city.voiceBasePath;
//            filevoicePath = [NSString stringWithFormat:@""];
//        }
        NSArray *nuanceArr = [_selectedLanguage.nuanceRelationship allObjects];
        
        Nuance *nuance = [nuanceArr objectAtIndex:0];
        
        NSString *filePath = [NSString stringWithFormat:@"/OfflineData/%@_%@.mp3",self.monumentDetailObj.name,nuance.code4];
        filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([FCFileManager existsItemAtPath:filePath]) {
        [self setSpeakerbtnAttr:YES];
    }else {
        [self setSpeakerbtnAttr:NO];
    }
    
}else {
 
    [self setSpeakerbtnAttr:YES];
  
}
    
}else {
    [self setSpeakerbtnAttr:NO];

}
}
-(void)playAudioOffline{
    
    NSArray *aa  =[_monumentDetailObj.voiceAttributes allObjects];
    
    Voice *voiceDS = [aa objectAtIndex:0];
    if ([FCFileManager existsItemAtPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:voiceDS.path]]]) {
        NSString *testPathTemp = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"/OfflineData/%@",[Utilities getFileNameFromURL:voiceDS.path]]];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:testPathTemp]
                                                         error:nil];
        [_player play];
        [self stopLogoSpin];
    }

    
}
-(void)stopOfflineAudio{
    if (_player) {
        [_player stop];
        _player = nil;
    }
}
-(IBAction)speakerBtnTapped:(id)sender{
  
    if (!_isOfflineMode) {
        [self initSpechTranslate];
    }
    
    if (!_isSpeakerPlaying) {
        [self.speakerBtn setImage:[UIImage imageNamed:@"ic_action_cached.png"] forState:UIControlStateNormal];
        [self startLogoSpin];
        
        if (_isOfflineMode) {
            _isSpeakerPlaying = YES;

            [self playAudioOffline];
        }else {
            if([_selectedLanguage.nuanceRelationship allObjects].count!=0){
                Nuance *nuanceDS = [[_selectedLanguage.nuanceRelationship allObjects] objectAtIndex:0];
                Provider *providerDS = (Provider *)[[nuanceDS.provider allObjects] objectAtIndex:0];
                [_translatorSpeech initiateTransistionForText:self.monumentDetailObj.desc withLanguageCode:nuanceDS.code6 withVoiceName:providerDS.voice];
                [_speakerBtn setUserInteractionEnabled:NO];
                _isSpeakerPlaying = YES;
                _speakerBtn.tag =100;
            }else{
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Trotoise"
                                                                   message:@"Audio facility is not avaialable for current selected language."
                                                                  delegate:nil cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
                [_speakerBtn setImage:[UIImage imageNamed:@"playSound.png"] forState:UIControlStateNormal];
                _speakerBtn.tag =101;
                _isSpeakerPlaying = NO;
                [_speakerBtn setUserInteractionEnabled:YES];
                [self startLogoSpin];
                [self stopLogoSpin];
            }
        }
        
        
    }else{
        //[self startLogoSpin];
        //[self stopLogoSpin];
        [_speakerBtn setImage:[UIImage imageNamed:@"playSound.png"] forState:UIControlStateNormal];

        _speakerBtn.tag =100;
        _isSpeakerPlaying = NO;
        if (_isOfflineMode) {
            [self stopOfflineAudio];
        }else {
        [self stopTranslatorSpeech];    
        }
        
    }
}
-(void)stopTranslatorSpeech{
    if (_translatorSpeech){
        [_translatorSpeech stopAudio];
//        translatorSpeech = nil;
//        [SpeechTranslator setSharedInstance:nil];
//        translatorSpeech = nil;

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
    
    [self checkButtonForMp3];
    
    self.imageViews = [NSMutableArray array];
    if (_isOfflineMode) {
        
        if ([_selectedLanguage.id integerValue]== LANGUAGE_DEFAULT_ID) {
              self.placeLabel.text = _monumentDetailObj.name;
            
            
        }else {
            
            NSArray *monDesArr = [_monumentDetailObj.multiLocaleMonument array];
            
            [monDesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                MonumentLanguageDetail *objM = (MonumentLanguageDetail *)obj;
                if ([objM.locale isEqualToString:_selectedLanguage.transCode]) {
                     self.placeLabel.text  = objM.name;
                    *stop = YES;
                    
                }
                
            }];
            
        }
    }else{
        self.placeLabel.text = self.monumentDetailObj.name;
    }
    
    

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
            if (_isOfflineMode) {
                [Utilities hideHUDForView:imageView];

                if ([FCFileManager existsItemAtPath:[NSString stringWithFormat:@"/OfflineData/img_attr_%@",[Utilities getFileNameFromURL:imageDS.imageUrl]]]) {
                    NSString *testPathTemp = [FCFileManager pathForDocumentsDirectoryWithPath:[NSString stringWithFormat:@"/OfflineData/img_attr_%@",[Utilities getFileNameFromURL:imageDS.imageUrl]]];
                    UIImage *theImage = [UIImage imageWithContentsOfFile:testPathTemp];
                    imageView.image = theImage;
                    
                    
                }

            }else{
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
                
            }
            
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
            fullScreenVC.isOffline = _isOfflineMode;
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
