//
//  CCApiManager.m
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCApiManager.h"
#import "CCHTTPManager.h"

@implementation CCApiManager

+ (instancetype)sharedApi {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestHeadLineDataWithURLString:(NSString *)URLString success:(void (^)(id))success error:(void (^)(NSError *))error {
    [[CCHTTPManager sharedManager] GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSAssert(success!=nil, @"success回调不能为空");
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull errorInfo) {
        NSAssert(error!=nil, @"error回调不能为空");
        error(errorInfo);
    }];
}
@end
