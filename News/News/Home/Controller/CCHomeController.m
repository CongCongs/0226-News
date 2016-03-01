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
#import "CCNewsController.h"

@interface CCHomeController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSArray *channels;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableDictionary *controllerCache;

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
// 加载控制器
- (CCNewsController *)newsControllerWithChannel:(CCChannelModel *)model {
    // 从缓存池加载
    CCNewsController *news = [self.controllerCache objectForKey:model.tid];
    if (news == nil) {
        // 从sb加载
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"News" bundle:nil];
        news = sb.instantiateInitialViewController;
        news.channelID = model.tid;
        // 添加到缓存池
        [self.controllerCache setObject:news forKey:model.tid];
    }
    return news;
}

- (void)adjustLabelContentOffset {
    CCChannelLabel *currentLabel = self.scrollView.subviews[self.currentPage];
    CGFloat offSet = currentLabel.center.x - self.scrollView.bounds.size.width / 2;
    NSLog(@"%f--%f",currentLabel.center.x,offSet);
    if (offSet < 0) {
        offSet = 0;
    }
    CGFloat maxOffSet = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    if (offSet > maxOffSet) {
        offSet = maxOffSet;
    }
    [self.scrollView setContentOffset:CGPointMake(offSet, 0) animated:YES];
}

#pragma mark - 界面设置

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

#pragma mark - 加载界面数据

- (void)loadData {
    
    NSArray *data = [CCChannelModel channels];
    // 排序
    data = [data sortedArrayUsingComparator:^NSComparisonResult(CCChannelModel * _Nonnull obj1, CCChannelModel * _Nonnull obj2) {
        return [obj1.tid compare:obj2.tid];
    }];
    self.channels = data;
    self.currentPage = 0;
    
    __weak typeof(self) weakSelf = self;
    __block CGFloat x = 0;
    [data enumerateObjectsUsingBlock:^(CCChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCChannelLabel *label = [CCChannelLabel channelLabelWithTitle:obj.tname];
        CGFloat y = 0;
        CGFloat w = label.bounds.size.width;
        CGFloat h = weakSelf.scrollView.bounds.size.height;
        label.frame = CGRectMake(x, y, w, h);
        x += w;
        
        __weak typeof(label) weakLabel = label;
        [label setClicked:^{
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            weakLabel.scale = 1;
            CCChannelLabel *currentLabel = weakSelf.scrollView.subviews[weakSelf.currentPage];
            currentLabel.scale = 0;
            weakSelf.currentPage = idx;
            [weakSelf adjustLabelContentOffset];
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

#pragma mark - collectionView数据源

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCChannelNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCChannelNewsCell" forIndexPath:indexPath];
    // 添加新View之前移除旧View
    [cell.news.view removeFromSuperview];
    
    CCChannelModel *channel = self.channels[indexPath.item];
    CCNewsController *news = [self newsControllerWithChannel:channel];
    // 把子控制器添加到父控制器(响应者链条)
    if (![self.childViewControllers containsObject:news]) {
        [self addChildViewController:news];
    }
    news.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:news.view];
    // 记录当前cell的View
    cell.news = news;
//    cell.channel = channel;
    return cell;
}

#pragma mark - scrollView代理

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
    [self adjustLabelContentOffset];
}

#pragma mark - 懒加载

- (NSMutableDictionary *)controllerCache {
    if (_controllerCache == nil) {
        _controllerCache = [NSMutableDictionary dictionary];
    }
    return _controllerCache;
}
@end
