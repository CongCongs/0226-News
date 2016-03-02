//
//  CCNewsModel.h
//  News
//
//  Created by 陈锦聪 on 16/2/28.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCImagesModel.h"
@class CCImagesModel;

@interface CCNewsModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *digest;
@property (nonatomic,copy) NSString *replyCount;
@property (nonatomic,copy) NSString *imgsrc;
@property (nonatomic,strong) NSArray<CCImagesModel *> *imgextra;
@property (nonatomic,assign) NSInteger imgType;
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,copy) NSString *detailURL;

+ (void)newsModelWithURL:(NSString *)URLString finished:(void(^)(NSArray *data))finished;

@end
