//
//  SKSConfiguration.mm
//  SpeechKitSample
//
//  All Nuance Developers configuration parameters can be set here.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSConfiguration.h"

// All fields are required.
// Your credentials can be found in your Nuance Developers portal, under "Manage My Apps".
NSString* SKSAppKey = @"2f2459d29ee235318e16ff4947f6f78419d4cacc49d6ac8ebab0ed312e34fa5d585330f6356528c37b270cc21d034737d8110321e7afafa15f9cd28ed0cceb29";
NSString* SKSAppId = @"NMDPPRODUCTION_MediaFusion_TrotoiseNEW_20160208234355";
NSString* SKSServerHost = @"hjd.nmdp.nuancemobility.net";
NSString* SKSServerPort = @"443";



NSString* SKSServerUrl = [NSString stringWithFormat:@"nmsps://%@@%@:%@", SKSAppId, SKSServerHost, SKSServerPort];

// Only needed if using NLU/Bolt
NSString* SKSNLUContextTag = @"!NLU_CONTEXT_TAG!";


