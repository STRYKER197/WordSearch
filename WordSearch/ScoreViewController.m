//
//  ScoreViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/13/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "ScoreViewController.h"
#import "GameKitHelper.h"

@interface ScoreViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

NSArray *scoreArray;
NSArray *score2Array;
@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:games/game/"]];
    
    score2Array = @[@"13/05/2015", @"13/05/2015", @"13/05/2015", @"13/05/2015"];
    scoreArray = @[@"40 PTS", @"80 PTS", @"20 PTS", @"0 PTS"];
    
//    scoreArray = [self select];
}


- (void)viewDidAppear:(BOOL)animated
{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.detailTextLabel.text = score2Array[indexPath.row];
    cell.textLabel.text = scoreArray[indexPath.row];
    return cell;
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
