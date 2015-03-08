//
//  LWMainViewController.m
//  HW9
//
//  Created by Lifei Wang on 4/13/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import "LWMainViewController.h"
#import "LWNewsTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NewsObj.h"
#import "StockObj.h"
#import  <QuartzCore/QuartzCore.h>

@interface LWMainViewController ()

@end

@implementation LWMainViewController
@synthesize stock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Stock Search";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hintArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 548)];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 800)];
    [self.view addSubview:scrollView];
    
    self.searchBox = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 210, 50)];
    [self.searchBox setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    [self.searchBox setBorderStyle:UITextBorderStyleRoundedRect];
    [self.searchBox setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.searchBox setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBox setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.searchBox.delegate = self;
    [scrollView addSubview:self.searchBox];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [searchButton setFrame:CGRectMake(250, 10, 50, 50)];
    [searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:searchButton];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 70, 220, 40)];
//    [nameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:17]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    nameLabel.hidden = YES;
    [scrollView addSubview:nameLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 110, 220, 50)];
//    [priceLabel setBackgroundColor:[UIColor lightGrayColor]];
    [priceLabel setFont:[UIFont systemFontOfSize:20]];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    priceLabel.hidden = YES;
    [scrollView addSubview:priceLabel];
    
    arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 160, 20, 30)];
    arrowImage.hidden = YES;
    [scrollView addSubview:arrowImage];
    
    changeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 160, 150, 30)];
    [changeLabel setTextAlignment:NSTextAlignmentLeft];
