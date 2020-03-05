//
//  DRPraiseMyAwardViewController.m
//  dr
//
//  Created by 毛文豪 on 2018/12/19.
//  Copyright © 2018 JG. All rights reserved.
//

#import "DRPraiseMyAwardViewController.h"
#import "DRPraiseAwardLogisticsViewController.h"
#import "DRPraiseGoodAwardViewController.h"
#import "DRRedPacketViewController.h"
#import "DRLoginViewController.h"
#import "DRPraiseMyAwardTableViewCell.h"
#import "DRPraiseListHeaderFooterView.h"
#import "UITableView+DRNoData.h"

@interface DRPraiseMyAwardViewController ()<UITableViewDataSource, UITableViewDelegate, PraiseMyAwardTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerViews;

@end

@implementation DRPraiseMyAwardViewController

- (instancetype)initWithCurrentIndex:(int)currentIndex
{
    self = [super init];
    if (self) {
        self.currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的奖励";
    [self setupChilds];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *bodyDic = @{
    };
    NSDictionary *headDic = @{
        @"digest":[DRTool getDigestByBodyDic:bodyDic],
        @"cmd":@"W03",
        @"userId":UserId,
    };
    [[DRHttpTool shareInstance] postWithTarget:self headDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        MJRefreshGifHeader *headerView = self.headerViews[self.currentIndex];
        UITableView *tableView = self.views[self.currentIndex];
        if (SUCCESS) {
            NSString * key;
            if (self.currentIndex == 0) {
                key = @"weekPrizeList";
            }else
            {
                key = @"monthPrizeList";
            }
            NSArray *awardSectionList = [DRAwardSectionModel mj_objectArrayWithKeyValuesArray:json[key]];
            for (DRAwardSectionModel * awardSectionModel in awardSectionList) {
                NSInteger index = [awardSectionList indexOfObject:awardSectionModel];
                NSArray *rewardList = [DRAwardModel mj_objectArrayWithKeyValuesArray:json[key][index][@"rewardList"]];
                awardSectionModel.rewardList = [NSMutableArray arrayWithArray:rewardList];
            }
            NSMutableArray *oldAwardList = self.dataArray[self.currentIndex];
            if ([headerView isRefreshing]) {
                [oldAwardList removeAllObjects];
            }
            [oldAwardList addObjectsFromArray:awardSectionList];
            [tableView reloadData];//刷新数据
        }else
        {
            ShowErrorView
        }
        //结束刷新
        [headerView endRefreshing];
    } failure:^(NSError *error) {
        DRLog(@"error:%@",error);
        MJRefreshGifHeader *headerView = self.headerViews[self.currentIndex];
        //结束刷新
        [headerView endRefreshing];
    }];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    self.btnTitles = @[@"周奖励", @"月奖励"];
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - topBtnH - 45 - [DRTool getSafeAreaBottom];
    for(int i = 0; i < self.btnTitles.count; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH)];
        tableView.tag = i;
        tableView.backgroundColor = DRBackgroundColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.views addObject:tableView];
        
        //初始化头部刷新控件
        MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        [DRTool setRefreshHeaderData:headerView];
        [self.headerViews addObject:headerView];
        tableView.mj_header = headerView;
    }
    
    //完成配置
    [super configurationComplete];
    [super topBtnClick:self.topBtns[self.currentIndex]];
}

- (void)changeCurrentIndex:(int)currentIndex
{
    //没有数据时加载数据
    if([self getDataCount] == 0)
    {
        [self getData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableArray *awardSectionList = self.dataArray[self.currentIndex];
    [tableView showNoDataWithTitle:@"" description:@"您还没有相关的记录" rowCount:awardSectionList.count];
    return awardSectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *awardSectionList = self.dataArray[self.currentIndex];
    DRAwardSectionModel * awardSectionModel = awardSectionList[section];
    if (awardSectionModel.rewardList.count > 0) {
        return awardSectionModel.rewardList.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *awardSectionList = self.dataArray[self.currentIndex];
    DRAwardSectionModel * awardSectionModel = awardSectionList[indexPath.section];
    if (awardSectionModel.rewardList.count > 0) {
        DRPraiseMyAwardTableViewCell *cell = [DRPraiseMyAwardTableViewCell cellWithTableView:tableView];
        cell.awardModel = awardSectionModel.rewardList[indexPath.row];
        cell.delegate = self;
        return cell;
    }else
    {
        static NSString *ID = @"PraiseMyAwardNodataTableViewCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:DRGetFontSize(32)];
            cell.textLabel.textColor = DRGrayTextColor;
            cell.textLabel.text = awardSectionModel.desc;
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DRPraiseListHeaderFooterView *headerView = [DRPraiseListHeaderFooterView headerViewWithTableView:tableView];
    NSMutableArray *awardSectionList = self.dataArray[self.currentIndex];
    DRAwardSectionModel * awardSectionModel = awardSectionList[section];
    headerView.awardSectionModel = awardSectionModel;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50 + 9;
}

- (void)praiseMyAwardTableViewCell:(DRPraiseMyAwardTableViewCell *)cell awardButtonDidClick:(UIButton *)button
{
    UITableView * tableView = self.views[self.currentIndex];
    NSIndexPath * indexPath = [tableView indexPathForCell:cell];
    NSMutableArray *awardSectionList = self.dataArray[self.currentIndex];
    DRAwardSectionModel * awardSectionModel = awardSectionList[indexPath.section];
    DRAwardModel *awardModel = awardSectionModel.rewardList[indexPath.row];
    
    if ([button.currentTitle isEqualToString:@"查看"]) {
        DRRedPacketViewController * redPacketVC = [[DRRedPacketViewController alloc] init];
        [self.navigationController pushViewController:redPacketVC animated:YES];
    }else
    {
        [self drawRedPacketWithAwardModel:awardModel indexPath:indexPath];
    }
}

- (void)drawRedPacketWithAwardModel:(DRAwardModel *)awardModel indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bodyDic = @{
        @"rewardId": awardModel.id
    };
    
    NSDictionary *headDic = @{
        @"digest":[DRTool getDigestByBodyDic:bodyDic],
        @"cmd":@"W04",
        @"userId":UserId,
    };
    waitingView
    [[DRHttpTool shareInstance] postWithHeadDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"领取成功"];
            awardModel.receiveable = NO;
            UITableView *tableView = self.views[self.currentIndex];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        DRLog(@"error:%@",error);
    }];
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_dataArray addObject:array];
        }
    }
    return _dataArray;
}

- (NSMutableArray *)headerViews
{
    if(_headerViews == nil)
    {
        _headerViews = [NSMutableArray array];
    }
    return _headerViews;
}

#pragma mark - 工具
//计算当前的数据数
- (int)getDataCount
{
    NSMutableArray *awardList = self.dataArray[self.currentIndex];
    return (int)awardList.count;
}

@end
