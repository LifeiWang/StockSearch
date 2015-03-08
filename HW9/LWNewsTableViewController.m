//
//  LWNewsTableViewController.m
//  HW9
//
//  Created by Lifei Wang on 4/13/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import "LWNewsTableViewController.h"
#import "NewsObj.h"
#import "LWNewsWebViewController.h"
#import "GTMNSString+HTML.h"

@interface LWNewsTableViewController ()

@end

@implementation LWNewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"News";
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
    return [self.newsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];

    }
    
    NewsObj *item = [self.newsArray objectAtIndex:indexPath.row];
    NSString *str = [item.title gtm_stringByUnescapingFromHTML];
    cell.textLabel.text= str;
    
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    
    
    NewsObj *item = [self.newsArray objectAtIndex: indexPath.row];
    selectedLink = item.link;
//    NSLog(@"%@",item.link);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"View News"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"View", nil];
    [alert show];
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        // Create the next view controller.
        LWNewsWebViewController *detailViewController = [[LWNewsWebViewController alloc] initWithNibName:@"LWNewsWebViewController" bundle:nil];
        detailViewController.urlString = selectedLink;
        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
