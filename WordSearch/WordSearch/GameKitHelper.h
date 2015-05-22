//
//  GameKit.h
//  ThomazRunner
//
//  Created by Adriana Izel on 5/9/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PresentAuthenticationViewController;

@import GameKit;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+(instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;

-(void)reportScore : (int64_t)valueScore;

@end
