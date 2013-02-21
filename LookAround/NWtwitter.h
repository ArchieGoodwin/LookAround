//
//  NWtwitter.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/11/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWtwitter : NSObject
{
    NSString *author;
    NSString *message;
    NSInteger itemDistance;
    double itemLat;
    double itemLng;
    NSString *iconUrl;
    UIImage *appIcon;
    NSDate *dateCreated;
}
@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, strong)  NSDate *dateCreated;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *iconUrl;

@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) NSInteger itemDistance;
@property (nonatomic, assign) double itemLat;
@property (nonatomic, assign) double itemLng;


-(NWtwitter *)initWithDictionary:(NSMutableDictionary *)dict;
@end
