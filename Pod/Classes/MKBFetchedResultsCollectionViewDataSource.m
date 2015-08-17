//
//  MKBFetchedResultsCollectionViewDataSource.m
//  Mark Bridges
//
//  Created by Mark Bridges on 25/06/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import "MKBFetchedResultsCollectionViewDataSource.h"
#import "MKBFetchedResultsControllerDelegateForCollectionViews.h"
#import <CoreData/CoreData.h>

@interface MKBFetchedResultsCollectionViewDataSource ()

@property (nonatomic, strong) MKBFetchedResultsControllerDelegateForCollectionViews *fetchedResultsDelegate;

@end

@implementation MKBFetchedResultsCollectionViewDataSource

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
                                  collectionView:(UICollectionView*)collectionView
                              andCellConfigBlock:(MKBCollectionViewCellConfigBlock)cellConfigBlock;
{
    if (self = [super init])
    {
        collectionView.dataSource = self;
        _fetchedResultsController = fetchedResultsController;
        _fetchedResultsDelegate = [[MKBFetchedResultsControllerDelegateForCollectionViews alloc]initWithCollectionView:collectionView];
        _fetchedResultsController.delegate = _fetchedResultsDelegate;
        _cellConfigBlock = cellConfigBlock;
        __weak typeof(self) weakSelf = self;
        _fetchedResultsDelegate.updatedBlock = ^{
            [weakSelf willChangeValueForKey:NSStringFromSelector(@selector(isEmpty))];
            [weakSelf didChangeValueForKey:NSStringFromSelector(@selector(isEmpty))];
        };
    }
    
    return self;
}

- (id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (BOOL)reloadWithError:(NSError *__autoreleasing *)error;
{
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    return [self.fetchedResultsController performFetch:error];
}

- (BOOL)isEmpty
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:0];
    return ([sectionInfo numberOfObjects] == 0);
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellConfigBlock(collectionView, indexPath, [self objectAtIndexPath:indexPath]);
}

@end
