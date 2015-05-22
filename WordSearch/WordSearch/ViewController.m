//
//  ViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/8/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "ViewController.h"
#import "MapaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"
#import "CustomAnnotation.h"
#import "Reachability.h"

@interface ViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.delegate = self;
    BOOL statusConexao = [self connectedToNetwork];
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *targetPath = [libraryPath stringByAppendingPathComponent:@"WordSearch.sqlite"];
    NSLog(@"%@", targetPath);
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
    //Se o idioma não for portugues ou ingles o jogo não irá abrir
    if (!([language isEqualToString:@"pt"] || [language isEqualToString:@"en"])) {
        self.view.hidden = YES;
        NSString *msg = @"Este jogo só funciona se o idioma do seu dispositivo estiver em inglês ou português";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        if (statusConexao == false) {
            self.view.hidden = YES;
            NSString *msg = @"Este jogo exige conexão a internet!";
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"World Search" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    

    
    
    if ([self.restorationIdentifier isEqualToString:@"menu"] || [self.restorationIdentifier isEqualToString:@"game"]) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    } else {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*Verifica se o usuário está conectado*/

- (BOOL) connectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    BOOL isInternet;
    
    if(remoteHostStatus == NotReachable)
    {
        isInternet = false;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    { isInternet = TRUE;
        
    }
    return isInternet;
}



@end
