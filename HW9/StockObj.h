//
//  StockObj.h
//  HW9
//
//  Created by Lifei Wang on 4/15/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsObj;

@interface StockObj : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *symbol;

@property (strong, nonatomic) NSString *change;
@property (strong, nonatomic) NSString *changeType;
@property (strong, nonatomic) NSString *changeInPercent;
@property (strong, nonatomic) NSString *lastTradePriceOnly;
@property (strong, nonatomic) NSString *previousClose;
@property (strong, nonatomic) NSString *daysLow;
@property (strong, nonatomic) NSString *daysHigh;
@property (strong, nonatomic) NSString *yearLow;
@property (strong, nonatomic) NSString *yearHigh;
@property (strong, nonatomic) NSString *open;
@property (strong, nonatomic) NSString *bid;
@property (strong, nonatomic) NSString *volume;
@property (strong, nonatomic) NSString *ask;
@property (strong, nonatomic) NSString *averageDailyVolume;
@property (strong, nonatomic) NSString *oneYearTargetPrice;
@property (strong, nonatomic) NSString *marketCapitalization;

@property (strong, nonatomic) NSString *stockChartImageURL;

@property (strong, nonatomic) NSMutableArray *newsArray;


@end
