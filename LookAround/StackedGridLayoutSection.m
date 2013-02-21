//
//  StackedGridLayoutSection.m
//  FlickrSearch
//
//  Created by Fahim Farook on 5/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "StackedGridLayoutSection.h"

@interface StackedGridLayoutSection () {
    CGRect _frame;
    UIEdgeInsets _itemInsets;
    CGFloat _columnWidth;
    NSMutableArray *_columnHeights;
    NSMutableDictionary *_indexToFrameMap;
}
@end

@implementation StackedGridLayoutSection

- (id)initWithOrigin:(CGPoint)origin
               width:(CGFloat)width
             columns:(NSInteger)columns
          itemInsets:(UIEdgeInsets)itemInsets
{
    if ((self = [super init])) {
        _frame = CGRectMake(origin.x, origin.y, width, 0.0f);
        _itemInsets = itemInsets;
        _columnWidth = floorf(width / columns);
        _columnHeights = [NSMutableArray new];
        _indexToFrameMap = [NSMutableDictionary new];
        
        for (NSInteger i = 0; i < columns; i++) {
            [_columnHeights addObject:@(0.0f)];
        }
    }
    return self;
}

- (CGRect)frame {
    return _frame;
}

- (CGFloat)columnWidth {
    return _columnWidth;
}

- (NSInteger)numberOfItems {
    return _indexToFrameMap.count;
}

- (void)addItemOfSize:(CGSize)size
             forIndex:(NSInteger)index
{
    // 1
    __block CGFloat shortestColumnHeight = CGFLOAT_MAX;
    __block NSUInteger shortestColumnIndex = 0;
    
    // 2
    [_columnHeights enumerateObjectsUsingBlock:
	 ^(NSNumber *height, NSUInteger idx, BOOL *stop)
	 {
		 CGFloat thisColumnHeight = [height floatValue];
		 if (thisColumnHeight < shortestColumnHeight) {
			 shortestColumnHeight = thisColumnHeight;
			 shortestColumnIndex = idx;
		 }
	 }];
    
    // 3
    CGRect frame;
    frame.origin.x = _frame.origin.x +
	(_columnWidth * shortestColumnIndex) +
	_itemInsets.left;
    frame.origin.y = _frame.origin.y +
	shortestColumnHeight +
	_itemInsets.top;
    frame.size = size;
    
    // 4
    _indexToFrameMap[@(index)] =
	[NSValue valueWithCGRect:frame];
    
    // 5
    if (CGRectGetMaxY(frame) > CGRectGetMaxY(_frame)) {
        _frame.size.height =
		(CGRectGetMaxY(frame) - _frame.origin.y) +
		_itemInsets.bottom;
    }
    
    // 6
    [_columnHeights
	 replaceObjectAtIndex:shortestColumnIndex
	 withObject:@(shortestColumnHeight +
	 size.height +
	 _itemInsets.bottom)];
}

- (CGRect)frameForItemAtIndex:(NSInteger)index {
    return [_indexToFrameMap[@(index)] CGRectValue];
}

@end
