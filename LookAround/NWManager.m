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
    
    [URLConnection asyncConnectionWithURLString:connectionString
                                completionBlock:^(NSData *data, NSURLResponse *response) {
                                    NSLog(@"Data length %d", [data length]);
                                    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                    NSLog(@"%@", json);
                                    NSMutableArray *pois = [[NSMutableArray alloc] init];
                                    
                                    //if([[json objectForKey:@"numResults"] integerValue] > 0)
                                    //{
                                    NSMutableArray *items = [[[[json objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
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
                                    
                                    
                                }
                                     errorBlock:^(NSError *error) {
                                         
                                         NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                         [details setValue:[error description] forKey:NSLocalizedDescriptionKey];
                                         // populate the error object with the details
                                         NSError *err = [NSError errorWithDomain:@"world" code:200 userInfo:details];
                                         
                                         completeBlock(nil, err);
                                         
                                     }];
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
