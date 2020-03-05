//
//  DRPraiseWinnerListViewController.m
//  dr
//
//  Created by 毛文豪 on 2018/12/19.
//  Copyright © 2018 JG. All rights reserved.
//

#import "DRPraiseWinnerListViewController.h"
#import "DRLoginViewController.h"
#import "DRUserShowViewController.h"
#import "DRPraiseListHeaderFooterView.h"
#import "DRPraiseListTableViewCell.h"
#import "UITableView+DRNoData.h"

@interface DRPraiseWinnerListViewController ()<UITableViewDataSource, UITableViewDelegate, PraiseListTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headerViews;

@end

@implementation DRPraiseWinnerListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"获奖名单";
    [self setupChilds];
}

#pragma mark - 请求数据
- (void)getData
{
    NSString *cmd = @"";
    if (self.currentIndex == 0) {
        cmd = @"G02";
    }else if (self.currentIndex == 1)
    {
        cmd = @"W06";
    }
    NSDictionary *bodyDic = @{
    };
    NSDictionary *headDic = @{
        @"digest":[DRTool getDigestByBodyDic:bodyDic],
        @"cmd":cmd,
        @"userId":UserId,
    };
    [[DRHttpTool shareInstance] postWithTarget:self headDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        MJRefreshGifHeader *headerView = self.headerViews[self.currentIndex];
        UITableView *tableView = self.views[self.currentIndex];
        if (SUCCESS) {
            NSArray *praiseSectionList = [DRPraiseSectionModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
            for (DRPraiseSectionModel * praiseSectionModel in praiseSectionList) {
                NSInteger index = [praiseSectionList indexOfObject:praiseSectionModel];
                NSArray *praiseList = [DRPraiseModel mj_objectArrayWithKeyValuesArray:json[@"list"][index][@"list"]];
                if (praiseList.count >= 3) {
                    praiseSectionModel.praiseList = [NSMutableArray arrayWithArray:praiseList];
                }
            }
            NSMutableArray *oldPraiseList = self.dataArray[self.currentIndex];
            if ([headerView isRefreshing]) {
                [oldPraiseList removeAllObjects];
            }
            [oldPraiseList addObjectsFromArray:praiseSectionList];
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
        tableView.tableFooterView = [UIView new];
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
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    [tableView showNoDataWithTitle:@"" description:@"暂无数据" rowCount:praiseSectionList.count];
    return praiseSectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    DRPraiseSectionModel * praiseSectionModel = praiseSectionList[section];
    if (praiseSectionModel.praiseList.count > 0) {
        return praiseSectionModel.praiseList.count;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    DRPraiseSectionModel * praiseSectionModel = praiseSectionList[indexPath.section];
    if (praiseSectionModel.praiseList.count > 0) {
        DRPraiseListTableViewCell *cell = [DRPraiseListTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.currentIndex = self.currentIndex;
        cell.index = indexPath.row;
        cell.praiseModel = praiseSectionModel.praiseList[indexPath.row];
        return cell;
    }else
    {
        static NSString *ID = @"PraiseWinnerNodataTableViewCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:DRGetFontSize(32)];
            cell.textLabel.textColor = DRGrayTextColor;
            cell.textLabel.text = @"未达到派奖条件";
            cell.imageView.image = [UIImage imageNamed:@"show_praise_avatar_placeholder"];
            CGSize itemSize = CGSizeMake(50, 50);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DRPraiseListHeaderFooterView *headerView = [DRPraiseListHeaderFooterView headerViewWithTableView:tableView];
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    DRPraiseSectionModel * praiseSectionModel = praiseSectionList[section];
    headerView.praiseSectionModel = praiseSectionModel;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50 + 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    DRPraiseSectionModel * praiseSectionModel = praiseSectionList[indexPath.section];
    if (praiseSectionModel.praiseList.count > 0) {
        DRUserShowViewController * showDetailVC = [[DRUserShowViewController alloc] init];
        DRPraiseModel *praiseModel = praiseSectionModel.praiseList[indexPath.row];
        showDetailVC.userId = praiseModel.userId;
        showDetailVC.nickName = praiseModel.userNickName;
        showDetailVC.userHeadImg = praiseModel.userHeadImg;
        [self.navigationController pushViewController:showDetailVC animated:YES];
    }
}

- (void)praiseListTableViewCellPraiseButtonDidClickWithCell:(DRPraiseListTableViewCell *)cell
{
    UITableView * tableView = self.views[self.currentIndex];
    NSIndexPath * indexPath = [tableView indexPathForCell:cell];
    
    if(!UserId || !Token)
    {
        DRLoginViewController * loginVC = [[DRLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    DRPraiseSectionModel * praiseSectionModel = praiseSectionList[indexPath.section];
    DRPraiseModel *praiseModel = praiseSectionModel.praiseList[indexPath.row];
    NSString * cmd;
    if ([praiseModel.focusCount boolValue]) {//取消关注
        cmd = @"U23";
    }else//添加关注
    {
        cmd = @"U22";
    }
    NSDictionary *bodyDic = @{
        @"id":praiseModel.userId,
        @"type":@(3)
    };
    
    NSDictionary *headDic = @{
        @"digest":[DRTool getDigestByBodyDic:bodyDic],
        @"cmd":cmd,
        @"userId":UserId,
    };
    waitingView
    [[DRHttpTool shareInstance] postWithHeadDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            praiseModel.focus = @(![praiseModel.focus boolValue]);
            UITableView *tableView = self.views[self.currentIndex];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        DRLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
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
    NSMutableArray *praiseSectionList = self.dataArray[self.currentIndex];
    return (int)praiseSectionList.count;
}

@end
