#import "GameKitHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";

@interface GameKitHelper ()

@property (nonatomic, strong) NSString *leaderboardIdentifier;

@end

@implementation GameKitHelper

BOOL _enableGameCenter;

+(instancetype)sharedGameKitHelper {
    
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    
    return sharedGameKitHelper;
}

-(id) init {
    self = [super init];
    
    if (self) {
        _enableGameCenter = YES;
    }
    
    return self;
}

- (void)authenticateLocalPlayer {
    
    NSLog(@"++ GameKitHelper.authenticateLocalPlayer");
    
    // This instance represents the player who is currently authenticated
    // through Game Center on this device. Only one player may be authenticated at a time.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    // GameKit may call this handler multiple times
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        
        [self setLastError:error];
        
        if(viewController != nil) {
            [self setAuthenticationViewController:viewController];
       
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
           
            _enableGameCenter = YES;
            
            // Get the default leaderboard identifier.
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:
                ^(NSString *leaderboardIdentifier, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"error: %@", [error localizedDescription]);
                }
                else{
                    _leaderboardIdentifier = leaderboardIdentifier;
                    NSLog(@"Leaderboard:  %@", _leaderboardIdentifier);
                }
            }];
            
        } else {
            _enableGameCenter = NO;
        }
        
        NSLog(@"++ GameKitHelper.authenticateLocalPlayer %@" , (_enableGameCenter) ?@"YES":@"NO" );
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    
    //This simply stores the view controller and sends the notification
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

// This method will keep track of the last error that occurred while communicating with the GameKit service
- (void)setLastError:(NSError *)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

// share score with Game Center
-(void)reportScore : (int64_t)valueScore {
    
    if (!_leaderboardIdentifier) {
        NSLog(@"++ GameKitHelper.reportScore: _leaderboardIdentifier is null (Game Center not connected");
        
    } else {
        
        NSLog(@"++ GameKitHelper.reportScore points: %lld+++", valueScore);
        
        // Create a GKScore object to assign the score
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
        
        score.value = valueScore;
        
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"GameKitHelper.reportScore -- error -- %@", [error localizedDescription]);
            }
        }];
    }
}


@end
