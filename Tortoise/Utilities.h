//
//  Utilities.h
//  Tortoise
//
//  Created by Namit Nayak on 2/12/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject


+(void)addHUDForView:(id)view;
//+(MBProgressHUD *)addHUDForView:(id)view withTextChangeCallBack:(HUDTextChange)textChangeHandler;

+(void)hideHUDForView:(id)view;
+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
+(void)addHUDSearchMonumentForView:(id)view;
+(NSString *)formattedStringForNewLineForString:(NSString *)_string;
+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
+(NSString *)getFileNameFromURL:(NSString *)url;
@end
