//
//  SearchViewController.m
//  chainges
//
//  Created by Sergey Dikarev on 1/15/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "SearchViewController.h"
#import "Defines.h"
#import <MapKit/MapKit.h>
#import "NWItem.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "Searches.h"
#import "AFNetworking.h"
#import "NWLocationViewController.h"
#import "NWMapViewController.h"
@interface SearchViewController ()
{
    CLPlacemark *placemark;
    double latitude;
    double longitude;
    NSDictionary *currentLocation;
    MBProgressHUD *HUD;
    UIBarButtonItem *btnMap;
}
@end

@implementation SearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)showHUD
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:HUD];
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
}

-(void)hideHUD
{
    [HUD hide:YES];
    
}


- (void)viewDidLoad
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedLocation) name:chLocationMuchUpdated object:nil];

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *btnLoc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"74-location.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchMyLocation:)];

    self.navigationItem.leftBarButtonItem = btnLoc;

    self.navigationItem.backBarButtonItem = nil;
        
    
    UIImage *image = [[UIImage imageNamed:@"bar.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self showOrHideBtnMap:NO];

    _currentPageType = SearchPagePastSearches;
    _searchResult = [NSMutableArray new];
    for (UIView * v in _searchBar.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            v.superview.alpha = 0;
            UIView *containerView = [[UIView alloc] initWithFrame:_searchBar.frame];
            [containerView addSubview:v];
            [self.tableView addSubview:containerView];

        }
    }
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.navigationItem.title = @"LookAround";
    [super viewDidLoad];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)updatedLocation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:chLocationMuchUpdated object:nil];

    [NWHelper poisNearLocation:CLLocationCoordinate2DMake([NWHelper locationManager].location.coordinate.latitude, [NWHelper locationManager].location.coordinate.longitude) completionBlock:^(NSArray *result, NSError *error) {
        if(!error)
        {
            _searchResult = [NSMutableArray arrayWithArray:result];
            
            [self.tableView reloadData];
            
            
            
            [NWHelper photosByVenueId:@"4ac518c5f964a520cba420e3" completionBlock:^(NSArray *result, NSError *error) {
                NSLog(@"here");
            }];
            
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)searchMyLocation:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self showHUD];
    _currentPageType = SearchPageBy4square;
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:[NWHelper locationManager].location completionHandler:^(NSArray *placemarks, NSError *error) {
        placemark = [placemarks objectAtIndex:0];
        NSLog(@"Placemark: %@", placemark.addressDictionary);
        [NWHelper poisNearLocation:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) completionBlock:^(NSArray *result, NSError *error) {
            if(!error)
            {
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemDistance" ascending:YES selector:@selector(compare:)];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                _searchResult = [NSMutableArray arrayWithArray:[result sortedArrayUsingDescriptors:sortDescriptors]];
                
                [self.tableView reloadData];
                
                [self showOrHideBtnMap:YES];
                
            }
            
            [self hideHUD];
            
        }];
    }];
}

-(void)showOrHideBtnMap:(BOOL)show
{
    NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
    
    if(show)
    {
        // This is how you add the button to the toolbar and animate it
        if (![toolbarButtons containsObject:_btnMap]) {

            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_btnMap, nil]];
            
        }
    }
    else
    {
        // This is how you remove the button from the toolbar and animate it
        [toolbarButtons removeObject:_btnMap];
        
        [self.navigationItem setRightBarButtonItems:toolbarButtons];
    }
    
    
    
    
    
}


