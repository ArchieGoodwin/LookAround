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
#import "IconDownloader.h"
#import "Searches.h"
#import "NWViewLocationController.h"
@interface SearchViewController ()
{
    NSMutableArray *searchResult;
    CLPlacemark *placemark;
    double latitude;
    double longitude;
    NSDictionary *currentLocation;
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


- (void)viewDidLoad
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedLocation) name:chLocationMuchUpdated object:nil];

    _currentPageType = SearchPagePastSearches;
    searchResult = [NSMutableArray new];
    for (UIView * v in _searchBar.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            v.superview.alpha = 0;
            UIView *containerView = [[UIView alloc] initWithFrame:_searchBar.frame];
            [containerView addSubview:v];
            [self.tableView addSubview:containerView];

        }
    }
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
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
            searchResult = [NSMutableArray arrayWithArray:result];
            
            [self.tableView reloadData];
            
            [self loadImagesForOnscreenRows];
            
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if(!error)
                {
                    searchResult = [NSMutableArray arrayWithArray:response.mapItems];
                    NSLog(@"mapsearch results %i", searchResult.count);
                    [self.table reloadData];
                    
                }
                [appDelegate.mainViewController hideHUD];
            }];
        }
    }
    else
    {*/
        [NWHelper getLocationsForSearchString:str completionBlock:^(NSArray *result, NSError *error) {
            
            if(result.count > 0)
            {
                placemark = [result objectAtIndex:0];
                NSLog(@"Placemark: %@", placemark.addressDictionary);
                [NWHelper poisNearLocation:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) completionBlock:^(NSArray *result, NSError *error) {
                    if(!error)
                    {
                        searchResult = [NSMutableArray arrayWithArray:result];
                        
                        [self.tableView reloadData];
                        
                        [self loadImagesForOnscreenRows];
                    }
                    
                }];
                
                
            }
            else
            {
                
                
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
        [searchResult removeAllObjects];
        placemark = nil;
        _currentPageType = SearchPagePastSearches;
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
    }
    
    //}
}


#pragma mark - Seque

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ViewLocation"])
    {
        NWViewLocationController *controller = (NWViewLocationController *)segue.destinationViewController;
     
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NWItem *item = [searchResult objectAtIndex:cell.tag];
        NSDictionary *dict = [NWHelper createDict:item.itemName lat:item.itemLat lng:item.itemLng];
        
        controller.location = dict;
        [controller startAll];
    }
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
        return searchResult.count;

    }
    if(_currentPageType == SearchPagePastSearches)
    {
        return [[Searches numberOfEntities] integerValue];
    }
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if(_currentPageType == SearchPageByLocation || _currentPageType == SearchPageBy4square)
    {

            if(indexPath.section == 1)
            {
                if(searchResult.count > 0)
                {
                    NWItem *item = [searchResult objectAtIndex:indexPath.row];
                    
                    
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
    else
    {
        NSArray *array = [Searches findAllSortedBy:@"dateSearched" ascending:NO];
        if(array.count > 0)
        {
            Searches *search = [array objectAtIndex:indexPath.row];
            return [self getLabelSize:search.searchStr fontSize:16] + 20;

        }
        
    }*/
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
                if(searchResult.count > 0)
                {
                    

                        NWItem *item = [searchResult objectAtIndex:indexPath.row];
                        
                        
                        UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 280, [self getLabelSize:item.itemName fontSize:16])];
                        lblTitle.backgroundColor = [UIColor clearColor];
                        lblTitle.text = item.itemName;
                        lblTitle.textColor = [UIColor grayColor];
                        lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                        lblTitle.numberOfLines = 0;
                        lblTitle.tag = 1010;
                        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
                        
                        [cell.contentView addSubview:lblTitle];
                        
                        
                        if (!item.appIcon)
                        {
                            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                            {
                                [self startIconDownload:item forIndexPath:indexPath];
                            }
                            // if a download is deferred or in progress, return a placeholder image
                            UIImage* image = [UIImage imageNamed:@"Placeholder.png"];
                            UIImageView * iv = [[UIImageView alloc] initWithImage:image];
                            iv.frame = (CGRect){{10,10},{20,20}};
                            iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
                            iv.contentMode = UIViewContentModeScaleAspectFit;
                            iv.tag = 101;
                            [cell.contentView addSubview:iv];
                        }
                        else
                        {
                            UIView *old = [cell.contentView viewWithTag:101];
                            if(old)
                            {
                                [old removeFromSuperview];
                            }
                            UIImage* image = item.appIcon;
                            UIImageView * iv = [[UIImageView alloc] initWithImage:image];
                            iv.frame = (CGRect){{10,10},{20,20}};
                            iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
                            iv.contentMode = UIViewContentModeScaleAspectFit;
                            iv.tag = indexPath.row;
                            [cell.contentView addSubview:iv];
                        }
                    }
                cell.tag = indexPath.row;
                return cell;

                
            }
            
        //}
        
    }
    else
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
    
    
    return nil;
    
    
}


#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NWItem *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [_imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([searchResult count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if(indexPath.section == 1)
            {
                NWItem *appRecord = [searchResult objectAtIndex:indexPath.row];
                
                if (!appRecord.appIcon) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                }
            }
            
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [_imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        
        
        UIView *old = [cell.contentView viewWithTag:101];
        if(old)
        {
            [old removeFromSuperview];
        }
        UIImage* image = iconDownloader.appRecord.appIcon;;
        UIImageView * iv = [[UIImageView alloc] initWithImage:image];
        iv.frame = (CGRect){{10,10},{20,20}};
        iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.tag = 101;
        [cell.contentView addSubview:iv];
        
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [_imageDownloadsInProgress removeObjectForKey:indexPath];
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
            _currentPageType = SearchPageBy4square;
            _searchBar.text = search.searchStr;
            [self searchByString:search.searchStr];
            
        }
    }
    
    
    
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}




@end
