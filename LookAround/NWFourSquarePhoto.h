//
//  NWFourSquarePhoto.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/27/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWFourSquarePhoto : NSObject


@property (nonatomic, strong) NSString *photoUrl110;

@property (nonatomic, strong) NSString *photoUrlFull;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) NSInteger width;


-(NWFourSquarePhoto *)initWithDictionary:(NSMutableDictionary *)dict;
@end
