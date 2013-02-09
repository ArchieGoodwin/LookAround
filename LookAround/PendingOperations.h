//
//  PendingOperations.h
//  chainges
//
//  Created by Sergey Dikarev on 1/23/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject


@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, strong) NSString * queueName;

-(PendingOperations *)initWithName:(NSString *)opername;
@end
