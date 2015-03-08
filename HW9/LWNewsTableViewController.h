//
//  LWNewsTableViewController.h
//  HW9
//
//  Created by Lifei Wang on 4/13/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWNewsTableViewController : UITableViewController <UIAlertViewDelegate>
{
    NSString *selectedLink;
}

@property (strong, nonatomic) NSArray *newsArray;

@end
