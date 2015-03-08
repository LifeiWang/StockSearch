//
//  StockObj.m
//  HW9
//
//  Created by Lifei Wang on 4/15/14.
//  Copyright (c) 2014 Lifei Wang. All rights reserved.
//

#import "StockObj.h"
#import "NewsObj.h"

@implementation StockObj

-(id)init{
    self = [super init];
    if (self){
        self.newsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