-(void)searchByString:(NSString *)str
{
    [self.searchBar resignFirstResponder];
    
    /*if(NSClassFromString(@"MKLocalSearchRequest") != nil)
    {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        if([request respondsToSelector:@selector(naturalLanguageQuery)])
        {
            request.naturalLanguageQuery = _searchBar.text;
            MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
            
            [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
                
                NSLog(@"mapsearch results %i", searchResult.count);

                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if(!error)
                {
                    searchResult = [NSMutableArray arrayWithArray:response.mapItems];
                    NSLog(@"mapsearch results %i", searchResult.count);
                    _currentPageType = SearchNewType;
                    [self.tableView reloadData];
                    
                }
                else
                {
                    NSLog(@"error MKLocalSearch: %@", error.description);
                }
            }];
        }
    }
    else
    {*/
    
    [self showHUD];
        [NWHelper getLocationsForSearchString:str completionBlock:^(NSArray *result, NSError *error) {
            
            if(result.count > 0)
            {
                placemark = [result objectAtIndex:0];
                NSLog(@"Placemark: %@", placemark.addressDictionary);
                [NWHelper poisNearLocation:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) completionBlock:^(NSArray *result, NSError *error) {
                    if(!error)
                    {
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemDistance" ascending:YES selector:@selector(compare:)];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        _searchResult = [NSMutableArray arrayWithArray:[result sortedArrayUsingDescriptors:sortDescriptors]];
                        
                        [self.tableView reloadData];
                        
                        [self showOrHideBtnMap:YES];
                       
                    }
                    
                    [self hideHUD];

                }];
                
                
            }
            else
            {
                //no placemark
                 [self hideHUD];
                
            }
            
            
            
        }];
    //}
   
    
    
    
    
    
    
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{

    
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

        _currentPageType = SearchPageBy4square;
        [NWHelper createSearchRequest:searchBar.text searchType:SearchPageBy4square];
        [self searchByString:searchBar.text];


}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //if(self.result != nil  && [self.result count] > 0)
    //{
    if([searchText isEqualToString:@""])
    {
        [_searchResult removeAllObjects];
        placemark = nil;
        _currentPageType = SearchPagePastSearches;
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
        
        [self showOrHideBtnMap:NO];
    }
    
    //}
}




