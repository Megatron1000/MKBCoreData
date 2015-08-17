//
//  MKBFetchedResultsDelegateForTableViews.m
//  Mark Bridges
//
//  Created by Mark Bridges on 27/01/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import "MKBFetchedResultsDelegateForTableViews.h"
#import <CoreData/CoreData.h>

@interface MKBFetchedResultsDelegateForTableViews ()

@property (nonatomic, strong) NSMutableIndexSet *sectionsBeingAdded;
@property (nonatomic, strong) NSMutableIndexSet *sectionsBeingRemoved;

@end

@implementation MKBFetchedResultsDelegateForTableViews

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
        _tableView = tableView;
    }
    
    return self;
}

#pragma mark
#pragma mark Fetch results controller delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.sectionsBeingAdded = [NSMutableIndexSet indexSet];
    self.sectionsBeingRemoved = [NSMutableIndexSet indexSet];
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.sectionsBeingAdded addIndex:sectionIndex];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                         withRowAnimation :UITableViewRowAnimationFade];
        }
            break;
            
        case NSFetchedResultsChangeDelete: {
            [self.sectionsBeingRemoved addIndex:sectionIndex];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                         withRowAnimation :UITableViewRowAnimationFade];
        }
            break;
            
        case NSFetchedResultsChangeMove: {
            NSLog(@"Unhandled Change move called");
        }
            break;
            
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                         withRowAnimation :UITableViewRowAnimationAutomatic];
        }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case NSFetchedResultsChangeUpdate: {
            if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath])
            {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
            break;
            
        case NSFetchedResultsChangeMove: {
            if ([self shouldMakeMoveForMovedObjectFromIndexPath:indexPath toIndexPath:newIndexPath])
            {
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            }
            else
            {
                // This is to prevent a bug in UITableView from occurring.
                // The bug presents itself when moving a row from a newly deleted section or to a newly inserted section
                // This code should be removed once the bug has been fixed, it is tracked in OpenRadar
                // http://openradar.appspot.com/17684030
                [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            }
        }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    if (self.updatedBlock)
    {
        self.updatedBlock();
    }
}

- (BOOL)shouldMakeMoveForMovedObjectFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    return !([self.sectionsBeingRemoved containsIndex:fromIndexPath.section] || [self.sectionsBeingAdded containsIndex:toIndexPath.section]);
}

@end
