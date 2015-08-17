//
//  MKBListCollectionViewDataSourceDelegate.h
//  Mark Bridges
//
//  Created by Mark Bridges on 25/06/2015.
//  Copyright (c) 2015 Mark Bridges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^MKBCollectionViewFetchedResultsDelegateUpdatedBlock)();

@interface MKBFetchedResultsControllerDelegateForCollectionViews : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly, weak) UICollectionView *collectionView;

@property (nonatomic, copy) MKBCollectionViewFetchedResultsDelegateUpdatedBlock updatedBlock;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
