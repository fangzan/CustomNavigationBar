//
//  CNavHeaderView.h
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KNavBarHeight               44
#define KArcHeight                  20
#define KNHSCREEN_W                 [[UIScreen mainScreen] bounds].size.width
#define KStatuBarHeight             [UIApplication sharedApplication].statusBarFrame.size.height
#define KNavHeight                  (KStatuBarHeight + KNavBarHeight + KArcHeight)

NS_ASSUME_NONNULL_BEGIN
@protocol CNavHeaderViewDelegate <NSObject>

- (void)didClickClosedBtn;

@end

typedef NS_ENUM(NSInteger,CNavHeaderViewType)
{
    CNavHeaderViewTypeNone,// 无导航栏
    CNavHeaderViewTypeDefault,// 默认导航栏
    CNavHeaderViewTypeCustom // 自定义导航栏
};

@interface CNavHeaderView : UIView

@property (nonatomic, weak) id<CNavHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIView *rightView;
// 背景图
@property (nonatomic, strong) UIImageView *bgImageView;
// 弧线起始点
@property (nonatomic, assign) CGPoint startPoint;
// 弧线结束点
@property (nonatomic, assign) CGPoint endPoint;
// 默认控制点01
@property (nonatomic, assign) CGPoint controlPoint01;
// 默认控制点02
@property (nonatomic, assign) CGPoint controlPoint02;

- (void)updateContentViewFrame;

@end

NS_ASSUME_NONNULL_END
