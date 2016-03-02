//
//  CCNewsModel.m
//  News
//
//  Created by 陈锦聪 on 16/2/28.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCNewsModel.h"
#import "CCApiManager.h"
#import <YYModel.h>

@implementation CCNewsModel

+ (void)newsModelWithURL:(NSString *)URLString finished:(void (^)(NSArray *))finished {
    NSAssert(finished!=nil, @"完成回调不能为空");
    [[CCApiManager sharedApi] requestDataWithURLString:URLString success:^(NSDictionary * responseObject) {
        NSString *key = responseObject.keyEnumerator.nextObject;

        NSArray *temp = responseObject[key];
        // 读不到html数据,需要在HTTPManager中添加text/html
        NSArray *data = [NSArray yy_modelArrayWithClass:self json:temp];
//        NSLog(@"%@",data);
        finished(data);
        
    } error:^(NSError *errorInfo) {
        
        finished(nil);
    }];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"imgextra":[CCImagesModel class]
             };
}

- (void)setDocid:(NSString *)docid {
    // NSString的set方法完整写法
    _docid = docid.copy;
    _detailURL = [NSString stringWithFormat:@"article/%@/full.html",docid];
}
@end
