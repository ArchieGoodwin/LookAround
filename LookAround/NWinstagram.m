//
//  NWinstagram.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/22/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWinstagram.h"

@implementation NWinstagram


-(NWinstagram *)initWithDictionary:(NSMutableDictionary *)dict
{
    
    
    
    //NSLog(@"NWinstagram dict: %@", dict);
    if(dict != nil)
    {
        
        @try {
            
            //NSLog(@"%@", [dict objectForKey:@"created_time"]);
            _created_time = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_time"] integerValue]];
            _instaId = [dict objectForKey:@"id"];
            NSString *url = [[[dict objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
            _instaPhoto = url;
            self.itemLat = [[[dict objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
            self.itemLng = [[[dict objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
            
            return self;
        }
        @catch (NSException *exception) {
            NSLog(@"Error while creating NWinstagram %@", exception.description);
            return nil;
        }
        @finally {
            
        }
        
        
        
    }
    
    
    return nil;
}


@end
