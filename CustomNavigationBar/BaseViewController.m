//
//  BaseViewController.m
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

// MARK:- 自定义导航条事件
/**
 自定义导航条信息字典
    key             value
 KHeaderViewH       导航条高度
 KStartPoint        弧线起始点
 KEndPoint          弧线结束点
 KControlPoint01    弧线控制点1
 KControlPoint02    弧线控制点2
 */
- (NSDictionary *)navHeaderViewInfoDic { return nil; };

/**
 自定义titleView
 */
- (UIView *)customNavHeaderView {
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.text = @"BaseViewController";
    return titleLB;
};

- (void)navHeaderViewDidClickBackBtn {};

- (void)navHeaderViewWillShow:(CNavHeaderView *)headerView {};

- (void)navHeaderView:(CNavHeaderView *)headerView didChangeWithProgress:(CGFloat)progress {};

- (void)navHeaderViewDidShow:(CNavHeaderView *)headerView {};

- (void)navHeaderViewWillDismiss:(CNavHeaderView *)headerView {};

- (void)navHeaderViewDidDismiss:(CNavHeaderView *)headerView {};

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
