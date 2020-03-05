//
//  DRPraiseMyAwardTableViewCell.m
//  dr
//
//  Created by 毛文豪 on 2018/12/19.
//  Copyright © 2018 JG. All rights reserved.
//

#import "DRPraiseMyAwardTableViewCell.h"

@interface DRPraiseMyAwardTableViewCell ()

@property (nonatomic, weak) UILabel * awardLabel;
@property (nonatomic, weak) UIButton * awardButton;

@end

@implementation DRPraiseMyAwardTableViewCell

+ (DRPraiseMyAwardTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PraiseMyAwardTableViewCellId";
    DRPraiseMyAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[DRPraiseMyAwardTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    CGFloat awardBackImageViewW = 140;
    CGFloat awardBackImageViewH = 40;
    CGFloat awardButtonW = 60;
    CGFloat awardButtonH = 40;
    UIImageView * awardBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, awardBackImageViewW, awardBackImageViewH)];
    awardBackImageView.image = [UIImage imageNamed:@"praise_award_back"];
    [self.contentView addSubview:awardBackImageView];
    
    UILabel * awardLabel = [[UILabel alloc] initWithFrame:awardBackImageView.bounds];
    self.awardLabel = awardLabel;
    awardLabel.font = [UIFont boldSystemFontOfSize:DRGetFontSize(30)];
    awardLabel.textColor = [UIColor whiteColor];
    awardLabel.textAlignment = NSTextAlignmentCenter;
    [awardBackImageView addSubview:awardLabel];
    
    UIButton * awardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.awardButton = awardButton;
    awardButton.frame = CGRectMake(CGRectGetMaxX(awardBackImageView.frame) + 15, 10, awardButtonW, awardButtonH);
    [awardButton setTitle:@"领取" forState:UIControlStateNormal];
    [awardButton setTitleColor:DRPraiseRedTextColor forState:UIControlStateNormal];
    awardButton.titleLabel.font = [UIFont systemFontOfSize:DRGetFontSize(30)];
    awardButton.layer.masksToBounds = YES;
    awardButton.layer.cornerRadius = 2;
    awardButton.layer.borderColor = DRPraiseRedTextColor.CGColor;
    awardButton.layer.borderWidth = 1;
    [awardButton addTarget:self action:@selector(awardButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:awardButton];
}

- (void)awardButtonDidClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(praiseMyAwardTableViewCell:awardButtonDidClick:)]) {
        [_delegate praiseMyAwardTableViewCell:self awardButtonDidClick:button];
    }
}

- (void)setAwardModel:(DRAwardModel *)awardModel
{
    _awardModel = awardModel;
    
    self.awardLabel.text = _awardModel.title;
    if (_awardModel.receiveable) {
        [self.awardButton setTitle:@"领取" forState:UIControlStateNormal];
    }else
    {
        [self.awardButton setTitle:@"查看" forState:UIControlStateNormal];
    }
}

@end
