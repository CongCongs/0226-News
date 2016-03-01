//
//  CCChannelModel.m
//  News
//
//  Created by 陈锦聪 on 16/2/29.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCChannelModel.h"
#import <YYModel.h>

@implementation CCChannelModel

+ (NSArray *)channels {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *key = dict.keyEnumerator.nextObject;
    NSArray *array = dict[key];
    return [NSArray yy_modelArrayWithClass:self json:array];
}

@end
