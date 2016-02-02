//
//  UIFont+Trotoise.m
//  Trotoise
//


#import "UIFont+Trotoise.h"

NSString* const TrotoiseFontBold = @"Roboto-Bold";
NSString* const TrotoiseFontBoldItalic = @"Roboto-Italic";
NSString* const TrotoiseFontLight = @"Roboto-Light";
NSString* const TrotoiseFontLightItalic = @"Roboto-Regular";
NSString* const TrotoiseFontOswaldRegular = @"Oswald-Regular";
NSString* const TrotoiseFontCondensed = @"RobotoCondensed-Regular";
@implementation UIFont (Trotoise)

+ (UIFont*)TrotoiseFontBold:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontBold size:size];

}

+ (UIFont*)TrotoiseFontBoldItalic:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontBoldItalic size:size];

}

+ (UIFont*)TrotoiseFontLight:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontLight size:size];
}

+ (UIFont*)TrotoiseFontLightItalic:(CGFloat)size {
    return [UIFont fontWithName:TrotoiseFontLightItalic size:size];
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
