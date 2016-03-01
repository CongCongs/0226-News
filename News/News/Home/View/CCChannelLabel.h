//
//  CCChannelLabel.h
//  News
//
//  Created by 陈锦聪 on 16/2/29.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCChannelLabel : UILabel

@property (nonatomic,copy) void(^clicked)();
@property (nonatomic,assign) CGFloat scale;

+ (instancetype)channelLabelWithTitle:(NSString *)title;

@end
