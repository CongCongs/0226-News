//
//  CCHeadLineController.m
//  News
//
//  Created by 陈锦聪 on 16/2/26.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCHeadLineController.h"
#import "CCHeadLineCell.h"
#import "CCHeadLineModel.h"

@interface CCHeadLineController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *data;

@end

@implementation CCHeadLineController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
}

- (void)viewWillLayoutSubviews {
    // 布局子控件要在主界面加载完成后,否则不能获取View的真实大小
    [self setupView];
  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 加载初始图片
    CGFloat width = self.collectionView.bounds.size.width;
    self.collectionView.contentOffset = CGPointMake(width, 0);
}

- (void)loadData {
    [CCHeadLineModel headLineModelWithURL:@"ad/headline/0-4.html" finished:^(NSArray *data) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:data];
        [temp insertObject:[data lastObject] atIndex:0];
        [temp addObject:[data firstObject]];
        self.data = temp.copy;
        self.pageControl.numberOfPages = self.data.count-2;
        [self.collectionView reloadData];
        // 加载初始Label
        [self scrollViewDidEndDecelerating:self.collectionView];
        // 异步加载数据 网络延迟
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
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
  
    // 初始显示 拿不到width!
//    self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width, 0);
    
}

#pragma mark - collectionView代理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/self.collectionView.bounds.size.width;
    if (index == 0) {
        index = self.data.count-1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.data.count-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }else if (index == self.data.count-1) {
        index = 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    self.pageControl.currentPage = index-1;
    if (index == self.data.count-1) {
        index -=1;
    }
    CCHeadLineModel *model = self.data[index];
    self.titleLabel.text = model.title;        
}

#pragma mark - collectionView数据源 

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 10000;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCHeadLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 以下两行代码不能交换位置!必须先给tag赋值再传值
//    cell.tag = indexPath.item-1;
    cell.model = self.data[indexPath.item];
    return cell;
}

@end
