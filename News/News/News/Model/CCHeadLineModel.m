//
//  CCHeadLineModel.m
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCHeadLineModel.h"
#import "CCApiManager.h"

@implementation CCHeadLineModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 没有找到属性的时候调用该方法崩溃
    // 调用该方法不做处理,避免崩溃
}

+ (void)headLineModelWithURL:(NSString *)URLString finished:(void(^)(NSArray *))finished {
    NSAssert(finished!=nil, @"完成回调不能为空");
    [[CCApiManager sharedApi] requestDataWithURLString:URLString success:^(NSDictionary *responseObject) {
        NSString *key = responseObject.keyEnumerator.nextObject;
        NSArray *temp = responseObject[key];
        NSMutableArray *data = [NSMutableArray array];
        [temp enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [data addObject:[self modelWithDict:obj]];
        }];
        finished(data.copy);
    } error:^(NSError *errorInfo) {
        finished(nil);
    }];
}

@end
