//
//  CCNTableViewController.m
//  CocoaNews
//
//  Created by Thibaut Jarosz on 14/11/13.
//  Copyright (c) 2013 CocoaHeads Lyon. All rights reserved.
//

#import "CCNTableViewController.h"

#import "CCNArticle.h"
#import "CCNCategory.h"
#import "CCNDataManager.h"

NSString * const kCCNTableViewControllerCellID = @"CCNTableViewControllerCellID";
NSString * const kCCNTableViewControllerHeaderID = @"kCCNTableViewControllerHeaderID";

@interface CCNTableViewController () <NSFetchedResultsControllerDelegate>
@end

@implementation CCNTableViewController
{
    NSFetchedResultsController *_results;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Articles";
    
    [[CCNDataManager sharedInstance] importData];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    _results = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[CCNDataManager sharedInstance].mainContext  sectionNameKeyPath:@"category.name" cacheName:nil];
    _results.delegate = self;
    [_results performFetch:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _results.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo>object = _results.sections[section];
    return object.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCCNTableViewControllerCellID];
    if ( !cell )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCCNTableViewControllerCellID];
    
    CCNArticle *article = [_results objectAtIndexPath:indexPath];
    
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = article.category.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo>object = _results.sections[section];
    return object.name;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCCNTableViewControllerHeaderID];
    
    if ( !view )
    {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kCCNTableViewControllerHeaderID];
        view.backgroundView = [UIView new];
        view.backgroundView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.9];
    }
    return view;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Called each time the fetchedResultsController content changes
    [self.tableView reloadData];
}

@end