//    [changeLabel setBackgroundColor:[UIColor lightGrayColor]];
    changeLabel.hidden = YES;
    [scrollView addSubview:changeLabel];
    
    keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 190, 110, 240)];
    keyLabel.numberOfLines = 10;
    [keyLabel setFont:[UIFont systemFontOfSize:16]];
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.adjustsFontSizeToFitWidth = NO;
    keyLabel.text = @" Prev Close\n Open\n Bid\n Ask\n 1st Yr Target\n Day Range\n 52wk Range\n Volume\n Avg Vol(3m)\n Market Cap";
    keyLabel.hidden = YES;
    [scrollView addSubview:keyLabel];
    
    valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 190, 170, 240)];
    valueLabel.numberOfLines = 10;
    [valueLabel setFont:[UIFont systemFontOfSize:16]];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.adjustsFontSizeToFitWidth = NO;
    valueLabel.hidden = YES;
    [scrollView addSubview:valueLabel];
    
    stockImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 450, 300, 200)];
    stockImage.hidden = YES;
    [scrollView addSubview:stockImage];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton setBackgroundColor:[UIColor lightGrayColor]];
    [shareButton setTintColor:[UIColor blackColor]];
    [shareButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake(180, 700, 120, 50)];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.hidden = YES;
    [scrollView addSubview:shareButton];
    
    newsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newsButton setTitle:@"News Headlines" forState:UIControlStateNormal];
    [newsButton setTintColor:[UIColor blackColor]];
    [newsButton setBackgroundColor:[UIColor lightGrayColor]];
    [newsButton setFrame:CGRectMake(20, 700, 120, 50)];
    [newsButton addTarget:self action:@selector(newsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    newsButton.hidden = YES;
    [scrollView addSubview:newsButton];
    
    self.hintTable = [[UITableView alloc]initWithFrame:CGRectMake(20, 60, 210, 200) style:UITableViewStylePlain];
    self.hintTable.delegate = self;
    self.hintTable.dataSource = self;
    self.hintTable.scrollEnabled = YES;
    self.hintTable.hidden = YES;
    self.hintTable.layer.borderWidth = 0.5;
    [scrollView addSubview:self.hintTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSURL *)getYahooAutoCompleteURL:(NSString *)str
{
    NSString *urlString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback",str ];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(void)reloadStockInfo
{
    if (self.stock == nil || self.stock.change == nil){
        nameLabel.hidden = YES;
        priceLabel.hidden = NO;
        priceLabel.text = @"Stock Not Available";
        arrowImage.hidden = YES;
        changeLabel.hidden = YES;
        keyLabel.hidden = YES;
        valueLabel.hidden = YES;
        newsButton.hidden = YES;
        shareButton.hidden = YES;
        stockImage.hidden = YES;
        return;
    }
    nameLabel.hidden = NO;
    priceLabel.hidden = NO;
    arrowImage.hidden = NO;
    changeLabel.hidden = NO;
    keyLabel.hidden = NO;
    valueLabel.hidden = NO;
    stockImage.hidden = NO;
    if ([self.stock.newsArray count]==0){
        newsButton.hidden = YES;
        shareButton.frame = CGRectMake(60, 700, 200, 50);
    }
    else{
        newsButton.hidden = NO;
        shareButton.frame = CGRectMake(180, 700, 120, 50);
    }
    shareButton.hidden = NO;
    
    nameLabel.text = [NSString stringWithFormat:@"%@(%@)", self.stock.name, self.stock.symbol];
    priceLabel.text = [NSString stringWithFormat:@"%@",self.stock.lastTradePriceOnly ];
    changeLabel.text = [NSString stringWithFormat:@"%@(%@)", self.stock.change, self.stock.changeInPercent];
    if ([self.stock.changeType isEqual:@"-"]){
        changeLabel.textColor = [UIColor redColor];
        arrowImage.image = [UIImage imageNamed:@"down.gif"];
    }
    else{
        if ([self.stock.changeType isEqual:@"+"]){
            arrowImage.image = [UIImage imageNamed:@"up.gif"];
        }
        else{
            arrowImage.image = nil;
        }
        changeLabel.textColor = [UIColor greenColor];
    }
    NSString *dayRange = [NSString stringWithFormat:@"%@-%@", self.stock.daysLow, self.stock.daysHigh];
    NSString *yearRange = [NSString stringWithFormat:@"%@-%@", self.stock.yearLow, self.stock.yearHigh];
    
    valueLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",
                       self.stock.previousClose,
                       self.stock.open,
                       self.stock.bid,
                       self.stock.ask,
                       self.stock.oneYearTargetPrice,
                       dayRange,
                       yearRange,
                       self.stock.volume,
                       self.stock.averageDailyVolume,
                       self.stock.marketCapitalization];
    
    NSURL *imageUrl = [NSURL URLWithString:self.stock.stockChartImageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *newImage = [UIImage imageWithData:imageData];
    stockImage.image = newImage;

}

-(void)searchAutoCompleteHintsWithSubstring:(NSString *)substring
{
    [self.hintArray removeAllObjects];
    //YAHOO SEARCH
    NSURL *url = [self getYahooAutoCompleteURL:substring];
    NSError *err=nil;
    NSString *jsonpStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    NSString *jsonStr = [jsonpStr substringFromIndex:39];
    jsonStr = [jsonStr substringToIndex:(jsonStr.length-1)];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error=nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSDictionary *resultDic = [jsonResult objectForKey:@"ResultSet"];
    NSArray *resultArray = [resultDic objectForKey:@"Result"];
    for (int i=0; i<resultArray.count; i++){
        NSDictionary *dic = [resultArray objectAtIndex:i];
        NSString *sym = [dic objectForKey:@"symbol"];
        NSString *name = [dic objectForKey:@"name"];
        NSString *exch = [dic objectForKey:@"exch"];
        NSString *line = [NSString stringWithFormat:@"%@,%@(%@)",sym,name,exch ];
        [self.hintArray addObject:line];
    }
    
//    NSLog(@"hintArray\n%@",self.hintArray);
    
}

#pragma mark - UITableView delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([self.hintArray count]>4) {
//        return 5;
//    }
//    else{
//        return [self.hintArray count];
//    }
    return [self.hintArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HintCell"];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HintCell"];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    cell.textLabel.text = [self.hintArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.hintArray objectAtIndex:indexPath.row];
    self.searchBox.text = str;
    self.hintTable.hidden = YES;
    [self.hintArray removeAllObjects];
    [self.hintTable reloadData];
    [self.searchBox resignFirstResponder];
    [self doSearch];
}

#pragma mark - UIAlertView delegate and methods
-(void)alertViewCancel:(UIAlertView *)alertView
{

}

-(void)showAlertMessage:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self doSearch];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.hintTable.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    substring = [[substring componentsSeparatedByString:@","]objectAtIndex:0];
    [self searchAutoCompleteHintsWithSubstring:substring];
    [self.hintTable reloadData];
    return YES;
}



