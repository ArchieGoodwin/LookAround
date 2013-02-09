//
//  Searches.h
//  LookAround
//
//  Created by Sergey Dikarev on 2/8/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Searches : NSManagedObject

@property (nonatomic, retain) NSDate * dateSearhed;
@property (nonatomic, retain) NSString * searchStr;
@property (nonatomic, retain) NSNumber * searchType;

@end
