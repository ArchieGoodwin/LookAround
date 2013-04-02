//
//  SearchViewController.h
//  chainges
//
//  Created by Sergey Dikarev on 1/15/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BZFoursquare.h"
typedef enum
{
    SearchBy4square,
    
    SearchBy4squareFull
    
    
} SearchType;


@interface SearchViewController : UITableViewController <UISearchBarDelegate, MBProgressHUDDelegate, UIActionSheetDelegate, BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic, assign) NSInteger currentPageType;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnMap;
@property (strong, nonatomic)     NSMutableArray *searchResult;
@property (nonatomic, assign) SearchType currentSearchType;
@property(nonatomic,strong) BZFoursquareRequest *request;

- (void)showHUD;

- (void)hideHUD;

@end
