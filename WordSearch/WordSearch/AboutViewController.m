//
//  AboutViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/13/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:101 green:186 blue:105 alpha:1.0]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:101 green:186 blue:105 alpha:1.0]];

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

-(BOOL)prefersStatusBarHidden{
    return YES;
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
