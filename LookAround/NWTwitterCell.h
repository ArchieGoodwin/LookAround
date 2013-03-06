//
//  NWTwitterCell.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/12/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWtwitter.h"
@class NWLabel;
@interface NWTwitterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet NWLabel *lblText;
-(void)setAll:(NWtwitter *)twit;
@end
