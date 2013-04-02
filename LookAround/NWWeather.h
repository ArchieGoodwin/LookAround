//
//  NWWeather.h
//  LookAround
//
//  Created by Sergey Dikarev on 3/19/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWWeather : NSObject

@property (nonatomic, strong) NSString *temp_C;
@property (nonatomic, strong) NSString *temp_F;
@property (nonatomic, strong) NSString *weatherIconUrl;

-(NWWeather *)initWithDictionary:(NSMutableDictionary *)dict;

@end
