//
//  LoggedInUserDS.h
//  Tortoise
//
//  Created by Namit Nayak on 2/2/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggedInUserDS : NSObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *authenticationID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSURL *imageUrl;
@property (nonatomic,strong) NSURL *coverImageUrl;
@property (nonatomic) BOOL isFacebookLoggedIn;

@end
