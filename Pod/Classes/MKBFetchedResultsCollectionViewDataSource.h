//
//  MKBFetchedResultsCollectionViewDataSource.h
//  Mark Bridges
//
//  Created by Mark Bridges on 25/06/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;

typedef UICollectionViewCell * (^MKBCollectionViewCellConfigBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id object);

@interface MKBFetchedResultsCollectionViewDataSource : NSObject <UICollectionViewDataSource>

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
                                  collectionView:(UICollectionView*)collectionView
                              andCellConfigBlock:(MKBCollectionViewCellConfigBlock)cellConfigBlock;

- (id)objectAtIndexPath:(NSIndexPath*)indexPath;

- (BOOL)reloadWithError:(NSError *__autoreleasing *)error;

@end
