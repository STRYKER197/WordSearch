//
//  ScoreViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/13/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "ScoreViewController.h"
#import "Score.h"
@interface ScoreViewController ()

@end

NSArray *scoreArray;
@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scoreArray = @[@"Teste"];
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
    return [scoreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSLog(@"Entra aqui");
    cell.textLabel.text = scoreArray[indexPath.row];
    return cell;
}

- (void) save
{
//    Score *uf = [NSEntityDescription
//                                insertNewObjectForEntityForName:@"Score"
//                                inManagedObjectContext:self.managedObjectContext];
    
//    uf.id = [[[NSUUID alloc] init] UUIDString];
//    uf.code = code;
//    uf.name = name;
//    uf.image = image;
//    
//    NSError *error;
//    
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"Could not save %@, %@", error, error.userInfo);
//    }
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
