//
//  NWinstagram.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/22/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWinstagram : NSObject

@property (nonatomic,strong) NSDate *created_time;

@property (nonatomic, retain) NSString *instaLink;
@property (nonatomic, retain) NSString *instaPhoto;

@property (nonatomic, retain) NSString *instaId;
@property (nonatomic, assign) NSInteger itemDistance;
@property (nonatomic, assign) double itemLat;
@property (nonatomic, assign) double itemLng;


-(NWinstagram *)initWithDictionary:(NSMutableDictionary *)dict;
@end
