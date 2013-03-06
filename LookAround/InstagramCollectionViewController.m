//
//  ChaingesCollectionViewController.m
//  chainges
//
//  Created by Sergey Dikarev on 1/16/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "InstagramCollectionViewController.h"
#import "StackedGridLayout.h"
#import "InstagramCell.h"
#import "Defines.h"
#import "NWinstagram.h"

@interface InstagramCollectionViewController ()

@end

@implementation InstagramCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back
{
    self.collectionView = nil;
    [self.view removeFromSuperview];

    [self removeFromParentViewController];

}

-(void)realInit:(CGRect)rect
{
    
    self.view = [[UIView alloc] initWithFrame:rect];

    self.view.backgroundColor = [UIColor whiteColor];
   /* UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(7, 3, 44, 44);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"09-arrow-west.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];*/


    isScrolling = NO;
    pageSize = 50;
    page = 1;
    isLoadingPage = YES;
    currentChaingeItemIndex = -1;


    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];


    [_collectionView setAllowsSelection:YES];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;


    self.layout3 = [[StackedGridLayout alloc] init];
    self.layout3.headerHeight = 0;
    self.layout3.footerHeight = 60;

    self.collectionView.collectionViewLayout = self.layout3;

    [self.collectionView registerClass:[InstagramCell class] forCellWithReuseIdentifier:@"myChaingeCell"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"FlickrPhotoHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FlickrPhotoHeaderView"];

    [self.view addSubview:self.collectionView];
    
    
    /*UISwipeGestureRecognizer *showExtrasSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeRight:)];
    showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:showExtrasSwipe];
    
    UISwipeGestureRecognizer *showExtrasSwipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeLeft:)];
    showExtrasSwipe2.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:showExtrasSwipe2];*/
    
    [self.collectionView reloadData];

    

    
    //[self getChainges];
}

-(void)initCollectionViewWithRect:(CGRect)rect instas:(NSMutableArray *)instas location:(CLLocation *)location
{
    

    _chainges = instas;

    [self realInit:rect];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}






- (void)showMessageView {
    viewForLabel = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    viewForLabel.backgroundColor = [UIColor whiteColor];
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)] ;
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    lblMessage.text = @"Sorry. There are no Places In Time yet.";
    lblMessage.textColor = [UIColor blackColor];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.alpha = 0;
    [viewForLabel addSubview:lblMessage];
    [self.view addSubview:viewForLabel];

    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];

    lblMessage.alpha = 1;

    [UIView commitAnimations];


}


-(void)hideMessageView
{
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:3];
        [UIView setAnimationDelegate:self];

        viewForLabel.alpha = 0;

        [UIView commitAnimations];


}

- (void)addToArray:(NSArray *)array {
    /*BOOL hasRepeated = NO;
    for (Chainge *chainge in array) {
        if ([_chainges containsObject:chainge]) {
            hasRepeated = YES;
            //break;
        }
        else
        {
            [_chainges addObject:chainge];
        }
    }*/
    
}



- (void)refreshAll {
    if (_currentPageType == SearchPageBy4square) {
        //[appDelegate.manager clearUploadedFlag];
        if (_chainges && page == 1) {
            [_chainges removeAllObjects];
        }

        //[self addToArray:[appDelegate.manager getChaingesSortByDate:page pageSize:pageSize]];

        //[self addToArray:[appDelegate.manager getChaingesSortByDistanceWithPage:page pageSize:pageSize userId:appDelegate.manager.userId loc:_searchLocation]];

        [self.collectionView reloadData];
        // isLoadingPage = NO;


    }
    [self stopActivityInFooter];
}




- (void)viewWillAppear:(BOOL)animated {


    currentChaingeItemIndex = -1;



    [super viewWillAppear:animated];

    //[self updatedLocation];


}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_chainges count];
}

// 2
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 3

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isScrolling = YES;
    isLoadingPage = NO;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        isScrolling = NO;
        //isLoadingPage = NO;
        NSLog(@"scrollViewDidEndDragging");

        //[self updatedLocation];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isScrolling = NO;
    //isLoadingPage = NO;
    NSLog(@"scrollViewDidEndDecelerating");
   // [self updatedLocation];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    InstagramCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"myChaingeCell" forIndexPath:indexPath];

    NSInteger row = [indexPath row];
    NWinstagram *ch = [_chainges objectAtIndex:row];
    cell.insta = ch;
    cell.controller = self;
    cell.tag = indexPath.row;

    

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    //[appDelegate.mainViewController continueChainge:row chaingesArray:_chaingesArray];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark - StackedGridLayoutDelegate
- (NSInteger)collectionView:(UICollectionView *)cv
                     layout:(UICollectionViewLayout *)cvl
   numberOfColumnsInSection:(NSInteger)section {
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)cv
                        layout:(UICollectionViewLayout *)cvl
   itemInsetsForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 4, 6, 2);
}

- (CGSize)collectionView:(UICollectionView *)cv
                  layout:(UICollectionViewLayout *)cvl
    sizeForItemWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    //Chainge *ch = [_chainges objectAtIndex:row];

    //ChaingeItem *item = [appDelegate.manager getf:ch];


    //UIImage *photo = [self imageRotated:[UIImage imageWithData:item.image.thumbvalue] c:ch];


    CGSize imageSize = CGSizeMake(100,
            100);

    CGSize picSize = 100 > 0.0f ?
            imageSize : CGSizeMake(100.0f, 100.0f);
    picSize.height += 10.0f;
    picSize.width += 10.0f;

    CGSize retval =
            CGSizeMake(width,
                    picSize.height * width / picSize.width);
    return retval;
}

- (void)stopActivityInFooter {
    if (activityIndicator) {
        activityIndicator.hidden = YES;
        [activityIndicator stopAnimating];
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)cv
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoHeaderView *headerView =
            [cv dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                   withReuseIdentifier:@"FlickrPhotoHeaderView" forIndexPath:indexPath];

    NSLog(@"indexPath.row = %i, %i", indexPath.row, indexPath.section);
    /*if (!isLoadingPage) {

        headerView.activityIndicator.hidden = NO;
        [headerView.activityIndicator startAnimating];
        isLoadingPage = YES;
        page = page + 1;
        activityIndicator = headerView.activityIndicator;
        [self getChainges];


    }*/

    return headerView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
