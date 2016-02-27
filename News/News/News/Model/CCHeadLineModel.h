//
//  CCHeadLineModel.h
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHeadLineModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgsrc;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (void)headLineModelWithURL:(NSString *)URLString finished:(void(^)(NSArray *data))finished;
@end
