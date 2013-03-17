//
//  SearchViewController.h
//  chainges
//
//  Created by Sergey Dikarev on 1/15/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SearchViewController : UITableViewController <UISearchBarDelegate, MBProgressHUDDelegate>
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic, assign) NSInteger currentPageType;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnMap;
@property (strong, nonatomic)     NSMutableArray *searchResult;


- (void)showHUD;

- (void)hideHUD;

@end
