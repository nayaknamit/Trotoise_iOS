//
//  LanguageDS.h
//  Tortoise
//
//  Created by Namit Nayak on 1/31/16.
//  Copyright © 2016 Namit Nayak. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NuanceDS;

@interface LanguageDS : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *transCode;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSSet *nuanceRelationship;
@end

@interface NuanceDS : NSObject

@property (nonatomic, strong) NSString *code4;
@property (nonatomic, strong) NSString *code6;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSSet  *provider;


@end

@interface ProviderDS : NSObject

@property ( nonatomic, strong) NSString *type;
@property ( nonatomic, strong) NSString *voice;


@end
