//
//  CCChannelNewsCell.m
//  News
//
//  Created by 陈锦聪 on 16/2/29.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCChannelNewsCell.h"
#import "CCChannelModel.h"
#import "CCNewsController.h"

@interface CCChannelNewsCell ()

@property (nonatomic,strong) CCNewsController *news;

@end
@implementation CCChannelNewsCell

- (void)setChannel:(CCChannelModel *)channel {
    _channel = channel;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    CCNewsController *news = sb.instantiateInitialViewController;
    news.channelID = channel.tid;
    // 把控制器的View添加到cell
    [self.contentView addSubview:news.view];
    news.view.frame = self.contentView.bounds;
    // 控制器强引用(否则控制器会立即销毁)
    self.news = news;
}
@end
