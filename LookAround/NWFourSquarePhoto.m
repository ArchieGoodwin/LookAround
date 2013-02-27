//
//  NWFourSquarePhoto.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/27/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWFourSquarePhoto.h"

@implementation NWFourSquarePhoto


-(NWFourSquarePhoto *)initWithDictionary:(NSMutableDictionary *)dict
{
    
    
    
    NSLog(@"%@", dict);
    if(dict != nil)
    {
        
        @try {
            
            _photoUrl110 = [NSString stringWithFormat:@"%@110x110%@", [dict objectForKey:@"prefix"] , [dict objectForKey:@"suffix"]];
            _photoUrlFull = [NSString stringWithFormat:@"%@original%@", [dict  objectForKey:@"prefix"] , [dict objectForKey:@"suffix"]];
        
            _height = [[dict  objectForKey:@"height"] integerValue];

            _width = [[dict  objectForKey:@"width"] integerValue];

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
