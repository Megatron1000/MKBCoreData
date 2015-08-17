//
//  MKBFetchedResultsTableViewDataSource.h
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBFetchedResultsDelegateForTableViews.h"

typedef UITableViewCell * (^MKBTableViewCellConfigBlock)(UITableView *tableView, id object, NSIndexPath *indexPath);

@interface MKBFetchedResultsTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, readonly) BOOL isEmpty;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic, readonly) MKBFetchedResultsDelegateForTableViews *fetchedResultsDelegate;
@property (copy, nonatomic, readonly) MKBTableViewCellConfigBlock cellConfigBlock;
@property (nonatomic, readwrite) BOOL pause;

- (instancetype)initWithTableView:(UITableView *)tableView
         fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
                  cellConfigBlock:(MKBTableViewCellConfigBlock)cellConfigBlock;

- (BOOL)reloadWithError:(NSError *__autoreleasing *)error;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
