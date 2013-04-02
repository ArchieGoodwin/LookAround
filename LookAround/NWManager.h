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
#import "NWWeather.h"
#import "BZFoursquare.h"
typedef void (^ChGetLocationsBySearchString)(NSArray *result, NSError *error);
typedef void (^WPgetPOIsCompletionBlock)        (NSArray *result, NSError *error);
typedef void (^WPphotosByVenueIdCompletionBlock)        (NSArray *result, NSError *error);

typedef void (^NWisStreetViewCompletionBlock)        (NSString *panoIdOfPlace, NSError *error);
typedef void (^NWgetTwitterAroundCompletionBlock)        (NSArray *result, NSError *error);
typedef void (^NWgetInstagramAroundCompletionBlock)        (NSMutableArray *result, NSError *error);
typedef void (^NWgetWeatherAroundCompletionBlock)        (NWWeather *weather, NSError *error);
typedef void (^NWgetStreetViewImageCompletionBlock)        (UIImage *imageView, NSError *error);


@interface NWManager : NSObject <CLLocationManagerDelegate>
@property(nonatomic, strong) BZFoursquare *foursquare;


@property (nonatomic, strong) CLLocationManager *locationManager;

+(id)sharedInstance;
-(void)getLocationsForSearchString:(NSString *)searchStr completionBlock:(ChGetLocationsBySearchString)completionBlock;
-(void)poisNearLocation:(CLLocationCoordinate2D)location completionBlock:(WPgetPOIsCompletionBlock)completionBlock;
-(Searches *)createSearchRequest:(NSString *)request searchType:(int)searchType;
-(void)startUpdateLocation;
-(NSDictionary *)createDict:(NSString *)locName lat:(double)lat lng:(double)lng;
-(void)isStreetViewAvailable:(CLLocationCoordinate2D)location completionBlock:(NWisStreetViewCompletionBlock)completionBlock;
-(BOOL)isIphone5;
- (void)getTwitterAround:(double)lat lng:(double)lng completionBlock:(NWgetTwitterAroundCompletionBlock)completionBlock;
-(void)getInstagramAround:(double)lat lng:(double)lng completionBlock:(NWgetInstagramAroundCompletionBlock)completionBlock;
-(UIButton *)createButtonWithImageAndText:(NSString *)imageName text:(NSString *)text action:(SEL)action tag:(NSInteger)tag frame:(CGRect)frame target:(id)target;
- (UIImage *)radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius ;
-(void)photosByVenueId:(NSString *)venueId completionBlock:(WPphotosByVenueIdCompletionBlock)completionBlock;
-(void)addLabelWithText:(NSString *)text toView:(UIView *)toView rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color;
-(void)addLabelMultiLineWithText:(NSString *)text toView:(UIView *)toView rect:(CGRect)rect font:(UIFont *)font;
-(void)getWeatherAround:(double)lat lng:(double)lng completionBlock:(NWgetWeatherAroundCompletionBlock)completionBlock;
-(void)getStreetViewImageByLastAndLng:(double)lat lng:(double)lng completionBlock:(NWgetStreetViewImageCompletionBlock)completionBlock;
-(void)createPredefinedSearches;
-(id)getSettingsValue:(NSString *)key;
-(void)saveToUserDefaults:(id)object key:(NSString *)key;
@end
