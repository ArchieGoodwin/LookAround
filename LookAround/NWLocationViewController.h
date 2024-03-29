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
#import "InstagramCollectionViewController.h"
#import "NWFourSquareViewController.h"
#import "NWItem.h"
#import "NWOpenTableViewController.h"
@interface NWLocationViewController : UIViewController <MKMapViewDelegate, UIWebViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;

@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UIButton *btnDownShow;
@property (weak, nonatomic) IBOutlet UINavigationItem *myTitle;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (strong, nonatomic) NWTwitterViewController *twitterController;
@property (strong, nonatomic) InstagramCollectionViewController *instaController;
@property (strong, nonatomic) NWFourSquareViewController *fourController;
@property (strong, nonatomic) NWOpenTableViewController *openTableController;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;

@property (weak, nonatomic)  UIButton *btnTwitter;
@property (weak, nonatomic) UIButton *btnInstagram;
@property (weak, nonatomic) UIButton *btn4s;
@property (weak, nonatomic) UIButton *btnOpenTable;

@property (nonatomic, retain) NSDictionary *location;
@property (nonatomic, strong) NWItem *nwItem;
-(void)startAll;
-(IBAction)btnSwitchMap:(id)sender;
@end
