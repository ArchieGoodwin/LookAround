//
//  FlickrPhotoHeaderView.m
//  FlickrSearch
//
//  Created by Fahim Farook on 24/7/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "FlickrPhotoHeaderView.h"
#import "Defines.h"
@interface FlickrPhotoHeaderView ()
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *searchLabel;
@end

@implementation FlickrPhotoHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialise];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialise];
}

- (void)initialise {
    //UIImage *shareButtonImage = [[UIImage imageNamed:@"header_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(89.0f, 52.0f, 0.0f, 54.0f)];
    //self.backgroundImageView.image = shareButtonImage;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimate) name:chGetChaingesByDate object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimate) name:chGetChaingesByDateEmpty object:nil];
    _activityIndicator.hidden = YES;

}

-(void)stopAnimate
{
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //CGRect bounds = self.bounds;
    
    //[self.searchLabel sizeToFit];
    //self.searchLabel.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f);
    
    //CGFloat bgImgWidth = self.searchLabel.bounds.size.width + 106.0f;
    //self.backgroundImageView.frame = CGRectMake((bounds.size.width - bgImgWidth) / 2.0f, 0.0f, bgImgWidth, 89.0f);
}

- (void)setSearchText:(NSString *)text {
    //self.searchLabel.text = text;
    [self setNeedsLayout];
}

@end
