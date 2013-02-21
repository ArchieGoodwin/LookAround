//
//  StackedGridLayout.h
//  FlickrSearch
//
//  Created by Fahim Farook on 5/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StackedGridLayoutDelegate <UICollectionViewDelegate>

// 1
- (NSInteger)collectionView:(UICollectionView*)cv
                     layout:(UICollectionViewLayout*)cvl
   numberOfColumnsInSection:(NSInteger)section;

// 2
- (CGSize)collectionView:(UICollectionView*)cv
                  layout:(UICollectionViewLayout*)cvl
    sizeForItemWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath;

// 3
- (UIEdgeInsets)collectionView:(UICollectionView*)cv
                        layout:(UICollectionViewLayout*)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section;

@end

@interface StackedGridLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@end
