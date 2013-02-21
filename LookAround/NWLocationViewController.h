//
//  NWLocationViewController.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/18/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NWTwitterViewController.h"
@interface NWLocationViewController : UIViewController <MKMapViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (strong, nonatomic) NWTwitterViewController *twitterController;

@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;

@property (weak, nonatomic)  UIButton *btnTwitter;
@property (nonatomic, retain) NSDictionary *location;
-(void)startAll;
-(IBAction)btnSwitchMap:(id)sender;
@end