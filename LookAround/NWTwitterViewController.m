//
//  NWTwitterViewController.m
//  LookAround
//
//  Created by Sergey Dikarev on 2/12/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import "NWTwitterViewController.h"
#import "Defines.h"
#import "NWtwitter.h"
#import "NWTwitterCell.h"
#import "AFNetworking.h"
#import "NWLabel.h"
@interface NWTwitterViewController ()
{
    UIView *viewForLabel;
}
@end

@implementation NWTwitterViewController


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

        [self.view addSubview:_tableView];
    }
    return self;

}

- (void)showMessageView {
    viewForLabel = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    viewForLabel.backgroundColor = [UIColor whiteColor];
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)] ;
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    lblMessage.text = @"There are no tweets around there";
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

- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_tweets.count == 0)
    {
        [self showMessageView];
        //[self hideMessageView];
    }
}

-(void)realInit
{
    [self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _tweets.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NWTwitterCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"TweetMessage"];
    
    
    if(cell == nil)
    {
        NSArray *toplevel = [[NSBundle mainBundle ] loadNibNamed:@"TwitterCell" owner:nil options:nil];
        for(id cObject in toplevel)
        {
            if([cObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (NWTwitterCell *)cObject;
                break;
            }
        }
    }
    
    
    NWtwitter *tweet = _tweets[indexPath.row];
    
    cell.lblText.text = tweet.message;
    
    cell.lblDate.text =  [NSDateFormatter localizedStringFromDate:tweet.dateCreated dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    cell.lblAuthor.text = tweet.author;

    UIImage* image = [UIImage imageNamed:@"Placeholder.png"];
    [cell.imgProfile setImageWithURL:[NSURL URLWithString:tweet.iconUrl] placeholderImage:image];
    
    return cell;
    
    
    
    
    
    
    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NWtwitter *tweet = _tweets[indexPath.row];

    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 1, 250, 25)];
    lblTitle.numberOfLines = 0;
    lblTitle.lineBreakMode = UILineBreakModeWordWrap;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = tweet.author;
    lblTitle.font = [UIFont systemFontOfSize:15];
    lblTitle.textColor = [UIColor darkTextColor];
    
    
    UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 250, 25)];
    lblSubTitle.backgroundColor = [UIColor clearColor];
    lblSubTitle.text = tweet.message;
    lblSubTitle.font = [UIFont systemFontOfSize:15];
    lblSubTitle.textColor = [UIColor lightGrayColor];
    
    [cell.contentView addSubview:lblTitle];
    [cell.contentView addSubview:lblSubTitle];
    
    return cell;*/
    
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NWtwitter *tweet = _tweets[indexPath.row];
    
    if(tweet.author)
    {
        [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"https://twitter.com/%@", tweet.author] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
        
    }
    

}

@end
