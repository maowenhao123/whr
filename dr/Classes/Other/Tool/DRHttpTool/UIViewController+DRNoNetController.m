//
//  UIViewController+DRNoNetController.m
//  dr
//
//  Created by 毛文豪 on 2017/5/27.
//  Copyright © 2017年 JG. All rights reserved.
//

#import "UIViewController+DRNoNetController.h"

@implementation UIViewController (DRNoNetController)

- (void)showNonetWork
{
    if (![self hasNonetWorkView]) {
        CGFloat viewH = screenHeight - statusBarH - navBarH;
        CGFloat viewY = 0;
        if (self.navigationController.navigationBarHidden) {
            viewH = screenHeight - statusBarH - navBarH;
            viewY = statusBarH + navBarH;
        }
        DRNoNetView* view = [[DRNoNetView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];//放在最顶部
    }
}
- (void)hiddenNonetWork
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[DRNoNetView class]]) {
            [view removeFromSuperview];
        }
    }
}
- (BOOL)hasNonetWorkView
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[DRNoNetView class]]) {
            return YES;
        }
    }
    return NO;
}
- (void)reloadNetworkDataSource:(id)sender
{
    if ([self respondsToSelector:@selector(getData)]) {
        [self performSelector:@selector(getData)];
    }
}
- (void)getData
{
    NSLog(@"必须由网络控制器(%@)重写这个方法(%@)，才可以使用再次刷新网络",NSStringFromClass([self class]),NSStringFromSelector(@selector(getData)));
}


@end
