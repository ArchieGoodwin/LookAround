//
//  PendingOperations.m
//  chainges
//
//  Created by Sergey Dikarev on 1/23/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations
@synthesize downloadsInProgress = _downloadsInProgress;
@synthesize downloadQueue = _downloadQueue;



-(PendingOperations *)initWithName:(NSString *)opername
{
    if (!self) {
        self = [[PendingOperations alloc] init];
        self.queueName = opername;
    }
    return self;
}

- (NSMutableDictionary *)downloadsInProgress {
    if (!_downloadsInProgress) {
        _downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _downloadsInProgress;
}

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = self.queueName;
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    return _downloadQueue;
}

@end
