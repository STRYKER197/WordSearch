
#import "GameNavigationViewController.h"
#import "GameKitHelper.h"

@interface GameNavigationViewController ()

@end

@implementation GameNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"## gameNavControl.viewDidLoad");
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSLog(@"## gameNavControl.viewDidAppear");

    // is registering for the PresentAuthenticationViewController notification and
    // making a call to the authenticateLocalPlayer method of GameKitHelper. When the
    // notification is received you need to present the authentication view controller
    // returned by GameKit. To do this add the following methods to the same file.
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showAuthenticationViewController)
     name:PresentAuthenticationViewController
     object:nil];
    
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];
}

// method will be invoked when the PresentAuthenticationViewController
// notification is received. This method will present the authentication
// view controller to the user over the top view controller in the navigation stack.
- (void)showAuthenticationViewController {
    
    NSLog(@"## gameNavControl.showAuthenticationViewController");
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    [self.topViewController presentViewController:
     gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}

- (void)dealloc {
    NSLog(@"## gameNavControl.dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
