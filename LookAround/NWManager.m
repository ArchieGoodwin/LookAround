//
//  NWManager.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/8/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Defines.h"
#import "URLConnection.h"
#import "NWItem.h"
#import "Searches.h"
#import "NWtwitter.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
@implementation NWManager


- (id)init {
    self = [super init];
    
    _locationManager = [[CLLocationManager alloc] init];
	//_locationManager.distanceFilter = 5;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
	
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    
#else
    
    
#endif
    
    
    
    return self;
    
}


#pragma mark  - helper methods

- (UIImage *)radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius {

	// Initialise
	UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    
	// Create the gradient's colours
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { start,start,start, 1.0,  // Start color
		end,end,end, 0.0 }; // End color
	
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
	
	// Normalise the 0-1 ranged inputs to the width of the image
	CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
	float myRadius = MIN(size.width, size.height) * radius;
	
	// Draw it!
	CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
								 0, myCentrePoint, myRadius,
								 kCGGradientDrawsAfterEndLocation);
	
	// Grab it as an autoreleased image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	// Clean up
	CGColorSpaceRelease(myColorspace); // Necessary?
	CGGradientRelease(myGradient); // Necessary?
	UIGraphicsEndImageContext(); // Clean up
	return image;
}


-(UIButton *)createButtonWithImageAndText:(NSString *)imageName text:(NSString *)text action:(SEL)action tag:(NSInteger)tag frame:(CGRect)frame target:(id)target
{
    UIButton *btn_chat = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_chat.frame = frame;//CGRectMake(20, 20, 200, 72);
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize newSize = image.size;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [btn_chat setImage:newImage forState:UIControlStateNormal];
    btn_chat.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    //[btn_chat setTitle:text forState:UIControlStateNormal];
    //btn_chat.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    //[btn_chat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    btn_chat.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    btn_chat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn_chat addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn_chat setTag:tag];
    [btn_chat setBackgroundColor:[UIColor clearColor]];
    btn_chat.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    btn_chat.layer.cornerRadius = 5;
    btn_chat.layer.borderWidth = 1;
    return btn_chat;
}




#pragma mark - Location methods
-(void)getLocationsForSearchString:(NSString *)searchStr completionBlock:(ChGetLocationsBySearchString)completionBlock
{
    
    ChGetLocationsBySearchString cBlock = completionBlock;
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo geocodeAddressString:searchStr
            completionHandler:^(NSArray *placemarks, NSError *error) {
                /*NSMutableArray *filteredPlacemarks = [[NSMutableArray alloc] init];
                 for (CLPlacemark *placemark in placemarks) {
                 if ([placemark.location distanceFromLocation:centerLocation] <= maxDistance) {
                 [filteredPlacemarks addObject:placemark];
                 }
                 } */
                NSLog(@"results: %i", placemarks.count);
                if(cBlock)
                {
                    cBlock(placemarks, error);
                }
                
            }];
}


-(void)poisNearLocation:(CLLocationCoordinate2D)location completionBlock:(WPgetPOIsCompletionBlock)completionBlock
{
    
    WPgetPOIsCompletionBlock completeBlock = [completionBlock copy];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *loc = [NSString stringWithFormat:@"%.10f,%.10f", location.latitude, location.longitude];
    
    
    NSString *connectionString = [NSString stringWithFormat:@"%@ll=%@&client_id=%@&client_secret=%@&v=%@&limit=%@&radius=%@", PATH_TO_4SERVER, loc, CLIENT_ID, CLIENT_SECRET, dateString, LIMIT, RADIUS];
    NSLog(@"connect to: %@",connectionString);
    
    
    NSURL *url = [NSURL URLWithString:connectionString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"%@", JSON);
        NSMutableArray *pois = [[NSMutableArray alloc] init];
        
        //if([[json objectForKey:@"numResults"] integerValue] > 0)
        //{
        NSMutableArray *items = [[[[JSON objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        for (NSMutableDictionary *dict in items) {
            NWItem *item = [[NWItem alloc] initWithDictionary:[dict objectForKey:@"venue"]];
            [pois addObject:item];
        }
        
        if(pois.count > 0)
        {
            
            NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemDistance" ascending:YES];
            if(completeBlock)
            {
                completeBlock([pois sortedArrayUsingDescriptors:[NSMutableArray arrayWithObjects:sortDescriptor, nil]], nil);
                
            }
        }
        else
        {
            completeBlock(pois, nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        completeBlock(nil, error);
    }];
    
    [operation start];
    
   
}


-(Searches *)createSearchRequest:(NSString *)request searchType:(SearchPageListType)searchType
{
    Searches *search = [Searches createEntity];
    [search setSearchStr:request];
    [search setDateSearhed:[NSDate date]];
    [search setSearchType:[NSNumber numberWithInteger:searchType]];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    
    return search;
}




-(void)startUpdateLocation
{
    [_locationManager startUpdatingLocation];
}

-(void)stopUpdateLocation
{
    [_locationManager stopUpdatingLocation];
}




#pragma mark - Location delegates

-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"Location updated to = %@",newLocation);
    
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    //NSLog(@"time: %f", locationAge);
    
    if (newLocation.horizontalAccuracy < 0) return;
    
	// Needed to filter cached and too old locations
    //NSLog(@"Location updated to = %@", newLocation);
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:manager.location.coordinate.latitude longitude:manager.location.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    double distance = [loc1 distanceFromLocation:loc2];
    if(distance > 5)
    {
        NSLog(@"SIGNIFICANTSHIFT");
        [[NSNotificationCenter defaultCenter] postNotificationName:chLocationMuchUpdated object:self userInfo:nil];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:chLocationUpdated object:self userInfo:nil];
    
    
    
}



-(NSDictionary *)createDict:(NSString *)locName lat:(double)lat lng:(double)lng
{
    // 1. "id" в Foursquare 2. "name" 3. "latitude" 4. "longitude") о выбранной (либо заданной) POI.
    NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys: locName, @"name", [NSString stringWithFormat:@"%.7f", lat], @"latitude", [NSString stringWithFormat:@"%.7f", lng], @"longitude", nil];
    return resultDict;
}

-(void)isStreetViewAvailable:(CLLocationCoordinate2D)location completionBlock:(NWisStreetViewCompletionBlock)completionBlock
{
    NSString *loc = [NSString stringWithFormat:@"%.10f,%.10f&", location.latitude, location.longitude];
    NWisStreetViewCompletionBlock completeBlock = [completionBlock copy];
    
    
    NSString *connectionString = [NSString stringWithFormat:@"http://cbk0.google.com/cbk?output=json&ll=%@", loc];
    NSLog(@"connect to: %@",connectionString);
    
    [URLConnection asyncConnectionWithURLString:connectionString
                                completionBlock:^(NSData *data, NSURLResponse *response)
     {
         NSLog(@"Data length %d", [data length]);
         NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         //NSLog(@"%@", json);
         
         if([json objectForKey:@"Location"] == nil)
             completeBlock(@"", nil);
         
         //NSLog(@"panoId: %@",[[json objectForKey:@"Location"] objectForKey:@"panoId"]);
         
         completeBlock([[json objectForKey:@"Location"] objectForKey:@"panoId"], nil);
     }
                                     errorBlock:^(NSError *error)
     {
         
         NSMutableDictionary* details = [NSMutableDictionary dictionary];
         [details setValue:[error description] forKey:NSLocalizedDescriptionKey];
         // populate the error object with the details
         NSError *err = [NSError errorWithDomain:@"world" code:200 userInfo:details];
         
         completeBlock(NO, err);
         
         
     }];
}


-(BOOL)isIphone5
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 960) {
                //NSLog(@"iPhone 4 Resolution");
                return NO;
            }
            if(result.height == 1136) {
                //NSLog(@"iPhone 5 Resolution");
                //[[UIScreen mainScreen] bounds].size =result;
                return YES;
            }
        }
        else{
            // NSLog(@"Standard Resolution");
            return NO;
        }
    }
    return NO;
}


