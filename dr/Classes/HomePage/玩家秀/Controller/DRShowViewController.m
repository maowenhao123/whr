//
//  DRShowViewController.m
//  dr
//
//  Created by apple on 2017/3/15.
//  Copyright © 2017年 JG. All rights reserved.
//

#import "DRShowViewController.h"
#import "DRRedPacketViewController.h"
#import "DRPraiseListViewController.h"
#import "DRAddShowViewController.h"
#import "DRShowTableView.h"
#import "DRShowHeaderView.h"
#import "IQKeyboardManager.h"

@interface DRShowViewController ()

@property (nonatomic, strong) DRShowHeaderView * headerView;
@property (nonatomic, weak) DRShowTableView * showTableView;

@end

@implementation DRShowViewController

#pragma mark - 控制器的生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.enable = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"玩家秀";
    [self setupChilds];
    [self judgePraiseActivity];
    [self judgePraiseAward];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPraiseActivityEnd) name:@"ShowPraiseActivityEnd1" object:nil];
}

- (void)showPraiseActivityEnd
{
    self.showTableView.tableHeaderView = self.headerView;
}

#pragma mark - 请求数据
- (void)judgePraiseActivity
{
    NSDictionary *bodyDic = @{
    };
    
    NSDictionary *headDic = @{
        @"digest":[DRTool getDigestByBodyDic:bodyDic],
        @"cmd":@"G12",
        @"userId":UserId,
    };
    [[DRHttpTool shareInstance] postWithHeadDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        if (SUCCESS) {
            self.headerView.openActivity = [json[@"status"] boolValue];
            self.showTableView.tableHeaderView = self.headerView;
        }
    } failure:^(NSError *error) {
        DRLog(@"error:%@",error);
    }];
}

- (void)judgePraiseAward
{
    NSDictionary *bodyDic = @{
    };
    
    NSDictionary *headDic = @{
        @"digest":[DRTool getDigestByBodyDic:bodyDic],
        @"cmd":@"W07",
        @"userId":UserId,
    };
    [[DRHttpTool shareInstance] postWithHeadDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        if (SUCCESS) {
            NSArray * dataArray = json[@"list"];
            if (dataArray.count > 0) {
                NSDictionary * dataDic = dataArray.firstObject;
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:dataDic[@"desc"] message:@""  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"领红包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    DRPraiseListViewController * praiseListVC = [[DRPraiseListViewController alloc] init];
                    praiseListVC.index = 2;
                    if ([dataDic[@"type"] isEqualToString:@"MONTH"]) {
                        praiseListVC.awardIndex = 1;
                    }else
                    {
                        praiseListVC.awardIndex = 0;
                    }
                    [self.navigationController pushViewController:praiseListVC animated:YES];
                }];
                UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"晚会再领" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [MBProgressHUD show:@"查看榜单，在【我的奖励】中也可领奖哦！" icon:nil view:self.view];
                }];
                [alertController addAction:alertAction1];
                [alertController addAction:alertAction2];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        DRLog(@"error:%@",error);
    }];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    UIBarButtonItem * addShowBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_show_bar"] style:UIBarButtonItemStylePlain target:self action:@selector(addShowBarDidClick)];
    self.navigationItem.rightBarButtonItem = addShowBar;
    
    //tableView
    CGFloat headerViewH = 275 + screenWidth * 150 / 375;
    CGFloat viewH = screenHeight - statusBarH - navBarH;
    DRShowTableView* showTableView = [[DRShowTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, viewH) style:UITableViewStyleGrouped userId:@"" type:@(1) topY:statusBarH + navBarH];
    self.showTableView = showTableView;
    [self.view addSubview:showTableView];
    [showTableView setupChilds];
    
    //headerView
    self.headerView = [[DRShowHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, headerViewH)];
    self.headerView.openActivity = NO;
    self.showTableView.tableHeaderView = self.headerView;
}

- (void)addShowBarDidClick
{
    DRAddShowViewController * addShowVC = [[DRAddShowViewController alloc] init];
    [self.navigationController pushViewController:addShowVC animated:YES];
}

@end
