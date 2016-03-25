//
//  LoggedInUserDS.h
//  Tortoise
//
//  Created by Namit Nayak on 2/2/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//
typedef NSInteger TRRANGETYPE;
enum
{
    TRRANGE_KILOMETERTYPE = 0,
    TRRANGE_MILETYPE = 1,
    
};
#import <Foundation/Foundation.h>
@class  Language;
@interface LoggedInUserDS : NSObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *authenticationID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSURL *imageUrl;
@property (nonatomic) TRRANGETYPE rangeType;
@property (nonatomic,strong) NSURL *coverImageUrl;
@property (nonatomic) BOOL isFacebookLoggedIn;
@property (nonatomic,strong) Language *selectedLanguageDS;
@property (nonatomic,strong) NSString *formattedAddressString;
@end
