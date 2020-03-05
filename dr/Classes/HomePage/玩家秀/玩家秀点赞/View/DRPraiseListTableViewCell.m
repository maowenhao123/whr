//
//  DRPraiseListTableViewCell.m
//  dr
//
//  Created by 毛文豪 on 2018/12/17.
//  Copyright © 2018 JG. All rights reserved.
//

#import "DRPraiseListTableViewCell.h"

@interface DRPraiseListTableViewCell ()

@property (nonatomic, weak) UIImageView * avatarImageView;
@property (nonatomic, weak) UILabel *rankLabel;
@property (nonatomic, weak) UILabel * nickNameLabel;
@property (nonatomic, weak) UILabel *praiseNumberLabel;
@property (nonatomic, weak) UIImageView *rankImageView;
@property (nonatomic,weak) UIButton * attentionButton;

@end

@implementation DRPraiseListTableViewCell

+ (DRPraiseListTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"PraiseListTableViewCellId";
    DRPraiseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[DRPraiseListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    CGFloat cellH = 80;
    
    //头像
    CGFloat avatarImageViewWH = 50;
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (cellH - avatarImageViewWH) / 2, avatarImageViewWH, avatarImageViewWH)];
    self.avatarImageView = avatarImageView;
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    avatarImageView.userInteractionEnabled = YES;
    [self addSubview:avatarImageView];
    
    //排名
    CGFloat rankLabelW = 50;
    CGFloat rankLabelH = 20;
    UILabel * rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImageView.x + (avatarImageViewWH - rankLabelW) / 2, CGRectGetMaxY(avatarImageView.frame) - rankLabelH / 2, rankLabelW, rankLabelH)];
    self.rankLabel = rankLabel;
    rankLabel.font = [UIFont systemFontOfSize:DRGetFontSize(22)];
    rankLabel.textColor = DRDefaultColor;
    rankLabel.textAlignment = NSTextAlignmentCenter;
    rankLabel.layer.masksToBounds = YES;
    rankLabel.layer.cornerRadius = rankLabelH / 2;
    rankLabel.layer.borderColor = DRDefaultColor.CGColor;
    rankLabel.layer.borderWidth = 1;
    [self addSubview:rankLabel];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = DRBlackTextColor;
    nickNameLabel.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
    [self addSubview:nickNameLabel];
    
    //点赞数
    UILabel * praiseNumberLabel = [[UILabel alloc] init];
    self.praiseNumberLabel = praiseNumberLabel;
    praiseNumberLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    praiseNumberLabel.textColor = DRPraiseRedTextColor;
    [self addSubview:praiseNumberLabel];
    
    //关注
    CGFloat attentionButtonW = 70;
    CGFloat attentionButtonH = 27;
    UIButton * attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButton = attentionButton;
    attentionButton.titleLabel.font = [UIFont systemFontOfSize:DRGetFontSize(26)];
    [attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
    [attentionButton setTitleColor:DRPraiseRedTextColor forState:UIControlStateNormal];
    attentionButton.frame = CGRectMake(screenWidth - (attentionButtonW + 15), (80 - attentionButtonH) / 2, attentionButtonW, attentionButtonH);
    [attentionButton addTarget:self action:@selector(attentionButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    attentionButton.layer.masksToBounds = YES;
    attentionButton.layer.cornerRadius = attentionButton.height / 2;
    attentionButton.layer.borderWidth = 1;
    attentionButton.layer.borderColor = DRPraiseRedTextColor.CGColor;
    [self addSubview:attentionButton];
    
    nickNameLabel.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + DRMargin, 15, attentionButton.x - CGRectGetMaxX(avatarImageView.frame) - 2 * DRMargin, 25);
    praiseNumberLabel.frame = CGRectMake(CGRectGetMaxX(avatarImageView.frame) + DRMargin, 40, attentionButton.x - CGRectGetMaxX(avatarImageView.frame) - 2 * DRMargin, 25);
    
    //排名
    CGFloat rankImageViewWH = 45;
    UIImageView * rankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(attentionButton.x - rankImageViewWH - 10, (cellH - rankImageViewWH) / 2, rankImageViewWH, rankImageViewWH)];
    self.rankImageView = rankImageView;
    [self addSubview:rankImageView];
    
}

