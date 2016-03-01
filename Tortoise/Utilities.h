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
+(void)hideHUDForView:(id)view;
+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
@end
