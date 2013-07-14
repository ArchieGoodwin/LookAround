//
//  WPItem.m
//  WP4square
//
//  Created by Sergey Dikarev on 8/17/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import "NWItem.h"

@implementation NWItem
@synthesize itemDistance, itemId, itemName, itemLat, itemLng, iconUrl, appIcon;

-(NWItem *)initWithDictionary:(NSMutableDictionary *)dict
{
    
/*
 @property (nonatomic, strong) NSString *canonicalUrl;
 @property (nonatomic, strong) NSString *formattedPhone;
 @property (nonatomic, strong) NSString *twitter;
 @property (nonatomic, assign) NSInteger hereNow;
 @property (nonatomic, strong) NSString *status;
 @property (nonatomic, assign) NSInteger likes;
 @property (nonatomic, strong) NSDictionary *location;
 @property (nonatomic, assign) NSInteger *rating;
 
 @property (nonatomic, assign) NSInteger checkinsCount;
 @property (nonatomic, assign) NSInteger userCount;
 */
        
        //NSLog(@"%@", dict);
        if(dict != nil)
        {
            
            @try {
                self.itemName = [dict  objectForKey:@"name"];
                self.itemId = [dict objectForKey:@"id"];
                if([dict objectForKey:@"categories"] != nil && ((NSArray *)[dict objectForKey:@"categories"]).count > 0)
                {
                    NSString *url = [[[[dict objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"prefix"];
                    NSString *ext = [[[[dict objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"suffix"];
                    NSString *fullUrl = [NSString stringWithFormat:@"%@%@", [url substringToIndex:[url length]-1], ext];
                    self.iconUrl = fullUrl;

                }
                   
               if([[dict objectForKey:@"location"] objectForKey:@"distance"] != [NSNull null])
               {
                   self.itemDistance = [[[dict objectForKey:@"location"] objectForKey:@"distance"] integerValue];

               }
                if([[dict objectForKey:@"location"] objectForKey:@"lat"] != [NSNull null])
                {
                    self.itemLat = [[[dict objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                    self.itemLng = [[[dict objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                }


                
                
                _canonicalUrl = [dict objectForKey:@"canonicalUrl"];
                _formattedPhone = [[dict objectForKey:@"contact"] objectForKey:@"formattedPhone"];
                _twitter = [[dict objectForKey:@"contact"] objectForKey:@"twitter"];
                _hereNow = [[[dict objectForKey:@"hereNow"] objectForKey:@"count"] integerValue];
                _status = [[dict objectForKey:@"hours"] objectForKey:@"status"];
                _likes = [[[dict objectForKey:@"likes"] objectForKey:@"count"] integerValue];
                _location = [dict objectForKey:@"location"];
                _rating = [[dict objectForKey:@"rating"] floatValue];
                _checkinsCount = [[[dict objectForKey:@"stats"] objectForKey:@"checkinsCount"] integerValue];
                _userCount = [[[dict objectForKey:@"stats"] objectForKey:@"usersCount"] integerValue];
                _venueId = [[dict objectForKey:@"venuePage"] objectForKey:@"id"];
                _city = [[dict objectForKey:@"location"] objectForKey:@"city"];

                return self;
            }
            @catch (NSException *exception) {
                NSLog(@"Error while creating NWItem %@", exception.description);
                return nil;
            }
            @finally {
                
            }
            
            
            
        }

    
    return nil;
}

-(NWItem *)initWithFields:(NSString *)name lat:(double)lat lng:(double)lng
{

        
        @try {
            self.itemName = name;
            self.itemId = @"newoneid";
            self.itemDistance = 0;
            self.itemLat = lat;
            self.itemLng = lng;
            self.iconUrl = @"";
            
            return self;
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            
        }
        
        

    
    
    return nil;
}



@end
