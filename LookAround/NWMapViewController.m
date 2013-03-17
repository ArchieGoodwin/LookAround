//
//  NWMapViewController.m
//  LookAround
//
//  Created by Sergey Dikarev on 3/14/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWMapViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "STImageAnnotationView.h"
#import "NWItem.h"
#import "NWLocationViewController.h"
#import "Defines.h"
@interface NWMapViewController ()
{
    MBProgressHUD *HUD;

    NSInteger currentItem;
}
@end

@implementation NWMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addAnnotationsToMap];
}


-(void)showHUD
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:HUD];
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
}

-(void)hideHUD
{
    [HUD hide:YES];
    
}

-(IBAction)findPlacesOnMap:(id)sender
{
    CLLocationCoordinate2D coord = [_mapView centerCoordinate];
    [self showHUD];
    [NWHelper poisNearLocation:coord completionBlock:^(NSArray *result, NSError *error) {
        if(!error)
        {
            //NSSortDescriptor *sortDescriptor;
            //sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemDistance" ascending:YES selector:@selector(compare:)];
            //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [_items removeAllObjects];
            _items = [NSMutableArray arrayWithArray:result];
            
            [self addAnnotationsToMap];
            
            
            
        }
        
        [self hideHUD];
        
    }];
}

#pragma mark Map methods

- (void)centerMap2{
    
    if([_mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id <MKAnnotation> annotation in _mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = 0.005; // Add a little extra space on the sides
    region.span.longitudeDelta = 0.005; // Add a little extra space on the sides
    
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
    
}

-(void)addAnnotationsToMap
{
    for(MapAnnotation *m in _mapView.annotations)
    {
        if(![m isKindOfClass:[MKUserLocation class]])
        {
            [_mapView removeAnnotation:m];
        }
    }
    int i = 0;
    for(NWItem *item in _items)
    {
        CLLocationDegrees longitude = item.itemLng;
        CLLocationDegrees latitude = item.itemLat;
        CLLocationCoordinate2D placeLocation;
        placeLocation.latitude = latitude;
        placeLocation.longitude = longitude;
        
        
        
        MapAnnotation *m = [[MapAnnotation alloc] initWithUser:placeLocation name:item.itemName annotationType:WPMapAnnotationCategoryImage tagMe:i];
        i++;
        [_mapView addAnnotation:m];
    }
    
    
    
    
    
    
    
}


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self centerMap2];
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)a
{
    MKAnnotationView* annotationView = nil;
    
    NSString* identifier = @"Image";
    
    STImageAnnotationView* imageAnnotationView = (STImageAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(nil == imageAnnotationView)
    {
        imageAnnotationView = [[STImageAnnotationView alloc] initWithAnnotation:a reuseIdentifier:identifier];
        
    }
    
    annotationView = imageAnnotationView;
    
    annotationView.canShowCallout = YES;
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MapAnnotation* csAnnotation = (MapAnnotation*)a;

    detailButton.tag = csAnnotation.tag;
    [detailButton addTarget:self action:@selector(goToPlace:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = detailButton;
    annotationView.calloutOffset = CGPointMake(0, 4);
    annotationView.centerOffset =  CGPointMake(0, 0);
    return annotationView;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    NWLocationViewController *controller = (NWLocationViewController *)segue.destinationViewController;
    
    
    NWItem *item = _items[currentItem];

    NSDictionary *dict = [NWHelper createDict:item.itemName lat:item.itemLat lng:item.itemLng];
    controller.nwItem = item;
    controller.location = dict;
}


-(IBAction)goToPlace:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    currentItem = btn.tag;
    [self performSegueWithIdentifier:@"LocViewFromMapView" sender:self];
    
    
    
}

@end
