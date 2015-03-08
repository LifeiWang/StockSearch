//
//  LWNewsWebViewController.h
//  HW9
//
//  Created by Lifei Wang on 4/13/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWNewsWebViewController : UIViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatior;
}

@property (strong, nonatomic) NSString *urlString;
@property (strong ,nonatomic) UIWebView *webView;

@end
