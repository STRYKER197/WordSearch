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
