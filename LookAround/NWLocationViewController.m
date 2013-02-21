//
//  NWLocationViewController.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/18/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWLocationViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "STImageAnnotationView.h"
#import "Defines.h"
#import <QuartzCore/QuartzCore.h>
#import "NWTwitterViewController.h"

@interface NWLocationViewController ()
{
    IBOutlet  MKMapView * mapView;
    IBOutlet UIWebView *webView;
    BOOL isMapShown;
    NSArray *tweets;
    BOOL downViewShown;
}
@end

@implementation NWLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)switchView:(id)sender
{
    if(!downViewShown)
    {
        downViewShown = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        _containerView.frame = CGRectMake(0, -456, 320, 962);
        
        [UIView commitAnimations];
    }
    else
    {
        downViewShown = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        _containerView.frame = CGRectMake(0, 0, 320, 962);
        
        [UIView commitAnimations];
    }
}

-(void)setTwitterButtonGlow
{
    [_btnTwitter setBackgroundImage:[NWHelper radialGradientImage:_btnTwitter.frame.size start:1 end:1 centre:CGPointMake(0.5, 0.5) radius:0.6] forState:UIControlStateNormal];
    
    
   
    
}

-(void)startTwitterAnimate
{
    _btnTwitter.alpha = 0.2;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"_btnTwitter" context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationDelegate:self];
    
    _btnTwitter.alpha = 1;
    
    [UIView commitAnimations];
    
}

-(void)stopTwitterAnimate
{
    [_btnTwitter.layer removeAllAnimations];
}



- (void)viewDidLoad
{
    isMapShown = NO;
    
    _btnTwitter = [NWHelper createButtonWithImageAndText:@"209-twitter.png" text:@"Tweets" action:@selector(showTwitter) tag:1001 frame:CGRectMake(10, 10, 30, 30) target:self];
    
    [self setTwitterButtonGlow];
    
    [self startTwitterAnimate];
    
    [_statusView addSubview:_btnTwitter];
    
    mapView.layer.cornerRadius = 3;
    
    //mapView.layer.borderWidth = 2;
    //mapView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    webView.layer.cornerRadius = 3;
    
    //webView.layer.borderWidth = 2;
    ///webView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"Place";
    [NWHelper getTwitterAround:[[_location objectForKey:@"latitude"] doubleValue] lng:[[_location objectForKey:@"longitude"] doubleValue] completionBlock:^(NSArray *result, NSError *error) {
        
        tweets = result;
        if(!_btnTwitter)
        {
            _btnTwitter = [NWHelper createButtonWithImageAndText:@"209-twitter.png" text:[NSString stringWithFormat:@"Tweets:%@", result.count >= 100 ? @">100" : [NSString stringWithFormat:@"%i", result.count]] action:@selector(showTwitter) tag:1001 frame:CGRectMake(10, 10, 30, 30) target:self];
            
            [self setTwitterButtonGlow];

            [_statusView addSubview:_btnTwitter];
        }
        else
        {
            [_btnTwitter removeFromSuperview];
            
            _btnTwitter = [NWHelper createButtonWithImageAndText:@"209-twitter.png" text:[NSString stringWithFormat:@"Tweets:%@", result.count >= 100 ? @">100" : [NSString stringWithFormat:@"%i", result.count]] action:@selector(showTwitter) tag:1001 frame:CGRectMake(10, 10, 30, 30) target: self];
            
            [self setTwitterButtonGlow];

            [_statusView addSubview:_btnTwitter];
            
        }
        
        [self stopTwitterAnimate];
        
    }];
    
    
    /*[NWHelper getInstagramAround:[[_location objectForKey:@"latitude"] doubleValue] lng:[[_location objectForKey:@"longitude"] doubleValue] completionBlock:^(NSArray *result, NSError *error) {
        NSLog(@"inside");
    }];
     */    
    
    [self addAnnotationsToMap];
    
    [self checkStreetView];
    
    
    [self centerMap2];
    
    
    UISwipeGestureRecognizer *showExtrasSwipe3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDownPart)];
    showExtrasSwipe3.direction = UISwipeGestureRecognizerDirectionUp;
    [_statusView addGestureRecognizer:showExtrasSwipe3];
    
    UISwipeGestureRecognizer *showExtrasSwipe4 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showUpperPart)];
    showExtrasSwipe4.direction = UISwipeGestureRecognizerDirectionDown;
    [_statusView addGestureRecognizer:showExtrasSwipe4];

    
}

-(void)showDownPart
{
    if(!downViewShown)
    {
        [self switchView:nil];
    }
}

-(void)showUpperPart
{
    if(downViewShown)
    {
        [self switchView:nil];
    }
}

