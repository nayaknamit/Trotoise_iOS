//
//  ImageScrollerTableViewCell.m
//  Tortoise
//
//  Created by Namit Nayak on 2/13/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "ImageScrollerTableViewCell.h"
#import "MonumentListDS.h"
#import "LanguageDS.h"
#import "FullScreenViewController.h"
#import "SpeechTranslator.h"
@implementation ImageScrollerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _isSpeakerPlaying = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)speakerBtnTapped:(id)sender{
    //    [[SpeechTranslator sharedInstance] speakString:self.monumentDetailObj.desc withVoice:@"" delegate:<#(id<SKTransactionDelegate>)#> ]
    
    LanguageDS *languageDS = [APP_DELEGATE getLanguage];
    if (!_isSpeakerPlaying) {
        if([languageDS.nuanceRelationship allObjects].count!=0){
            NuanceDS *nuanceDS = [[languageDS.nuanceRelationship allObjects] objectAtIndex:0];
            ProviderDS *providerDS = [[nuanceDS.provider allObjects] objectAtIndex:0];
            [[SpeechTranslator sharedInstance] initiateTransistionForText:self.monumentDetailObj.desc withLanguageCode:nuanceDS.code6 withVoiceName:providerDS.voice];
            //        [[SpeechTranslator sharedInstance] initiateTransistionForText:self.monumentDetailObj.desc withLanguageCode: withVoiceName:providerDS.voice];
            
        _isSpeakerPlaying = YES;
        }else{
            _isSpeakerPlaying = NO;
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Trotoise"
                                                               message:@"Audio facility is not avaialable for current selected language."
                                                              delegate:nil cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
    }else{
        _isSpeakerPlaying = NO;
        [[SpeechTranslator sharedInstance] stopAudio];
    }
    
}
-(IBAction)mapDirectionButtonTapped:(id)sender{
    
    double lat = [self.monumentDetailObj.latitude doubleValue];
    double lon = [self.monumentDetailObj.longitude doubleValue];
    
    //    if ([[UIApplication sharedApplication] canOpenURL:
    //         [NSURL URLWithString:@"comgooglemaps://"]]) {
    NSString *str = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f&zoom=12&views=traffic",self.monumentDetailObj.name,lat,lon];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url] ;
    //    } else {
    //        NSLog(@"Can't use comgooglemaps://");
    //    }
    
    
}
-(void)setUpScrollViewImages{
    self.imageViews = [NSMutableArray array];

    self.placeLabel.text = self.monumentDetailObj.name;
    
    //self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
//    self.mediaFocusManager.delegate = self;
//    self.mediaFocusManager.zoomEnabled = YES;
    //    [self.mediaFocusManager ]
//    self.mediaFocusManager.elasticAnimation = YES;
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
            ImageAttributeDS * imageDS = (ImageAttributeDS *)obj;
            
            
            CGRect frame;
            frame.origin.x = self.imageScrollerView.frame.size.width * idx;
            frame.size = self.imageScrollerView.frame.size;
            self.imageScrollerView.pagingEnabled = YES;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWidth *idx, 0, scrollViewWidth, scrollViewHeight)];
            
            imageView.tag = 100+idx;
            
            
            imageView.translatesAutoresizingMaskIntoConstraints = YES;
            imageView.autoresizesSubviews = YES;
            [Utilities addHUDForView:imageView];
//            UITapGestureRecognizer *tapGestuerRecognize = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(imageScrollerTapGesture:)];
//            tapGestuerRecognize.delegate = self;
//            [tapGestuerRecognize setNumberOfTapsRequired:1.0];
//            [tapGestuerRecognize setNumberOfTouchesRequired:1.0];
//            tapGestuerRecognize.cancelsTouchesInView = NO;
//             [imageView addGestureRecognizer:tapGestuerRecognize];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            [manager downloadImageWithURL: [NSURL URLWithString:imageDS.imageUrl]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
             {
                 if (image)
                 {
                     imageView.image = image;
                     [Utilities hideHUDForView:imageView];
                    

                     // do something with image
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
            NSArray *imageSetArray =  [self.monumentDetailObj.imageAttributes allObjects];
            ImageAttributeDS * imageDS = (ImageAttributeDS *)[imageSetArray objectAtIndex:index];
//        FullScreenViewController *fullScreenVC = []
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FullScreenViewController *fullScreenVC = [storyBoard instantiateViewControllerWithIdentifier:@"FullScreenViewController"];
            
            fullScreenVC.imageUrl = imageDS.imageUrl;
            [[self.delegate parentViewControllerForMediaFocusManager].navigationController presentViewController:fullScreenVC animated:YES completion:nil];
            
        }
    }
}
#pragma mark - ASMediaFocusDelegate
// Returns the view controller in which the focus controller is going to be added.
// This can be any view controller, full screen or not.
/*- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager
{
  
    if ([self.delegate respondsToSelector:@selector( mediaFocusManagerWillAppearForDelegate)]) {
        
        [self.delegate mediaFocusManagerWillAppearForDelegate];
        
    }
 
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager
{
 
    [self.imageScrollerView updateConstraintsIfNeeded];
    NSArray *childArra = [self.imageScrollerView subviews];
    [childArra  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImageView class]]){
            UIImageView *img = (UIImageView *)obj;
            __block CGFloat scrollViewWidth = self.contentView.bounds.size.width;
            __block CGFloat scrollViewHeight = 201;
            img.frame  = CGRectMake(scrollViewWidth*idx, 0,scrollViewWidth, scrollViewHeight);
            img.contentMode = UIViewContentModeScaleAspectFill;
        }
        
    }];
    
    if([self.delegate respondsToSelector:@selector(mediaFocusManagerWillDisappear)]){
        [self.delegate mediaFocusManagerWillDisappear];
    }
    
}
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    if ([self.delegate respondsToSelector:@selector(parentViewControllerForMediaFocusManager)]) {
        return [self.delegate parentViewControllerForMediaFocusManager];
    }
    
    return nil;
}

// Returns the URL where the media (image or video) is stored. The URL may be local (file://) or distant (http://).
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    NSInteger index;
    NSURL *url;
    
    // Here, medias are accessed through their name stored in self.mediaNames
    index = [self.imageViews indexOfObject:view];
    
    ImageAttributeDS *imageDS =  [[self.monumentDetailObj.imageAttributes allObjects] objectAtIndex:index];
    url  = [NSURL URLWithString:imageDS.imageUrl];
    
    return url;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameForView:(UIView *)view{
    
    return  [UIScreen mainScreen].bounds;
}
// Returns the title for this media view. Return nil if you don't want any title to appear.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view
{
    return @"";
}
*/
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
