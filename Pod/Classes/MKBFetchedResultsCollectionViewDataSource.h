//
//  MKBFetchedResultsCollectionViewDataSource.h
//  Mark Bridges
//
//  Created by Mark Bridges on 25/06/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef UICollectionViewCell * (^MKBCollectionViewCellConfigBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id object);

@interface MKBFetchedResultsCollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, copy) MKBCollectionViewCellConfigBlock cellConfigBlock;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, readonly) BOOL isEmpty;

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
                                  collectionView:(UICollectionView*)collectionView
                              andCellConfigBlock:(MKBCollectionViewCellConfigBlock)cellConfigBlock;

- (id)objectAtIndexPath:(NSIndexPath*)indexPath;

- (BOOL)reloadWithError:(NSError *__autoreleasing *)error;

@end
