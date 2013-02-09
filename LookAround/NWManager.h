//
//  NWManager.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/8/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Searches.h"
#import "Defines.h"
typedef void (^ChGetLocationsBySearchString)(NSArray *result, NSError *error);
typedef void (^WPgetPOIsCompletionBlock)        (NSArray *result, NSError *error);
typedef void (^NWisStreetViewCompletionBlock)        (NSString *panoIdOfPlace, NSError *error);

@interface NWManager : NSObject <CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;

+(id)sharedInstance;
-(void)getLocationsForSearchString:(NSString *)searchStr completionBlock:(ChGetLocationsBySearchString)completionBlock;
-(void)poisNearLocation:(CLLocationCoordinate2D)location completionBlock:(WPgetPOIsCompletionBlock)completionBlock;
-(Searches *)createSearchRequest:(NSString *)request searchType:(int)searchType;
-(void)startUpdateLocation;
-(NSDictionary *)createDict:(NSString *)locName lat:(double)lat lng:(double)lng;
-(void)isStreetViewAvailable:(CLLocationCoordinate2D)location completionBlock:(NWisStreetViewCompletionBlock)completionBlock;
@end
