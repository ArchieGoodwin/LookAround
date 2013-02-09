//
//  SearchViewController.h
//  chainges
//
//  Created by Sergey Dikarev on 1/15/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IconDownloader.h"
@interface SearchViewController : UITableViewController <UISearchBarDelegate, IconDownloaderDelegate>
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic, assign) NSInteger currentPageType;


@end