#pragma mark - Seque

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ViewTwitter"])
    {
        NWTwitterViewController *controller = (NWTwitterViewController *)segue.destinationViewController;
        
        
        
        controller.tweets = tweets;
    }
    
}

-(void)showTwitter
{
    //[self performSegueWithIdentifier:@"ViewTwitter" sender:nil];
    
    if(!downViewShown)
    {
        _twitterController = [[NWTwitterViewController alloc] initMe:CGRectMake(0, 0, 320, 456)];
        
        _twitterController.tweets = tweets;
        
        [_downView addSubview:_twitterController.view];
        
        [_twitterController realInit];
        
        [self switchView:nil];

    }
    else
    {
        _twitterController = [[NWTwitterViewController alloc] initMe:CGRectMake(0, 0, 320, 456)];
        
        _twitterController.tweets = tweets;
        
        [_downView addSubview:_twitterController.view];
        
        [_twitterController realInit];

    }
    
    
    
    
}

-(void)checkStreetView
{
    
    //[self loadWebView];
    NWLocationViewController *controller = self;
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[_location objectForKey:@"latitude"] doubleValue], [[_location objectForKey:@"longitude"] doubleValue]);
    
    [NWHelper isStreetViewAvailable:loc completionBlock:^(NSString *res, NSError *error) {
        
        if(!error)
        {
            if(res)
            {
                [controller loadWebView:res];
            }
            else
            {
                [controller btnSwitchMap:nil];
                _btnSwitch.hidden = YES;
                webView.hidden = YES;
            }
            
        }
        else
        {
            [controller btnSwitchMap:nil];
        }
        
    }];
}




-(void)loadWebView:(NSString *)panoIdOfPlace
{
    NSString *urlGoogle = [NSString stringWithFormat:@"http://maps.google.com/maps?layer=c&cbp=0,,,,30&panoid=%@", panoIdOfPlace];
    
    NSLog(@"urlGoogle = %@", urlGoogle);
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlGoogle];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web error: %@", [error description]);
}



#pragma mark Map methods

- (void)centerMap2{
    
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id <MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = 0.001; // Add a little extra space on the sides
    region.span.longitudeDelta = 0.001; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
}

-(void)addAnnotationsToMap
{
    for(MapAnnotation *m in mapView.annotations)
    {
        if(![m isKindOfClass:[MKUserLocation class]])
        {
            [mapView removeAnnotation:m];
        }
    }
    
    
    
    
    CLLocationDegrees longitude = [[_location objectForKey:@"longitude"] doubleValue];
    CLLocationDegrees latitude = [[_location objectForKey:@"latitude"] doubleValue];
    CLLocationCoordinate2D placeLocation;
    placeLocation.latitude = latitude;
    placeLocation.longitude = longitude;
    
    
    
    MapAnnotation *m = [[MapAnnotation alloc] initWithUser:placeLocation name:[_location objectForKey:@"name"] annotationType:WPMapAnnotationCategoryImage];
    
    [mapView addAnnotation:m];
    
    
    
    
}


-(IBAction)btnSwitchMap:(id)sender
{
    if(isMapShown)
    {
        //show street view on full screen
        mapView.frame = CGRectMake(225, [NWHelper isIphone5] ? 354 : 325, 75, 75);
        webView.frame = CGRectMake(0, 0, 320, [NWHelper isIphone5] ? 456 : 400);
        [_upperView bringSubviewToFront:mapView];
        [_upperView bringSubviewToFront:_btnSwitch];
        isMapShown = NO;
        
    }
    else
    {
        //show map on full screen
        mapView.frame = CGRectMake(0, 0, 320, [NWHelper isIphone5] ? 456 : 400);
        webView.frame = CGRectMake(225, [NWHelper isIphone5] ? 354 : 325, 75, 75);
        [_upperView bringSubviewToFront:webView];
        [_upperView bringSubviewToFront:_btnSwitch];
        isMapShown = YES;
    }
}

-(void)mapView:(MKMapView *)mapView1 didAddAnnotationViews:(NSArray *)views
{
    [self centerMap2];
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)a
{
    MKAnnotationView* annotationView = nil;
    
    NSString* identifier = @"Image";
    
    STImageAnnotationView* imageAnnotationView = (STImageAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(nil == imageAnnotationView)
    {
        imageAnnotationView = [[STImageAnnotationView alloc] initWithAnnotation:a reuseIdentifier:identifier];
        
    }
    
    annotationView = imageAnnotationView;
    
    annotationView.canShowCallout = YES;
    //UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[detailButton addTarget:self action:@selector(loadWebView) forControlEvents:UIControlEventTouchUpInside];
    //annotationView.rightCalloutAccessoryView = detailButton;
    annotationView.calloutOffset = CGPointMake(0, 4);
    annotationView.centerOffset =  CGPointMake(0, 0);
    return annotationView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
