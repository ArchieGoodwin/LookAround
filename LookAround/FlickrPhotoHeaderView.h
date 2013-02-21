//
//  FlickrPhotoHeaderView.h
//  FlickrSearch
//
//  Created by Fahim Farook on 24/7/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoHeaderView : UICollectionReusableView

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void)setSearchText:(NSString *)text;
@end
