//
//  NWWeather.m
//  LookAround
//
//  Created by Sergey Dikarev on 3/19/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWWeather.h"

@implementation NWWeather

-(NWWeather *)initWithDictionary:(NSMutableDictionary *)dict
{
    
    
    
    //NSLog(@"%@", dict);
    if(dict != nil)
    {
        
        @try {
            NSArray *ar = [dict objectForKey:@"current_condition"];
             NSDictionary *temp = [ar objectAtIndex:0];
            _temp_C = [NSString stringWithFormat:@"%@C", [temp objectForKey:@"temp_C"]];
            _temp_F = [NSString stringWithFormat:@"%@F", [temp objectForKey:@"temp_F"]];
            
            
            NSArray *arr = [temp objectForKey:@"weatherIconUrl"];
            NSDictionary *urlDict = [arr objectAtIndex:0];
            _weatherIconUrl = [NSString stringWithFormat:@"%@", [urlDict objectForKey:@"value"]];
          
            
            return self;
        }
        @catch (NSException *exception) {
            NSLog(@"Error while creating NWWeather %@", exception.description);
            return nil;
        }
        @finally {
            
        }
        
        
        
    }
    
    
    return nil;
}
@end
