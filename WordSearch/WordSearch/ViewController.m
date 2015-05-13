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

@interface ViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *targetPath = [libraryPath stringByAppendingPathComponent:@"WordSearch.sqlite"];
    NSLog(@"%@", targetPath);
    
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



@end
