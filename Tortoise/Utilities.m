//
//  Utilities.m
//  Tortoise
//
//  Created by Namit Nayak on 2/12/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+(void)addHUDForView:(id)view{
    
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
    });
//    MBProgressHUD *mbHID = [[MBProgressHUD alloc] init];
//    [mbHID set]
  
}
+(NSString *)getFileNameFromURL:(NSString *)url{
    NSString *val=@"";
    NSArray *gg = [url componentsSeparatedByString:@"/"];
    val = [gg lastObject];
    NSLog(@"getFileNameFromURL %@",val);
    return val;
}
+(void)addHUDSearchMonumentForView:(id)view{
    
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud.label setFont:[UIFont TrotoiseFontLightRegular:12.0]];
    hud.label.numberOfLines = 2;
    hud.label.text = @"Please wait, \nSearching monuments...";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
    });
    //    MBProgressHUD *mbHID = [[MBProgressHUD alloc] init];
    //    [mbHID set]
    
}
//+(MBProgressHUD *)addHUDForView:(id)view withTextChangeCallBack:(HUDTextChange)textChangeHandler{
//    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do something...
////        hud.label.text = 
//    });
//    //    MBProgressHUD *mbHID = [[MBProgressHUD alloc] init];
//    //    [mbHID set]
//    return hud;
//
//}

+(void)hideHUDForView:(id)view{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:YES];
        });
    });
    

}
+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

+(NSString *)formattedStringForNewLineForString:(NSString *)_string{
    NSArray *ss = [_string componentsSeparatedByString:@"\\n"];
    NSMutableString *string = [NSMutableString stringWithFormat:@""];
    for (NSString *a in ss){
        [string appendString:[NSString stringWithFormat:@"%@ \n",a]];
        
        
    }
  return   (NSString *)string;
}


@end
