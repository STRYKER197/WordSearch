//
//  ScoreViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/13/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "ScoreViewController.h"
#import "Score.h"
#import "AppDelegate.h"
@interface ScoreViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end

NSMutableArray *scoreArray;
@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    

    
    if ([self.restorationIdentifier isEqualToString:@"menu"] || [self.restorationIdentifier isEqualToString:@"game"]) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    } else {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    
    scoreArray = [self select];
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

- (NSMutableArray *) select
{
    NSFetchedResultsController *fetchedResultsControllerLocal;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"data" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchedResultsControllerLocal = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if (![fetchedResultsControllerLocal performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *arObj = fetchedResultsControllerLocal.fetchedObjects;
    
    NSMutableArray *dados = [[NSMutableArray alloc] initWithArray:arObj];

    return dados;
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
