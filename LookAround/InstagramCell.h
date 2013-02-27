//
//  ChaingeCell.h
//  chainges
//
//  Created by Sergey Dikarev on 11/8/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMediaFocusManager.h"
#import "InstagramCollectionViewController.h"
#import "NWFourSquareViewController.h"
@class NWinstagram;
@class NWFourSquarePhoto;
@interface InstagramCell : UICollectionViewCell <ASMediasFocusDelegate>
{
}
@property(strong, nonatomic) IBOutlet UIImageView *available;

@property (weak, nonatomic) IBOutlet UIView *viewPort;
@property (weak, nonatomic) IBOutlet UIView *viewHor;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewHor;
@property (strong, nonatomic) IBOutlet UILabel *lblDebug;
@property (weak, nonatomic) IBOutlet UIImageView *locVertical;
@property (weak, nonatomic) IBOutlet UIImageView *locHorizontal;
@property (assign) NSInteger currentItemIndex;
@property (nonatomic, strong) NWinstagram  *insta;

@property (nonatomic, strong) NWFourSquarePhoto  *four;
@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;
@property (strong, nonatomic) InstagramCollectionViewController *controller;
@property (strong, nonatomic) NWFourSquareViewController *fourController;

-(void) setInsta:(NWinstagram *)instaGram ;

-(void) setFour:(NWFourSquarePhoto *)photo ;

@end
