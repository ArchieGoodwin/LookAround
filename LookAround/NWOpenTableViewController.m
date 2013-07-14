//
//  NWOpenTableViewController.m
//  LookAround
//
//  Created by Sergey Dikarev on 4/2/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWOpenTableViewController.h"
#import "Defines.h"
@interface NWOpenTableViewController ()
{
    UIActivityIndicatorView *activityView;
    NSInteger page;
    
}
@end

@implementation NWOpenTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initMe:(CGRect)frame
{
    self = [super init];
    if(self)
    {
        self.view.frame = frame;
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return self;
    
}

-(void)realInit
{
    page = 1;
    
    
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Restaurants around the point";
}



-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _results.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    }
    NSLog(@"%i", indexPath.row);
    if(indexPath.row < _results.count)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        // Configure the cell...
        
        NSDictionary *result = [_results objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [result objectForKey:@"name"];
        
        cell.detailTextLabel.text = [result objectForKey:@"address"];
    }
    else
    {
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(145, 5, 30, 30);
        [activityView startAnimating];
        
        int total = [[_dict objectForKey:@"count"] integerValue];
        
        int totalpages = ceil((float)total / 25.0);
        
        if(totalpages > page)
        {
            page++;
            [NWHelper openTableReserveWithName:@"" zip:_zip page:page completionBlock:^(NSDictionary *result, NSError *error) {
                //NSLog(@"here open table: %@", result);
                
                
                if(result)
                {
                    NSMutableArray *array = [result objectForKey:@"restaurants"];
                    [_results addObjectsFromArray:array];
                    

                    
                    [self.tableView reloadData];
                }
                
                [activityView stopAnimating];
                
            }];
        }
        else
        {
            [activityView stopAnimating];
        }
        [cell.contentView addSubview:activityView];
    }
    

    
    return cell;
    
    
    
    
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *result = [_results objectAtIndex:indexPath.row];
    if([result objectForKey:@"mobile_reserve_url"])
    {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result objectForKey:@"mobile_reserve_url"]]];
        
        
        [[[UIActionSheet alloc] initWithTitle:[result objectForKey:@"mobile_reserve_url"] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:_parentView];
        
    }
}

@end
