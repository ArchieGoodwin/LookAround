//
//  NWAboutViewController.m
//  LookAround
//
//  Created by Sergey Dikarev on 3/19/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWAboutViewController.h"

@interface NWAboutViewController ()

@end

@implementation NWAboutViewController

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
    
    [_toolBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
