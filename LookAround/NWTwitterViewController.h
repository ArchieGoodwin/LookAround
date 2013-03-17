//
//  NWTwitterViewController.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/12/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWTwitterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)     NSArray *tweets;
-(id)initMe:(CGRect)frame;
-(void)realInit;
@end