#pragma mark - 
-(void)newsButtonClicked:(id)sender
{
    if (self.stock.newsArray != nil){
        LWNewsTableViewController *nextViewController = [[LWNewsTableViewController alloc]initWithStyle:UITableViewStylePlain];
        nextViewController.newsArray = self.stock.newsArray;
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

-(void)searchButtonClicked:(id)sender
{
    [self.searchBox resignFirstResponder];
    [self.hintArray removeAllObjects];
    self.hintTable.hidden = true;
    [self.hintTable reloadData];
    [self doSearch];
}

-(void)doSearch
{
    NSString *symbol = [[self.searchBox.text componentsSeparatedByString:@","]objectAtIndex:0];
    if ([symbol length]==0){
        self.stock = nil;
        nameLabel.hidden = YES;
        priceLabel.hidden = YES;
        arrowImage.hidden = YES;
        changeLabel.hidden = YES;
        keyLabel.hidden = YES;
        valueLabel.hidden = YES;
        newsButton.hidden = YES;
        shareButton.hidden = YES;
        stockImage.hidden = YES;
        [self showAlertMessage:@"Please enter company symbol"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"http://cs-server.usc.edu:20590/examples/servlet/StockSearch?symbol=%@",symbol ];
    //    NSString *urlString = [NSString stringWithFormat:@"http://cs-server.usc.edu:20590/examples/servlet/StockSearch?symbol=goog" ];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    receivedData = [NSMutableData dataWithCapacity: 0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        receivedData = nil;
        
        [self showAlertMessage:@"Connection Failed"];
    }
}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
//    NSLog(@"%@",receivedData);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlertMessage:[error description]];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[receivedData length]);
    [self parseJSONdata:receivedData];
    [self reloadStockInfo];
    receivedData = nil;
}

#pragma mark - parser

-(void)parseJSONdata:(NSData *)data
{
    if (stock!=nil){
        stock=nil;
    }
    stock = [[StockObj alloc]init];
    NSError *err=nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if ([[result objectForKey:@"result"] isEqual:@""]){
        return;
    }
    NSDictionary *dic = [result objectForKey:@"result"];
    stock.name = [dic objectForKey:@"Name"];
    stock.symbol = [dic objectForKey:@"Symbol"];
    stock.stockChartImageURL = [dic objectForKey:@"StockChartImageURL"];
    
    NSDictionary *quoteDic = [dic objectForKey:@"Quote"];
    if ([[quoteDic objectForKey:@"Ask"] isKindOfClass:[NSString class]]){
        stock.ask = [quoteDic objectForKey:@"Ask"];
    }
    else{
        double askValue = [[quoteDic objectForKey:@"Ask"]doubleValue];
        stock.ask = [NSString stringWithFormat:@"%.2f",askValue];
    }
    stock.averageDailyVolume = [quoteDic objectForKey:@"AverageDailyVolume"];
    
    if ([[quoteDic objectForKey:@"Bid"] isKindOfClass:[NSString class]]){
        stock.bid = [quoteDic objectForKey:@"Bid"];
    }
    else{
        double bidValue = [[quoteDic objectForKey:@"Bid"]doubleValue];
        stock.bid = [NSString stringWithFormat:@"%.2f",bidValue];
    }
    
    if ([[quoteDic objectForKey:@"Change"] isKindOfClass:[NSString class]]){
        stock.change = [quoteDic objectForKey:@"Change"];
    }
    else{
        double changeValue = [[quoteDic objectForKey:@"Change"]doubleValue];
        stock.change = [NSString stringWithFormat:@"%.2f",changeValue];
    }
    
    stock.changeType = [quoteDic objectForKey:@"ChangeType"];
    stock.changeInPercent = [quoteDic objectForKey:@"ChangeinPercent"];
    
    if ([[quoteDic objectForKey:@"DaysLow"] isKindOfClass:[NSString class]]){
        stock.daysLow = [quoteDic objectForKey:@"DaysLow"];
    }
    else{
        double dayLowVaule = [[quoteDic objectForKey:@"DaysLow"]doubleValue];
        stock.daysLow = [NSString stringWithFormat:@"%.2f",dayLowVaule ];
    }
    
    if ([[quoteDic objectForKey:@"DaysHigh"] isKindOfClass:[NSString class]]){
        stock.daysHigh = [quoteDic objectForKey:@"DaysHigh"];
    }
    else{
        double dayHighValue = [[quoteDic objectForKey:@"DaysHigh"]doubleValue];
        stock.daysHigh = [NSString stringWithFormat:@"%.2f",dayHighValue ];
    }
    
    if ([[quoteDic objectForKey:@"LastTradePriceOnly"] isKindOfClass:[NSString class]]){
        stock.lastTradePriceOnly = [quoteDic objectForKey:@"LastTradePriceOnly"];
    }
    else{
        double lastTradeValue = [[quoteDic objectForKey:@"LastTradePriceOnly"]doubleValue];
        stock.lastTradePriceOnly = [NSString stringWithFormat:@"%.2f",lastTradeValue];
    }
    
    stock.marketCapitalization = [quoteDic objectForKey:@"MarketCapitalization"];
    
    if ([[quoteDic objectForKey:@"OneyrTargetPrice"] isKindOfClass:[NSString class]]){
        stock.oneYearTargetPrice = [quoteDic objectForKey:@"OneyrTargetPrice"];
    }
    else{
        double oneYrValue = [[quoteDic objectForKey:@"OneyrTargetPrice"]doubleValue];
        stock.oneYearTargetPrice = [NSString stringWithFormat:@"%.2f",oneYrValue];
    }
    
    if ([[quoteDic objectForKey:@"Open"] isKindOfClass:[NSString class]]){
        stock.open = [quoteDic objectForKey:@"Open"];
    }
    else{
        double openValue = [[quoteDic objectForKey:@"Open"]doubleValue];
        stock.open = [NSString stringWithFormat:@"%.2f",openValue ];
    }
    
    if ([[quoteDic objectForKey:@"PreviousClose"] isKindOfClass:[NSString class]]){
        stock.previousClose = [quoteDic objectForKey:@"PreviousClose"];
    }
    else{
        double preClose =[[quoteDic objectForKey:@"PreviousClose"]doubleValue];
        stock.previousClose = [NSString stringWithFormat:@"%.2f",preClose ];
    }
    
    stock.volume = [quoteDic objectForKey:@"Volume"];
    
    if ([[quoteDic objectForKey:@"YearLow"] isKindOfClass:[NSString class]]){
        stock.yearLow = [quoteDic objectForKey:@"YearLow"];
    }
    else{
        double yearLowValue = [[quoteDic objectForKey:@"YearLow"]doubleValue];
        stock.yearLow = [NSString stringWithFormat:@"%.2f",yearLowValue ];
    }
    
    if ([[quoteDic objectForKey:@"YearHigh"] isKindOfClass:[NSString class]]){
        stock.yearHigh = [quoteDic objectForKey:@"YearHigh"];
    }
    else{
        double yearHighValue = [[quoteDic objectForKey:@"YearHigh"]doubleValue];
        stock.yearHigh = [NSString stringWithFormat:@"%.2f",yearHighValue ];
    }
    id news = [dic objectForKey:@"News"];
    if ([news isKindOfClass:[NSDictionary class]]){
    
        NSDictionary *newsdic = [dic objectForKey:@"News"];
        NSArray *array = [newsdic objectForKey:@"Item"];
        
        for (NSInteger i=0; i<[array count]; i++){
            NSDictionary *temp = [array objectAtIndex:i];
            NewsObj *item = [[NewsObj alloc]init];
            item.title = [temp objectForKey:@"Title"];
            item.link = [temp objectForKey:@"Link"];
            [stock.newsArray addObject:item];
        }
    }
    
//    NSLog(@"%@",stock.previousClose);
}

#pragma mark - facebook events

-(void)shareButtonClicked:(id)sender
{
    NSString *linkString = [NSString stringWithFormat:@"http://finance.yahoo.com/q?s=%@",self.stock.symbol ];
    NSString *desString = [NSString stringWithFormat:@"Last Trade Price: %@, Change:%@%@(%@)", self.stock.lastTradePriceOnly, self.stock.changeType, self.stock.change, self.stock.changeInPercent];
    NSString *capString = [NSString stringWithFormat:@"Stock Information of %@(%@)",self.stock.name, self.stock.symbol];
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:linkString];
    params.name = self.stock.name;
    params.caption = capString;
    params.picture = [NSURL URLWithString:self.stock.stockChartImageURL];
    params.description = desString;
    
    // If the Facebook app is installed and we can present the share dialog
    if (0) {//[FBDialogs canPresentShareDialogWithParams:params]
        // Present the share dialog
        
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        if(error) {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            [self showAlertMessage:@"Error publishing story"];
        } else {
            // Success
            NSLog(@"result %@", results);
            [self showAlertMessage:@"Post is published"];
        }
    }];
    } else {
        // Present the feed dialog
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.stock.name, @"name",
                                       capString, @"caption",
                                       desString, @"description",
                                       linkString, @"link",
                                       self.stock.stockChartImageURL, @"picture",
                                       nil];
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story:");
                                                          [self showAlertMessage:@"Error publishing story"];
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                                  [self showAlertMessage:@"Post is published"];
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
