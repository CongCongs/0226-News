//
//  CCNewsController.m
//  News
//
//  Created by 陈锦聪 on 16/2/28.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCNewsController.h"
#import "CCNewsModel.h"
#import "CCNewsCell.h"
#import "CCChannelModel.h"

@interface CCNewsController ()

@property (nonatomic,strong) NSArray *data;

@end

@implementation CCNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [CCNewsModel newsModelWithURL:[NSString stringWithFormat:@"article/headline/%@/0-20.html",self.channelID] finished:^(NSArray *data) {
        weakSelf.data = data;
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCNewsModel *model = self.data[indexPath.row];
    CCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:[CCNewsCell cellIdentifierWithModel:model] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCNewsModel *model = self.data[indexPath.row];
    return [CCNewsCell cellHeightWithModel:model];
}
@end