- (void)attentionButtonDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(praiseListTableViewCellPraiseButtonDidClickWithCell:)]) {
        [_delegate praiseListTableViewCellPraiseButtonDidClickWithCell:self];
    }
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    self.rankImageView.hidden = YES;
    self.rankImageView.image = nil;
    self.rankLabel.hidden = YES;
    self.rankLabel.text = @"";
    if (_isRealTime) {
        self.rankLabel.hidden = NO;
        if (_index == 0) {
            self.rankLabel.text = @"排名1";
            self.rankLabel.textColor = [UIColor whiteColor];
            self.rankLabel.backgroundColor = DRColor(255, 38, 0, 1);
            self.rankLabel.layer.borderWidth = 0;
        }else if (_index == 1) {
            self.rankLabel.text = @"排名2";
            self.rankLabel.textColor = [UIColor whiteColor];
            self.rankLabel.backgroundColor = DRColor(237, 125, 49, 1);
            self.rankLabel.layer.borderWidth = 0;
        }else if (_index == 2) {
            self.rankLabel.text = @"排名3";
            self.rankLabel.textColor = [UIColor whiteColor];
            self.rankLabel.backgroundColor = DRColor(255, 192, 0, 1);
            self.rankLabel.layer.borderWidth = 0;
        }else
        {
            self.rankLabel.text = [NSString stringWithFormat:@"排名%ld", _index + 1];
            self.rankLabel.textColor = DRDefaultColor;
            self.rankLabel.backgroundColor = [UIColor whiteColor];
            self.rankLabel.layer.borderWidth = 1;
        }
    }else
    {
        if (self.currentIndex == 0) {
            if (_index == 0) {
                self.rankImageView.hidden = NO;
                self.rankImageView.image = [UIImage imageNamed:@"show_praise_rank_week_1"];
            }else if (_index == 1) {
                self.rankImageView.hidden = NO;
                self.rankImageView.image = [UIImage imageNamed:@"show_praise_rank_week_2"];
            }else if (_index == 2) {
                self.rankImageView.hidden = NO;
                self.rankImageView.image = [UIImage imageNamed:@"show_praise_rank_week_3"];
            }
        }else
        {
            if (_index == 0) {
                self.rankImageView.hidden = NO;
                self.rankImageView.image = [UIImage imageNamed:@"show_praise_rank_month_1"];
            }else if (_index == 1) {
                self.rankImageView.hidden = NO;
                self.rankImageView.image = [UIImage imageNamed:@"show_praise_rank_month_2"];
            }else if (_index == 2) {
                self.rankImageView.hidden = NO;
                self.rankImageView.image = [UIImage imageNamed:@"show_praise_rank_month_3"];
            }
        }
    }
}

- (void)setPraiseModel:(DRPraiseModel *)praiseModel
{
    _praiseModel = praiseModel;
    
    NSString * imageUrlStr = _praiseModel.userHeadImg;
    if (![imageUrlStr containsString:@"http"]) {
        imageUrlStr = [NSString stringWithFormat:@"%@%@", baseUrl, _praiseModel.userHeadImg];
    }
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    self.nickNameLabel.text = praiseModel.userNickName;
    
    self.praiseNumberLabel.text = [NSString stringWithFormat:@"点赞数：%@", _praiseModel.praiseCount];
    
    if ([_praiseModel.focus boolValue]) {
        self.attentionButton.userInteractionEnabled = NO;
        [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:DRGrayTextColor forState:UIControlStateNormal];
        self.attentionButton.layer.borderColor = DRGrayLineColor.CGColor;
    }else
    {
        self.attentionButton.userInteractionEnabled = YES;
        [self.attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:DRPraiseRedTextColor forState:UIControlStateNormal];
        self.attentionButton.layer.borderColor = DRPraiseRedTextColor.CGColor;
    }
}

@end
