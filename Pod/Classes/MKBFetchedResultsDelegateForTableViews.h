//
//  MKBFetchedResultsDelegateForTableViews.h
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^MKBTableViewFetchedResultsDelegateUpdatedBlock)();

@interface MKBFetchedResultsDelegateForTableViews : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, copy) MKBTableViewFetchedResultsDelegateUpdatedBlock updatedBlock;
@property (nonatomic, readwrite) BOOL paused;
@property (nonatomic, weak) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
