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


-(NWItem *)initWithDictionary:(NSMutableDictionary *)dict;
-(NWItem *)initWithFields:(NSString *)name lat:(double)lat lng:(double)lng;
@end
