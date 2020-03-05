//
//  DRPraiseListHeaderFooterView.m
//  dr
//
//  Created by 毛文豪 on 2019/1/7.
//  Copyright © 2019 JG. All rights reserved.
//

#import "DRPraiseListHeaderFooterView.h"

@interface DRPraiseListHeaderFooterView ()

@property (nonatomic, weak) UILabel * weekLabel;

@end

@implementation DRPraiseListHeaderFooterView

+ (DRPraiseListHeaderFooterView *)headerViewWithTableView:(UITableView *)talbeView
{
    static NSString *ID = @"PraiseListHeaderFooterViewId";
    DRPraiseListHeaderFooterView *headerView = [talbeView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if(headerView == nil)
    {
        headerView = [[DRPraiseListHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}

//初始化子控件
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    //分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    lineView1.backgroundColor = DRBackgroundColor;
    [self.contentView addSubview:lineView1];
    
    //点
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame) + 10 + (40 - 24) / 2, 6, 24)];
    lineView2.backgroundColor = DRViceColor;
    [self.contentView addSubview:lineView2];
    
    //第几周
    UILabel * weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame) + 7, CGRectGetMaxY(lineView1.frame) + 10, screenWidth - DRMargin - CGRectGetMaxX(lineView2.frame) - 7, 40)];
    self.weekLabel = weekLabel;
    weekLabel.font = [UIFont boldSystemFontOfSize:DRGetFontSize(35)];
    weekLabel.textColor = DRBlackTextColor;
    [self.contentView addSubview:weekLabel];
}

- (void)setPraiseSectionModel:(DRPraiseSectionModel *)praiseSectionModel
{
    _praiseSectionModel = praiseSectionModel;
    
    self.weekLabel.text = _praiseSectionModel.cycle;
}

- (void)setAwardSectionModel:(DRAwardSectionModel *)awardSectionModel
{
    _awardSectionModel = awardSectionModel;
    
    self.weekLabel.text = _awardSectionModel.title;
}

@end
