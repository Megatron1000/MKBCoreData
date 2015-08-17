//
//  MKBFetchedResultsTableViewDataSource.m
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import "MKBFetchedResultsTableViewDataSource.h"
#import <CoreData/CoreData.h>

@interface MKBFetchedResultsTableViewDataSource ()

@end

@implementation MKBFetchedResultsTableViewDataSource

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize isEmpty = _isEmpty;

- (void)dealloc
{
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    _tableView.dataSource = nil;
}

- (BOOL)reloadWithError:(NSError *__autoreleasing *)error;
{
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    
    BOOL success = NO;
    if ([self.fetchedResultsController performFetch:error])
    {
        [self.tableView reloadData];
        success = YES;
    }
    
    return success;
}

#pragma mark
#pragma mark Life Cycle

- (instancetype)initWithTableView:(UITableView *)tableView
           fetchResultsController:(NSFetchedResultsController *)fetchResultsController
                  cellConfigBlock:(MKBTableViewCellConfigBlock)cellConfigBlock
{
    NSAssert(fetchResultsController, @"Fetched results controller cannot be nil");
    NSAssert(cellConfigBlock, @"Cell config block cannot be nil");
    
    self = [super init];
    if (self)
    {
        _cellConfigBlock = cellConfigBlock;
        _tableView = tableView;
        _tableView.dataSource = self;
        _fetchedResultsController = fetchResultsController;
        _fetchResultsDelegate = [[MKBFetchedResultsDelegateForTableViews alloc]initWithTableView:tableView];
        _fetchedResultsController.delegate = _fetchResultsDelegate;
        __weak typeof(self) weakSelf = self;
        
        _fetchResultsDelegate.updatedBlock = ^{
            [weakSelf willChangeValueForKey:NSStringFromSelector(@selector(isEmpty))];
            [weakSelf didChangeValueForKey:NSStringFromSelector(@selector(isEmpty))];
        };
    }
    
    return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (BOOL)isEmpty
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:0];
    return ([sectionInfo numberOfObjects] == 0);
}

- (void)setPause:(BOOL)pause
{
    if (_pause == NO && pause == YES)
    {
        self.fetchedResultsController.delegate = nil;
    }
    else if (_pause == YES && pause == NO)
    {
        self.fetchedResultsController.delegate = self.fetchResultsDelegate;
        [self reloadWithError:nil];
    }
    
    _pause = pause;
}

- (void)setTableView:(UITableView *)tableView
{
    tableView.dataSource = self;
    self.fetchResultsDelegate.tableView = tableView;
    _tableView = tableView;
}

#pragma mark
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < [self.fetchedResultsController.sections count])
    {
        return [self.fetchedResultsController.sections[section] numberOfObjects];
    }
    
    return 0; // If section doesn't exist return 0
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellConfigBlock(tableView, [self.fetchedResultsController objectAtIndexPath:indexPath], indexPath);
}

@end
