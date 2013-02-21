//
//  StackedGridLayoutSection.h
//  FlickrSearch
//
//  Created by Fahim Farook on 5/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

@interface StackedGridLayoutSection : NSObject

@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) UIEdgeInsets itemInsets;
@property (nonatomic, assign, readonly) CGFloat columnWidth;
@property (nonatomic, assign, readonly) NSInteger numberOfItems;

- (id)initWithOrigin:(CGPoint)origin
               width:(CGFloat)width
             columns:(NSInteger)columns
          itemInsets:(UIEdgeInsets)itemInsets;

- (void)addItemOfSize:(CGSize)size
             forIndex:(NSInteger)index;

- (CGRect)frameForItemAtIndex:(NSInteger)index;

@end
