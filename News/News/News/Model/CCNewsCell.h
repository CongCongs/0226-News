//
//  CCNewsCell.h
//  News
//
//  Created by 陈锦聪 on 16/2/28.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCNewsModel;

@interface CCNewsCell : UITableViewCell

@property (nonatomic,strong) CCNewsModel *model;

+ (NSString *)cellIdentifierWithModel:(CCNewsModel *)model;
+ (CGFloat)cellHeightWithModel:(CCNewsModel *)model;
@end
