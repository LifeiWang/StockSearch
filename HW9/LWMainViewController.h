//
//  LWMainViewController.h
//  HW9
//
//  Created by Lifei Wang on 4/13/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsObj;
@class StockObj;

@interface LWMainViewController : UIViewController <UIAlertViewDelegate, NSURLConnectionDelegate,NSURLConnectionDataDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIButton *shareButton;
    UIButton *newsButton;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *changeLabel;
    UIImageView *arrowImage;
    UILabel *keyLabel;
    UILabel *valueLabel;
    UIImageView *stockImage;
    
    NSMutableData *receivedData;
    StockObj *stock;
    
}

@property (strong, nonatomic) UITextField *searchBox;
@property (strong, nonatomic) UITableView *hintTable;
@property (strong, nonatomic) NSMutableArray *hintArray;
@property (strong, nonatomic) StockObj *stock;

@end
