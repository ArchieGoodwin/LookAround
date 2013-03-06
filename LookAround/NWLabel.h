//
//  NWLabel.h
//  LookAround
//
//  Created by Sergey Dikarev on 3/4/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface NWLabel : UILabel
{
    @private  VerticalAlignment _verticalAlignment;
}

@property (nonatomic, readwrite, assign) VerticalAlignment verticalAlignment;


@end
