//
//  CCHeadLineCell.m
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCHeadLineCell.h"
#import "CCHeadLineModel.h"
#import <UIImageView+WebCache.h>

@interface CCHeadLineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation CCHeadLineCell

- (void)setModel:(CCHeadLineModel *)model {
    
    _model = model;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
}

@end
