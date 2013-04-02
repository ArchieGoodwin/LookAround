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


#define  manager ((NWManager *)[NWManager sharedInstance])
@interface SearchViewController ()
{
    CLPlacemark *placemark;
    double latitude;
    double longitude;
    NSDictionary *currentLocation;
    MBProgressHUD *HUD;
    UIBarButtonItem *btnMap;
    NSDictionary *geoResult;
    UIButton *btnTitle;
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

-(void)showAbout
{
    [self performSegueWithIdentifier:@"ShowAbout" sender:self];
}

- (void)setRightButton
{
    
    UIBarButtonItem *btnSearchType = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"05-shuffle.png"] style:UIBarButtonItemStylePlain target:self action:@selector(switchSearch)];
    self.navigationItem.rightBarButtonItem  = btnSearchType;
}

- (void)viewDidLoad
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedLocation) name:chLocationMuchUpdated object:nil];


    manager.foursquare.sessionDelegate = self;
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    UIBarButtonItem *btnLoc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"74-location.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchMyLocation:)];

    self.navigationItem.leftBarButtonItem = btnLoc;

    self.navigationItem.backBarButtonItem = nil;
    
    btnTitle =[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTitle setTitle:@"LookAround" forState:UIControlStateNormal];
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTitle.frame = CGRectMake(0, 0, 200, 44);
    [btnTitle addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = btnTitle;
    
    
    [self setRightButton];
    
    self.navigationItem.leftBarButtonItem = btnLoc;
    
    
    _currentSearchType = SearchBy4square;
    
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
    _searchBar.placeholder = @"City and/or address";;
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    //self.navigationItem.title = @"LookAround";
    [super viewDidLoad];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
        
    
    
    if (![manager.foursquare isSessionValid]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager.foursquare startAuthorization];
    } else {
        [manager.foursquare invalidateSession];
    }
}

#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
    [NWHelper saveToUserDefaults:foursquare.accessToken key:@"4square"];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelFont = [UIFont boldSystemFontOfSize:12];
    HUD.labelText = @"Login Successfully!";
    
    [self performSelector:@selector(loginFoursquareSuccess) withObject:nil afterDelay:0];
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    [HUD hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login failed with Foursquare" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    [self hideHUD];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] objectForKey:@"errorDetail"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)loginFoursquareSuccess
{
    [HUD hide:YES];
    
    _currentSearchType = SearchBy4squareFull;
    _searchBar.placeholder = @"City and/or address, any keywords";
}


-(void)searchVenueByString:(NSString *)str
{
    NSArray *query = [str componentsSeparatedByString:@","];

    if(query.count >= 2)
    {
        [self showHUD];

        NSString *address = query[0];
        NSString *keywords = query[1];
        if(query.count > 2)
        {
            NSArray *arr = [query objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, query.count - 1)]];
            keywords = [arr componentsJoinedByString:@" "];
        }
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:address, @"near", keywords, @"query", nil];
        manager.foursquare.accessToken = [NWHelper getSettingsValue:@"4square"];
        self.request = [manager.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
        [_request start];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please use correct format for search string: \n City and/or address, keywords." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
}


#pragma mark -
#pragma mark BZFoursquareRequestDelegate



- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    NSLog(@"BZFoursquareRequest %@", request.response);
    
    _currentPageType = SearchPageBy4square;
    NSMutableArray *pois = [[NSMutableArray alloc] init];
    
    geoResult = [[request.response objectForKey:@"geocode"] objectForKey:@"feature"];
    
    //if([[json objectForKey:@"numResults"] integerValue] > 0)
    //{
    NSMutableArray *items = [request.response objectForKey:@"venues"];
    for (NSMutableDictionary *dict in items) {
        NWItem *item = [[NWItem alloc] initWithDictionary:dict];
        [pois addObject:item];
    }
    
    if(pois.count > 0)
    {
        
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemDistance" ascending:YES];
        
        [_searchResult removeAllObjects];
        
        _searchResult = [NSMutableArray arrayWithArray:[pois sortedArrayUsingDescriptors:[NSMutableArray arrayWithObjects:sortDescriptor, nil]]];
    }
    

    [self.tableView reloadData];
        
    [self showOrHideBtnMap:YES];

    [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}




-(void)switchSearch
{
    if(_currentSearchType == SearchBy4square)
    {

        if([NWHelper getSettingsValue:@"4square"] == nil)
        {
            
            [[[UIActionSheet alloc] initWithTitle:@"To use this feature please sign To Foursquare" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Go on", nil] showInView:self.view];
        }
        else
        {

            //[manager.foursquare invalidateSession];

            
            _currentSearchType = SearchBy4squareFull;
            _searchBar.placeholder = @"City and/or address, any keywords";
            [btnTitle setTitle:@"LookAround: keywords" forState:UIControlStateNormal];
        }
    }
    else
    {
        [btnTitle setTitle:@"LookAround: address" forState:UIControlStateNormal];

        _currentSearchType = SearchBy4square;
        _searchBar.placeholder = @"City and/or address";
    }
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
        
        NSMutableString *str = [NSMutableString new];
        for(NSString *line in [placemark.addressDictionary objectForKey:@"FormattedAddressLines"])
        {
            [str appendString:line];
            [str appendString:@","];
        }
        _searchBar.text = str;
        
        
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
    placemark = nil;
    if(_currentSearchType == SearchBy4square)
    {
        _currentPageType = SearchPageBy4square;
        [NWHelper createSearchRequest:searchBar.text searchType:SearchPageBy4square];
        [self searchByString:searchBar.text];
    }
    else
    {
        _currentPageType = SearchPageBy4square;
        [NWHelper createSearchRequest:searchBar.text searchType:SearchNewType];
        [self searchVenueByString:searchBar.text];
    }
    


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
        
        [self setRightButton];
    }
    
    //}
}




#pragma mark - Seque

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue.identifier);
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
        if(placemark)
        {
            NSDictionary *dict = [NWHelper createDict:_searchBar.text lat:placemark.location.coordinate.latitude lng:placemark.location.coordinate.longitude];
            
            controller.nwItem = nil;
            controller.location = dict;

        }
        else
        {
            double lat = [[[[geoResult objectForKey:@"geometry"] objectForKey:@"center"] objectForKey:@"lat"] doubleValue];
            double lng = [[[[geoResult objectForKey:@"geometry"] objectForKey:@"center"] objectForKey:@"lng"] doubleValue];
            
            
            NSDictionary *dict = [NWHelper createDict:_searchBar.text lat:lat lng:lng];
            
            controller.nwItem = nil;
            controller.location = dict;
        }
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
        if(_currentSearchType == SearchBy4square || _currentSearchType == SearchBy4squareFull)
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
                else
                {
                    latitude = [[[[geoResult objectForKey:@"geometry"] objectForKey:@"center"] objectForKey:@"lat"] doubleValue];
                    longitude = [[[[geoResult objectForKey:@"geometry"] objectForKey:@"center"] objectForKey:@"lng"] doubleValue];
                    NSMutableString *str = [NSMutableString new];
                    
                    str = [geoResult objectForKey:@"displayName"];
                    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, 280, [self getLabelSize:str fontSize:16])];
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
            
            if([search.searchType integerValue] == SearchPageBy4square)
            {
                _currentSearchType = SearchBy4square;

                [self searchByString:search.searchStr];
                
                search.dateSearhed = [NSDate date];
                [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            }
            else
            {
                _currentSearchType = SearchBy4squareFull;

                [self searchVenueByString:search.searchStr];
                search.dateSearhed = [NSDate date];
                
                [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
            }
            
           
            
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
