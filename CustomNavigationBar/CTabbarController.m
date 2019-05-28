//
//  CTabbarController.m
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import "CTabbarController.h"
#import "CNavigationController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
@interface CTabbarController ()

@end

@implementation CTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //计划大厅
    OneViewController *planHallVC = [[OneViewController alloc] init];
    planHallVC.hidesBottomBarWhenPushed = NO;
    CNavigationController *naviPH = [[CNavigationController alloc] initWithRootViewController:planHallVC];
    naviPH.tabBarItem = [self tabBarItemWithTitle:@"One" image:[UIImage imageNamed:@"tab_plan_nor"] selectedImage:[UIImage imageNamed:@"tab_plan_pre"] tag:1];
    naviPH.tabBarItem.accessibilityHint = @"One";
    
    //开奖历史
    TwoViewController *lotteryHistoryVC = [[TwoViewController alloc] init];
    lotteryHistoryVC.hidesBottomBarWhenPushed = NO;
    lotteryHistoryVC.title = @"Two";
    CNavigationController *naviLH = [[CNavigationController alloc] initWithRootViewController:lotteryHistoryVC];
    naviLH.tabBarItem = [self tabBarItemWithTitle:@"Two" image:[UIImage imageNamed:@"tab_lottery_nor"] selectedImage:[UIImage imageNamed:@"tab_lottery_pre"] tag:2];
    naviLH.tabBarItem.accessibilityHint = @"Two";
    
    self.viewControllers = @[naviLH,naviPH];
}

- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:tag];
    tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return tabBarItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
