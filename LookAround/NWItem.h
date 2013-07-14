//
//  WPItem.h
//  WP4square
//
//  Created by Sergey Dikarev on 8/17/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWItem : NSObject
{
    NSString *itemName;
    NSString *itemId;
    NSInteger itemDistance;
    double itemLat;
    double itemLng;
    NSString *iconUrl;
     UIImage *appIcon;
}
@property (nonatomic, retain) UIImage *appIcon;

@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *iconUrl;

@property (nonatomic, retain) NSString *itemId;
@property (nonatomic, assign) NSInteger itemDistance;
@property (nonatomic, assign) double itemLat;
@property (nonatomic, assign) double itemLng;


@property (nonatomic, strong) NSString *canonicalUrl;
@property (nonatomic, strong) NSString *formattedPhone;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, assign) NSInteger hereNow;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, strong) NSDictionary *location;
@property (nonatomic, assign) float rating;

@property (nonatomic, assign) NSInteger checkinsCount;
@property (nonatomic, assign) NSInteger userCount;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *city;



-(NWItem *)initWithDictionary:(NSMutableDictionary *)dict;
-(NWItem *)initWithFields:(NSString *)name lat:(double)lat lng:(double)lng;
@end
