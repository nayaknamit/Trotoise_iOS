//
//  UIFont+Trotoise.m
//  Trotoise
//


#import "UIFont+Trotoise.h"

NSString* const TrotoiseFontBold = @"Roboto-Bold";
NSString* const TrotoiseFontItalic = @"Roboto-Italic";
NSString* const TrotoiseFontLight = @"Roboto-Light";
NSString* const TrotoiseFontLightRegular = @"Roboto-Regular";
NSString* const TrotoiseFontOswaldRegular = @"Oswald-Regular";
NSString* const TrotoiseFontMedium = @"Roboto-Medium";
//NSString* const TrotoiseFontLight
NSString* const TrotoiseFontCondensed = @"RobotoCondensed-Regular";
@implementation UIFont (Trotoise)

+ (UIFont*)TrotoiseFontBold:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontBold size:size];

}

+ (UIFont*)TrotoiseFontMedium:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontMedium size:size];
    
}
+ (UIFont*)TrotoiseFontItalic:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontItalic size:size];

}

+ (UIFont*)TrotoiseFontLight:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontLight size:size];
}

+ (UIFont*)TrotoiseFontLightRegular:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontLightRegular size:size];
}

+ (UIFont*)TrotoiseFontOswaldRegular:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontOswaldRegular size:size];
}
+ (UIFont*)TrotoiseFontCondensedRegular:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontCondensed size:size];
}



+ (UIFont*)TrotoiseCareerStatFont {
    return [UIFont fontWithName:TrotoiseFontLight size:8.0];

}

@end
