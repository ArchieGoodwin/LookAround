//
//  NWtwitter.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/11/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWtwitter.h"

@implementation NWtwitter
@synthesize itemDistance, author, message, itemLat, itemLng, iconUrl, appIcon, dateCreated;

-(NWtwitter *)initWithDictionary:(NSMutableDictionary *)dict
{
    
    
    
    //NSLog(@"%@", dict);
    if(dict != nil)
    {
        
        @try {
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
            self.dateCreated = [dateFormatter dateFromString:[dict objectForKey:@"created_at"]];
            
            self.author = [dict  objectForKey:@"from_user"];
            self.message = [dict objectForKey:@"text"];
            NSString *url = [dict objectForKey:@"profile_image_url"];
            //self.itemDistance = [[[dict objectForKey:@"location"] objectForKey:@"distance"] integerValue];
            self.iconUrl = url;
            
            return self;
        }
        @catch (NSException *exception) {
            NSLog(@"Error while creating NWtwitter %@", exception.description);
            return nil;
        }
        @finally {
            
        }
        
        
        
    }
    
    
    return nil;
}
@end
