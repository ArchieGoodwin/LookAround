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
#import "InstagramCollectionViewController.h"
#import "NWFourSquarePhoto.h"
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
        
    
    
    _mediaFocusManager = [[ASMediaFocusManager alloc] init];
    _mediaFocusManager.delegate = self;
    [_mediaFocusManager installOnViews:@[self.imageView]];
    
    
}

-(void) setFour:(NWFourSquarePhoto *)photo {
    
    
    
    if(_four != photo) {
        _four = photo;
    }
    
    
    UIImage* image = [UIImage imageNamed:@"Placeholder.png"];
    [self.imageView setImageWithURL:[NSURL URLWithString:_four.photoUrlFull] placeholderImage:image];
    
    
    
    _mediaFocusManager = [[ASMediaFocusManager alloc] init];
    _mediaFocusManager.delegate = self;
    [_mediaFocusManager installOnViews:@[self.imageView]];
    
    
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    // apply custom attributes...
    [self setNeedsDisplay]; // force drawRect:
}

#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediafocus imageForView:(UIView *)view
{
    //NSLog(@"%@",((UIImageView *)view).image);
    return ((UIImageView *)view).image;
    //ChaingeItem *item = _chaingeItems[currentIndex];
    //return [self imageRotated:[UIImage imageWithData:item.image.value] c:item.chainge];
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediafocus finalFrameforView:(UIView *)view
{
    //return appDelegate.mainViewController.view.bounds;
    return [NWHelper isIphone5] ? CGRectMake(0, 0, 320, 456) :  CGRectMake(0, 0, 320, 380);
    
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediafocus
{
    //NWAppDelegate* myDelegate = (((NWAppDelegate*) [UIApplication sharedApplication].delegate));
    
    //NSLog(@"%@", [_controller.storyboard instantiateViewControllerWithIdentifier:@"locationController"]);
    if(_controller)
        return _controller;
    if(_fourController)
        return _fourController;
    
    return nil;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediafocus mediaPathForView:(UIView *)view
{
    
    return @"";
}




@end
