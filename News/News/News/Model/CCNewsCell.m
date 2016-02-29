
//
//  CCNewsCell.m
//  News
//
//  Created by 陈锦聪 on 16/2/28.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCNewsCell.h"
#import "CCNewsModel.h"
#import <UIImageView+WebCache.h>

@interface CCNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgextra;



@end

@implementation CCNewsCell

- (void)setModel:(CCNewsModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.digest;
    self.replyLabel.text = [NSString stringWithFormat:@"%@跟帖",model.replyCount];
    if (model.imgextra) {
        [self.imgextra enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCImagesModel *temp = model.imgextra[idx];
            [obj sd_setImageWithURL:[NSURL URLWithString:temp.imgsrc]];
        }];
    }
}

+ (NSString *)cellIdentifierWithModel:(CCNewsModel *)model {
    if (model.imgextra) {
        return @"CCImagesCell";
    }else if (model.imgType) {
        return @"CCFunCell";
    }else {
        return @"CCNewsCell";
    }
}
+ (CGFloat)cellHeightWithModel:(CCNewsModel *)model {
    if (model.imgextra) {
        return 130;
    }else if (model.imgType) {
        return 150;
    }else {
        return 80;
    }
}

@end
