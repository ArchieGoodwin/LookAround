//
//  NWAppDelegate.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/8/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWAppDelegate.h"
#import "Defines.h"
#import <Crashlytics/Crashlytics.h>
#import "BZFoursquare.h"
#import "SearchViewController.h"
@implementation NWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:@"ce72f654090cf0479c9ff146d447fdecdf5b6a0a"];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Model.sqlite"];
    [NWHelper startUpdateLocation];
    
    
    
    if(![[NWHelper getSettingsValue:@"isItFirstTime"] boolValue])
    {
        [NWHelper createPredefinedSearches];
        [NWHelper saveToUserDefaults:[NSNumber numberWithBool:YES] key:@"isItFirstTime"];
        
    }
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor], UITextAttributeTextColor,
                                                              [UIColor grayColor], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(1, 1)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:@"HelveticaNeue" size:19], UITextAttributeFont,
                                                              nil]];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    if ([[url scheme] hasPrefix:@"lookaround"]) {

        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                      //           bundle: nil];
        
        //NSLog(@"%@", [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchController"]);
        
        //SearchViewController *cont = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchController"];
        
        //BZFoursquare *foursquare = cont.foursquare;
        return [((NWManager *)[NWManager sharedInstance]).foursquare handleOpenURL:url];
    
    }
    
    

    
    
    
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
