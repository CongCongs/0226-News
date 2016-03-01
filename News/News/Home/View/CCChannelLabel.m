//
//  CCChannelLabel.m
//  News
//
//  Created by 陈锦聪 on 16/2/29.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCChannelLabel.h"
#define CCNormalFont 14.0
#define CCSelectedFont 18.0

@implementation CCChannelLabel

+ (instancetype)channelLabelWithTitle:(NSString *)title {
    CCChannelLabel *label = [[self alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:CCSelectedFont];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:CCNormalFont];
    // 用户交互开启
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.clicked) {
        self.clicked();
    }
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    CGFloat percen = (CCSelectedFont-CCNormalFont)/CCNormalFont*scale+1;
    if (percen < 1) percen = 1;
    self.transform = CGAffineTransformMakeScale(percen, percen);
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:YES];

}
@end
