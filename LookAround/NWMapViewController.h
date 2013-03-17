//
//  NWMapViewController.h
//  LookAround
//
//  Created by Sergey Dikarev on 3/14/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NWItem.h"
#import "MBProgressHUD.h"
@interface NWMapViewController : UIViewController <MKMapViewDelegate, MBProgressHUDDelegate>
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


-(void)addAnnotationsToMap;
@end
