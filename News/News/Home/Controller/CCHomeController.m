//
//  CCHomeController.m
//  News
//
//  Created by 陈锦聪 on 16/2/29.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCHomeController.h"
#import "CCChannelModel.h"
#import "CCChannelLabel.h"
#import "CCChannelNewsCell.h"

@interface CCHomeController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSArray *channels;
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation CCHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // NavigationController默认向下偏移64(导航栏高度)
    self.automaticallyAdjustsScrollViewInsets = NO;

}
// 设置子控件必须在主界面加载后,否则拿不到准确的界面数据
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupView];
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

- (void)loadData {
    
    NSArray *data = [CCChannelModel channels];
    // 排序
    data = [data sortedArrayUsingComparator:^NSComparisonResult(CCChannelModel * _Nonnull obj1, CCChannelModel * _Nonnull obj2) {
        return [obj1.tid compare:obj2.tid];
    }];
    self.channels = data;
    
    __weak typeof(self) weakSelf = self;
    __block CGFloat x = 0;
    [data enumerateObjectsUsingBlock:^(CCChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCChannelLabel *label = [CCChannelLabel channelLabelWithTitle:obj.tname];
        CGFloat y = 0;
        CGFloat w = label.bounds.size.width;
        CGFloat h = weakSelf.scrollView.bounds.size.height;
        label.frame = CGRectMake(x, y, w, h);
        x += w;
        
        [label setClicked:^{
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }];
        if (idx == 0) {
            label.scale = 1;
        }
        [weakSelf.scrollView addSubview:label];
    }];
    // 设置滚动范围
    self.scrollView.contentSize = CGSizeMake(x, 0);
    // 刷新界面
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCChannelNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCChannelNewsCell" forIndexPath:indexPath];
    CCChannelModel *channel = self.channels[indexPath.item];
    cell.channel = channel;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得可视范围cell的indexPath
    NSArray *indexPaths = self.collectionView.indexPathsForVisibleItems;
    // 当前label
    CCChannelLabel *currentLabel = self.scrollView.subviews[_currentPage];
    // 下一个label
    __block CCChannelLabel *nextLabel;
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.item!=_currentPage) {
            nextLabel = self.scrollView.subviews[obj.item];
        }
    }];
    if (!nextLabel) {
        return;
    }
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat offSet = self.collectionView.contentOffset.x;
    CGFloat scale = ABS(offSet / width - self.currentPage);
    currentLabel.scale = 1 - scale;
    nextLabel.scale = scale;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat offSet = self.collectionView.contentOffset.x;
    self.currentPage = (NSInteger)offSet / width;
}
@end
