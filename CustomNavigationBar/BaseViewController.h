//
//  BaseViewController.h
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNavHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, assign) CNavHeaderViewType viewType;

// MARK:- 自定义导航条事件
/**
 自定义导航条信息字典
 key             value
 KHeaderViewH       导航条高度
 KHeaderBgImgName   导航条背景图(可不传值)
 KStartPoint        弧线起始点(默认CGPointZero)
 KEndPoint          弧线结束点(默认CGPointZero)
 KControlPoint01    弧线控制点1(默认CGPointZero)
 KControlPoint02    弧线控制点2(默认CGPointZero)
 */
- (NSDictionary *)navHeaderViewInfoDic;

- (UIView *)customNavTitleView;

- (UIView *)customNavLeftView;

- (UIView *)customNavRightView;

- (void)navHeaderViewDidClickBackBtn;
 
- (void)navHeaderViewWillShow:(CNavHeaderView *)headerView;

- (void)navHeaderView:(CNavHeaderView *)headerView didChangeWithProgress:(CGFloat)progress;

- (void)navHeaderViewDidShow:(CNavHeaderView *)headerView;

- (void)navHeaderViewWillDismiss:(CNavHeaderView *)headerView;

- (void)navHeaderViewDidDismiss:(CNavHeaderView *)headerView;

@end

NS_ASSUME_NONNULL_END
