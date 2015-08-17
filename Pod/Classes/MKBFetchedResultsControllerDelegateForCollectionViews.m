//
//  JSListCollectionViewDataSourceDelegate.m
//  Mark Bridges
//
//  Created by Mark Bridges on 25/06/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import "MKBFetchedResultsControllerDelegateForCollectionViews.h"

@interface MKBFetchedResultsControllerDelegateForCollectionViews ()

@property (atomic, strong) NSMutableDictionary *objectChanges;
@property (atomic, strong) NSMutableDictionary *sectionChanges;

@end

@implementation MKBFetchedResultsControllerDelegateForCollectionViews

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    NSAssert(collectionView, @"Collection view cannot be nil");
    
    if (self = [super init])
    {
        _collectionView = collectionView;
    }
    
    return self;
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    _objectChanges = [NSMutableDictionary dictionary];
    _sectionChanges = [NSMutableDictionary dictionary];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo> )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (type == NSFetchedResultsChangeInsert || type == NSFetchedResultsChangeDelete)
    {
        NSMutableIndexSet *changeSet = _sectionChanges[@(type)];
        if (changeSet != nil)
        {
            [changeSet addIndex:sectionIndex];
        }
        else
        {
            _sectionChanges[@(type)] = [[NSMutableIndexSet alloc] initWithIndex:sectionIndex];
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableArray *changeSet = _objectChanges[@(type)];
    if (changeSet == nil)
    {
        changeSet = [[NSMutableArray alloc] init];
        _objectChanges[@(type)] = changeSet;
    }
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [changeSet addObject:newIndexPath];
        }
            break;
            
        case NSFetchedResultsChangeDelete: {
            [changeSet addObject:indexPath];
        }
            break;
            
        case NSFetchedResultsChangeUpdate: {
            [changeSet addObject:indexPath];
        }
            break;
            
        case NSFetchedResultsChangeMove: {
            [changeSet addObject:@[indexPath, newIndexPath]];
        }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSMutableArray *moves = _objectChanges[@(NSFetchedResultsChangeMove)];
    if (moves.count > 0)
    {
        NSMutableArray *updatedMoves = [[NSMutableArray alloc] initWithCapacity:moves.count];
        
        NSMutableIndexSet *insertSections = _sectionChanges[@(NSFetchedResultsChangeInsert)];
        NSMutableIndexSet *deleteSections = _sectionChanges[@(NSFetchedResultsChangeDelete)];
        for (NSArray *move in moves)
        {
            NSIndexPath *fromIP = move[0];
            NSIndexPath *toIP = move[1];
            
            if ([deleteSections containsIndex:fromIP.section])
            {
                if (![insertSections containsIndex:toIP.section])
                {
                    NSMutableArray *changeSet = _objectChanges[@(NSFetchedResultsChangeInsert)];
                    if (changeSet == nil)
                    {
                        changeSet = [[NSMutableArray alloc] initWithObjects:toIP, nil];
                        _objectChanges[@(NSFetchedResultsChangeInsert)] = changeSet;
                    }
                    else
                    {
                        [changeSet addObject:toIP];
                    }
                }
            }
            else if ([insertSections containsIndex:toIP.section])
            {
                NSMutableArray *changeSet = _objectChanges[@(NSFetchedResultsChangeDelete)];
                if (changeSet == nil)
                {
                    changeSet = [[NSMutableArray alloc] initWithObjects:fromIP, nil];
                    _objectChanges[@(NSFetchedResultsChangeDelete)] = changeSet;
                }
                else
                {
                    [changeSet addObject:fromIP];
                }
            }
            else
            {
                [updatedMoves addObject:move];
            }
        }
        
        if (updatedMoves.count > 0)
        {
            _objectChanges[@(NSFetchedResultsChangeMove)] = updatedMoves;
        }
        else
        {
            [_objectChanges removeObjectForKey:@(NSFetchedResultsChangeMove)];
        }
    }
    
    NSMutableArray *deletes = _objectChanges[@(NSFetchedResultsChangeDelete)];
    if (deletes.count > 0)
    {
        NSMutableIndexSet *deletedSections = _sectionChanges[@(NSFetchedResultsChangeDelete)];
        [deletes filterUsingPredicate:[NSPredicate predicateWithBlock: ^BOOL (NSIndexPath *evaluatedObject, NSDictionary *bindings) {
            return ![deletedSections containsIndex:evaluatedObject.section];
        }]];
    }
    
    NSMutableArray *inserts = _objectChanges[@(NSFetchedResultsChangeInsert)];
    if (inserts.count > 0)
    {
        NSMutableIndexSet *insertedSections = _sectionChanges[@(NSFetchedResultsChangeInsert)];
        [inserts filterUsingPredicate:[NSPredicate predicateWithBlock: ^BOOL (NSIndexPath *evaluatedObject, NSDictionary *bindings) {
            return ![insertedSections containsIndex:evaluatedObject.section];
        }]];
    }
    
    UICollectionView *collectionView = self.collectionView;
    
    __weak typeof(self) weakSelf = self;
    [collectionView performBatchUpdates: ^{
        NSIndexSet *deletedSections = weakSelf.sectionChanges[@(NSFetchedResultsChangeDelete)];
        if (deletedSections.count > 0)
        {
            [collectionView deleteSections:deletedSections];
        }
        
        NSIndexSet *insertedSections = weakSelf.sectionChanges[@(NSFetchedResultsChangeInsert)];
        if (insertedSections.count > 0)
        {
            [collectionView insertSections:insertedSections];
        }
        
        NSArray *deletedItems = weakSelf.objectChanges[@(NSFetchedResultsChangeDelete)];
        if (deletedItems.count > 0)
        {
            [collectionView deleteItemsAtIndexPaths:deletedItems];
        }
        
        NSArray *insertedItems = weakSelf.objectChanges[@(NSFetchedResultsChangeInsert)];
        if (insertedItems.count > 0)
        {
            [collectionView insertItemsAtIndexPaths:insertedItems];
        }
        
        NSArray *reloadItems = weakSelf.objectChanges[@(NSFetchedResultsChangeUpdate)];
        if (reloadItems.count > 0)
        {
            [collectionView reloadItemsAtIndexPaths:reloadItems];
        }
        
        NSArray *moveItems = weakSelf.objectChanges[@(NSFetchedResultsChangeMove)];
        for (NSArray *paths in moveItems)
        {
            [collectionView moveItemAtIndexPath:paths[0] toIndexPath:paths[1]];
        }
    } completion:nil];
    
    _objectChanges = nil;
    _sectionChanges = nil;
}

@end
