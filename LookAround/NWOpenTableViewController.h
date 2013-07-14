//
//  NWOpenTableViewController.h
//  LookAround
//
//  Created by Sergey Dikarev on 4/2/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWOpenTableViewController : UITableViewController <UIActionSheetDelegate>


@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) UIView *parentView;
-(id)initMe:(CGRect)frame;
-(void)realInit;
@end
