//
//  CCHTTPManager.h
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CCHTTPManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
