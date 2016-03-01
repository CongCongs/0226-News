//
//  CCChannelModel.h
//  News
//
//  Created by 陈锦聪 on 16/2/29.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCChannelModel : NSObject

@property (nonatomic,copy) NSString *tname;
@property (nonatomic,copy) NSString *tid;

+ (NSArray *)channels;
@end
