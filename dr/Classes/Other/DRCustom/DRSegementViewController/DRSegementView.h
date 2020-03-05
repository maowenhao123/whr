//
//  DRSegementView.h
//  dr
//
//  Created by 毛文豪 on 2019/1/10.
//  Copyright © 2019 JG. All rights reserved.
//

#import <UIKit/UIKit.h>
#define topBtnH 38

NS_ASSUME_NONNULL_BEGIN

@interface DRSegementView : UIView

@property (nonatomic, strong) NSArray *btnTitles;//顶部按钮标题数组
@property (nonatomic, strong) NSMutableArray *views;//要显示的view数组
@property (nonatomic,assign) NSInteger maxViewCount;//最多显示的按钮数
@property (nonatomic, assign) int currentIndex;//显示第几个view
@property (nonatomic, weak) UIScrollView *scrollView;//滑动的scrollview
@property (nonatomic, strong) NSMutableArray *topBtns;//顶部按钮数组

- (instancetype)initWithFrame:(CGRect)frame btnTitles:(NSArray *)btnTitles views:(NSMutableArray *)views;
- (void)topBtnClick:(UIButton *)btn;//第几个按钮点击
- (void)changeCurrentIndex:(int)currentIndex;//当前页面切换，子类实现

@end

NS_ASSUME_NONNULL_END
