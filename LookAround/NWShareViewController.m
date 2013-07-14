//
//  NWShareViewController.m
//  LookAround
//
//  Created by Sergey Dikarev on 4/4/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWShareViewController.h"
#import "Defines.h"

#import "AFNetworking.h"
@interface NWShareViewController ()
{
    int heading;
}
@end

@implementation NWShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getImage
{
    [NWHelper getStreetViewImageByLastAndLng:[[_location objectForKey:@"latitude"] doubleValue] lng:[[_location objectForKey:@"longitude"] doubleValue]  heading:heading completionBlock:^(UIImage *imageView, NSError *error) {
        _streetView.image = imageView;
    }];
}

- (void)viewDidLoad
{
    
    [_toolbar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
       
    [super viewDidLoad];
    
    _lblName.text = [_location objectForKey:@"name"];
    _lblName.textColor = [UIColor whiteColor];
    [self getImage];
	// Do any additional setup after loading the view.
}


-(IBAction)shareImage
{
   
    NSString *link = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f",  [[_location objectForKey:@"latitude"] doubleValue], [[_location objectForKey:@"longitude"] doubleValue] ];
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) //iOS >=5.0
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[[NSString stringWithFormat:@"%@: %@", [_location objectForKey:@"name"], link], _streetView.image] applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeAssignToContact];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(IBAction)goRight:(id)sender
{
    if(heading < 360)
    {
        heading = heading + 30;

    }
    else
    {
        heading = 0;
    }
    [self getImage];
}

-(IBAction)goLeft:(id)sender
{
    if(heading > 0)
    {
        heading = heading - 30;
        
    }
    else
    {
        heading = 330;
    }
    [self getImage];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