#pragma mark - Seque

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"ViewLocation"])
    {
        NWLocationViewController *controller = (NWLocationViewController *)segue.destinationViewController;
     
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NWItem *item = [_searchResult objectAtIndex:cell.tag];
        NSDictionary *dict = [NWHelper createDict:item.itemName lat:item.itemLat lng:item.itemLng];
        controller.nwItem = item;
        controller.location = dict;
        
        
    }
    if([segue.identifier isEqualToString:@"ViewLocationAddress"])
    {
        NWLocationViewController *controller = (NWLocationViewController *)segue.destinationViewController;
        NSDictionary *dict = [NWHelper createDict:_searchBar.text lat:placemark.location.coordinate.latitude lng:placemark.location.coordinate.longitude];

        controller.nwItem = nil;
        controller.location = dict;
    }
    
    if([segue.identifier isEqualToString:@"LocView"])
    {
        
        
    }
    if([segue.identifier isEqualToString:@"MapView"])
    {
        NWMapViewController *controller = (NWMapViewController *)segue.destinationViewController;
        controller.items = [_searchResult mutableCopy];
        [controller addAnnotationsToMap];
        
    }
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(_currentPageType == SearchPageBy4square)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(_currentPageType == SearchPageBy4square)
    {
        if(section == 0)
        {
            return 1;
        }
        return _searchResult.count;

    }
    if(_currentPageType == SearchPagePastSearches)
    {
        return [[Searches numberOfEntities] integerValue];
    }
    
    if(_currentPageType == SearchNewType)
    {
        return _searchResult.count;
    }
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentPageType == SearchPageBy4square)
    {

            if(indexPath.section == 1)
            {
                if(_searchResult.count > 0)
                {
                    NWItem *item = [_searchResult objectAtIndex:indexPath.row];
                    
                    
                    return [self getLabelSize:item.itemName fontSize:16] + 20;
                }
                
            }
            else
            {
                if(placemark)
                {
                    NSMutableString *str = [NSMutableString new];
                    for(NSString *line in [placemark.addressDictionary objectForKey:@"FormattedAddressLines"])
                    {
                        [str appendString:line];
                        [str appendString:@","];
                    }
                    
                    return [self getLabelSize:str fontSize:16] + 30;
                }
                
            }

        //}
    }
    else if(_currentPageType == SearchPagePastSearches)
    {
        
        NSArray *array = [Searches findAllSortedBy:@"dateSearhed" ascending:NO];
        if(array.count > 0)
        {
            Searches *search = [array objectAtIndex:indexPath.row];
            return [self getLabelSize:search.searchStr fontSize:16] + 20;

        }
        
    }
    else if(_currentPageType == SearchNewType)
    {
        return 49;
    }
    return 60;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(_currentPageType == SearchPageBy4square)
    {
            if(indexPath.section == 0)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceStartCell"];
                
                for(UIView *inside in cell.contentView.subviews)
                {
                    [inside removeFromSuperview];
                }
                if(placemark != nil)
                {
                    latitude = placemark.location.coordinate.latitude;
                    longitude = placemark.location.coordinate.longitude;
                    NSMutableString *str = [NSMutableString new];
                    for(NSString *line in [placemark.addressDictionary objectForKey:@"FormattedAddressLines"])
                    {
                        [str appendString:line];
                        [str appendString:@","];
                    }
                    
                    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 280, [self getLabelSize:str fontSize:16])];
                    lblTitle.backgroundColor = [UIColor clearColor];
                    lblTitle.text = str;
                    lblTitle.textColor = [UIColor grayColor];
                    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                    lblTitle.numberOfLines = 0;
                    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
                    
                    [cell.contentView addSubview:lblTitle];
                    
                    
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, lblTitle.frame.size.height + 25, 300, 1)];
                    line.backgroundColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:line];
                }
                return cell;

                
            }
            if(indexPath.section == 1)
            {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
                
                for(UIView *inside in cell.contentView.subviews)
                {
                    [inside removeFromSuperview];
                }
                if(_searchResult.count > 0)
                {
                    

                        NWItem *item = [_searchResult objectAtIndex:indexPath.row];
                        
                        
                        UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 280, [self getLabelSize:item.itemName fontSize:16])];
                        lblTitle.backgroundColor = [UIColor clearColor];
                        lblTitle.text = item.itemName;
                        lblTitle.textColor = [UIColor grayColor];
                        lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                        lblTitle.numberOfLines = 0;
                        lblTitle.tag = 1010;
                        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
                        
                        [cell.contentView addSubview:lblTitle];
                    
                    
                    UIImage* image = [UIImage imageNamed:@"Placeholder.png"];
                    UIImageView * iv = [[UIImageView alloc] initWithImage:image];
                    [iv setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
                    iv.frame = (CGRect){{10,10},{20,20}};
                    iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
                    iv.contentMode = UIViewContentModeScaleAspectFit;
                    iv.tag = 101;
                    [cell.contentView addSubview:iv];
                    

                    }
                cell.tag = indexPath.row;
                return cell;

                
            }
            
        //}
        
    }
    else if(_currentPageType == SearchPagePastSearches)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceSearchCell"];
        
        for(UIView *inside in cell.contentView.subviews)
        {
            [inside removeFromSuperview];
        }
        NSArray *array = [Searches findAllSortedBy:@"dateSearhed" ascending:NO];
        if(array.count > 0)
        {
            Searches *search = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = search.searchStr;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            cell.textLabel.textColor = [UIColor grayColor];

        }
        return cell;

    }
    else if(_currentPageType == SearchNewType)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
        
        for(UIView *inside in cell.contentView.subviews)
        {
            [inside removeFromSuperview];
        }
        if(_searchResult.count > 0)
        {
            
            
            MKMapItem *item = [_searchResult objectAtIndex:indexPath.row];
           // NSLog(@"MKMapItem: %@", item.);
            
            UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 280, [self getLabelSize:item.name fontSize:16])];
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.text = item.name;
            lblTitle.textColor = [UIColor grayColor];
            lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            lblTitle.numberOfLines = 0;
            lblTitle.tag = 1010;
            lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
            
            [cell.contentView addSubview:lblTitle];
            
            
            
        }
        cell.tag = indexPath.row;
        return cell;
    }
    
    
    return nil;
    
    
}





-(CGFloat)getLabelSize:(NSString *)text fontSize:(NSInteger)fontSize
{
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
	CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
	CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    //[self performSegueWithIdentifier:@"LocView" sender:nil];
    
    
    if(_currentPageType == SearchPageBy4square)
    {
        if(indexPath.section == 0)
        {
            
        }
        else
        {
            //NWItem *item = [searchResult objectAtIndex:indexPath.row];
            
            //currentLocation = [NWHelper createDict:item.itemName lat:item.itemLat lng:item.itemLng];
            
            //[self performSegueWithIdentifier:@"MySegue" sender:[NWHelper createDict:item.itemName lat:item.itemLat lng:item.itemLng]];

            
            //[self performSegueWithIdentifier:@"ViewLocation" sender:nil];
        }
    }
    else
    {
        NSArray *array = [Searches findAllSortedBy:@"dateSearhed" ascending:NO];
        if(array.count > 0)
        {
            Searches *search = [array objectAtIndex:indexPath.row];
            _currentPageType = [search.searchType integerValue];
            _searchBar.text = search.searchStr;
            
            
            
            [self searchByString:search.searchStr];
            
            search.dateSearhed = [NSDate date];

            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            
        }
    }
    
    
    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}


@end
