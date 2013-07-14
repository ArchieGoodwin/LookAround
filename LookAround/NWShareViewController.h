//
//  NWShareViewController.h
//  LookAround
//
//  Created by Sergey Dikarev on 4/4/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWShareViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *streetView;
@property (nonatomic, retain) NSDictionary *location;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UINavigationBar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
-(IBAction)back:(id)sender;
-(IBAction)goRight:(id)sender;
-(IBAction)goLeft:(id)sender;
-(IBAction)shareImage;
@end
