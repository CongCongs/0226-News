//
//  CCApiManager.h
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCApiManager : NSObject

+ (instancetype)sharedApi;

- (void)requestHeadLineDataWithURLString:(NSString *)URLString success:(void(^)(id responseObject))success error:(void(^)(NSError *errorInfo))error;
@end