-(void)getInstagramAround:(double)lat lng:(double)lng completionBlock:(NWgetInstagramAroundCompletionBlock)completionBlock
{
    NWgetInstagramAroundCompletionBlock completeBlock = [completionBlock copy];
    NSMutableArray *result = [NSMutableArray new];

    
    NSString *connectionString = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/search?lat=%f&lng=%f&client_id=e6c25413297343d087a7918f284ce83e&distance=5000", lat, lng];
    NSLog(@"%@", connectionString);
    NSURL *url = [NSURL URLWithString:connectionString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation;
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        completeBlock(nil, error);
    }];
    
    [operation start];
    
}

- (void)getTwitterAround:(double)lat lng:(double)lng completionBlock:(NWgetTwitterAroundCompletionBlock)completionBlock
{
    NWgetTwitterAroundCompletionBlock completeBlock = [completionBlock copy];

    NSMutableArray *result = [NSMutableArray new];
    // Request access to the Twitter accounts
    //ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    //ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    //[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        //if (granted) {
            //NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            //if (accounts.count > 0)
            //{
                //ACAccount *twitterAccount = [accounts objectAtIndex:0];
                // Creating a request to get the info about a user on Twitter
    
                NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
                [componentsToSubtract setDay:-5];
    
                NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
    
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://search.twitter.com/search.json?"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.6f,%.6f,0.2km", lat, lng], @"geocode", @"100", @"rpp", nil]];
                //[twitterInfoRequest setAccount:twitterAccount];
                // Making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        // Check if there was an error
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        // Check if there is some response data
                        if (responseData) {
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            // Filter the preferred data
                            //NSLog(@"%@", TWData);
                            
                            
                            NSMutableArray *results = [((NSDictionary *)TWData) objectForKey:@"results"];
                            for(NSMutableDictionary *dict in results)
                            {
                                NWtwitter *twi = [[NWtwitter alloc] initWithDictionary:dict];
                                [result addObject:twi];
                            }
                            
                            completeBlock(result, nil);
                            /*NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                             NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                             int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                             int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                             int tweets = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                             NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                             NSString *bannerImageStringURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                             // Update the interface with the loaded data
                             nameLabel.text = name;
                             usernameLabel.text= [NSString stringWithFormat:@"@%@",screen_name];
                             tweetsLabel.text = [NSString stringWithFormat:@"%i", tweets];
                             followingLabel.text= [NSString stringWithFormat:@"%i", following];
                             followersLabel.text = [NSString stringWithFormat:@"%i", followers];
                             NSString *lastTweet = [[(NSDictionary *)TWData objectForKey:@"status"] objectForKey:@"text"];
                             lastTweetTextView.text= lastTweet;
                             // Get the profile image in the original resolution
                             profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                             [self getProfileImageForURLString:profileImageStringURL];
                             // Get the banner image, if the user has one
                             if (bannerImageStringURL) {
                             NSString *bannerURLString = [NSString stringWithFormat:@"%@/mobile_retina", bannerImageStringURL];
                             [self getBannerImageForURLString:bannerURLString];
                             } else {
                             bannerImageView.backgroundColor = [UIColor underPageBackgroundColor];
                             }*/
                        }
                    });
                }];
            //}
        //} else {
           // NSLog(@"No access granted");
        //}
   // }];
    
}





+(id)sharedInstance
{
    static dispatch_once_t pred;
    static NWManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NWManager alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc
{

    abort();
}






@end
