//
//  CCHeadLineController.m
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCHeadLineController.h"
#import "CCHeadLineCell.h"
#import "CCApiManager.h"

@interface CCHeadLineController ()

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation CCHeadLineController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    
//    [self setupView];
}
- (void)test {
    [[CCApiManager sharedApi] requestHeadLineDataWithURLString:@"ad/headline/0-4.html" success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } error:^(NSError *errorInfo) {
        NSLog(@"%@",errorInfo);
    }];
}
- (void)setupView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置cell大小
    self.layout.itemSize = self.collectionView.bounds.size;
    // 设置滚动方向
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 隐藏滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 设置分页
    self.collectionView.pagingEnabled = YES;
    // 取消间距
    self.layout.minimumLineSpacing = 0;
    // 弹簧效果(不显示空白)
    self.collectionView.bounces = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCHeadLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:[self random] green:[self random] blue:[self random] alpha:1];
    return cell;
}

- (CGFloat)random {
    return arc4random_uniform(256)/255.0;
}
@end
