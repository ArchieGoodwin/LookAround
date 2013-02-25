//
//  ChaingeCell.m
//  chainges
//
//  Created by Sergey Dikarev on 11/8/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import "InstagramCell.h"
#import "Defines.h"
#import "AFNetworking.h"
#import "NWinstagram.h"
@implementation InstagramCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"InstagramCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) { return nil; }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) { return nil; }
        
        self = [arrayOfViews objectAtIndex:0];
        

    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setInsta:(NWinstagram *)instaGram {
    
    
    if(_insta != instaGram) {
        _insta = instaGram;
    }
    
    
    UIImage* image = [UIImage imageNamed:@"Placeholder.png"];
    [self.imageView setImageWithURL:[NSURL URLWithString:_insta.instaPhoto] placeholderImage:image];
        
    
    
    
    
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    // apply custom attributes...
    [self setNeedsDisplay]; // force drawRect:
}



@end
