//
//  CCHTTPManager.m
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCHTTPManager.h"
#define CCBaseURL [NSURL URLWithString:@"http://c.m.163.com/nc/"]

@implementation CCHTTPManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static CCHTTPManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:CCBaseURL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return instance;
}

@end
