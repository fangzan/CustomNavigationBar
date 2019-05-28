//
//  CNavigationController.m
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import "CNavigationController.h"
#import "BaseViewController.h"
#import "CNavHeaderView.h"

@interface CNavigationController ()<CNavHeaderViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) BaseViewController *viewControllerPopping;

@property (nonatomic, strong) CNavHeaderView *headerView;

@property (nonatomic, assign) BOOL isPopGesture;

@end

@implementation CNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 隐藏系统导航栏
    self.navigationBar.hidden = YES;
    // 添加系统代理
    self.delegate = self;
    // 添加自定义导航栏
    [self.view addSubview:self.headerView];
    // 添加系统返回手势
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handleInteractivePopGestureRecognizer:)];
}

/// 重写系统ViewController显示方法
- (void)navigationController:(CNavigationController *)navigationController willShowViewController:(BaseViewController *)viewController animated:(BOOL)animated
{
    NSDictionary *headerDic = [self headerViewDicWithViewController:viewController];
    
    if (!_isPopGesture) {
        _headerView.closeBtn.hidden = self.viewControllers.count<2?YES:NO;
        
        _headerView.titleView = [viewController customNavHeaderView];
        
        [self updateHeaderViewWithHeaderInfoDic:headerDic];
        // 自定义导航条将要显示
        [viewController navHeaderViewWillShow:_headerView];
        // 自定义导航条已经显示
        [viewController navHeaderViewDidShow:_headerView];
        
    } else {
        
        // 自定义导航条将要显示
        [viewController navHeaderViewWillShow:_headerView];
        
        _headerView.closeBtn.hidden = NO;
    }
}

/// 重写系统ViewController返回方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count < 2) {
        // 返回第一层视图
        return [super popViewControllerAnimated:animated];
    }
    
    UIViewController *viewController = [self topViewController];
    // 记录将要放回的视图
    self.viewControllerPopping = (BaseViewController *)viewController;
    // 导航条将要消失
    [self.viewControllerPopping navHeaderViewWillDismiss:_headerView];
    
    viewController = [super popViewControllerAnimated:animated];
    // 返回视图
    return viewController;
}

/// 接管系统手势返回的回调
- (void)handleInteractivePopGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    UIGestureRecognizerState state = gestureRecognizer.state;
    // 开启返回手势限定
    _isPopGesture = YES;
    // 回去转换的控制器
    BaseViewController *fromViewController = self.viewControllerPopping;
    BaseViewController *toViewController = (BaseViewController *)self.topViewController;
    // 计算转换进度
    CGFloat progress = [gestureRecognizer translationInView:self.view].x/CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    // 获取转换控制器导航信息
    NSDictionary *fromVCHeaderDic = [self headerViewDicWithViewController:fromViewController];
    NSDictionary *toVCHeaderDic = [self headerViewDicWithViewController:toViewController];
    
    // 更新导航栏样式
    if (state == UIGestureRecognizerStateChanged)
    {
        if (progress <= 0.5f)
        {
            _headerView.titleView = [fromViewController customNavHeaderView];
            _headerView.titleView.alpha = 1-progress;
            _headerView.closeBtn.alpha = 1-progress;
            
            [fromViewController navHeaderView:_headerView didChangeWithProgress:progress];
        } else {
            _headerView.titleView = [toViewController customNavHeaderView];
            _headerView.titleView.alpha = progress;
            _headerView.closeBtn.alpha = progress;
        
            [toViewController navHeaderView:_headerView didChangeWithProgress:progress];
        }
        // 计算转换进度
        NSMutableDictionary *tempHeaderInfoDic = [NSMutableDictionary dictionary];
        
        CGFloat headerView_H = [fromVCHeaderDic[@"KHeaderViewH"] floatValue] + ([toVCHeaderDic[@"KHeaderViewH"] floatValue] - [fromVCHeaderDic[@"KHeaderViewH"] floatValue])*progress;
        [tempHeaderInfoDic setObject:@(headerView_H) forKey:@"KHeaderViewH"];
        
        NSString *changeStartPointStr = [self getChangePointStrWithFromPointStr:fromVCHeaderDic[@"KStartPoint"] toPointStr:toVCHeaderDic[@"KStartPoint"] progress:progress];
        [tempHeaderInfoDic setObject:changeStartPointStr forKey:@"KStartPoint"];
        
        NSString *changeEndPointStr = [self getChangePointStrWithFromPointStr:fromVCHeaderDic[@"KEndPoint"] toPointStr:toVCHeaderDic[@"KEndPoint"] progress:progress];
        [tempHeaderInfoDic setObject:changeEndPointStr forKey:@"KEndPoint"];
        
        NSString *changeCPoint01Str = [self getChangePointStrWithFromPointStr:fromVCHeaderDic[@"KControlPoint01"] toPointStr:toVCHeaderDic[@"KControlPoint01"] progress:progress];
        [tempHeaderInfoDic setObject:changeCPoint01Str forKey:@"KControlPoint01"];
        
        NSString *changeCPoint02Str = [self getChangePointStrWithFromPointStr:fromVCHeaderDic[@"KControlPoint02"] toPointStr:toVCHeaderDic[@"KControlPoint02"] progress:progress];
        [tempHeaderInfoDic setObject:changeCPoint02Str forKey:@"KControlPoint02"];
        
        [self updateHeaderViewWithHeaderInfoDic:tempHeaderInfoDic];
    }
    else if (state == UIGestureRecognizerStateEnded)
    {
        // 手势结束 确定最终的导航栏样式
        _headerView.titleView.alpha = 1.0f;
        _headerView.closeBtn.alpha = 1.0f;
        
        if (CGRectGetMinX(self.topViewController.view.superview.frame) < 0) {
            _headerView.titleView = [fromViewController customNavHeaderView];
            _headerView.closeBtn.hidden = NO;

            [self updateHeaderViewWithHeaderInfoDic:fromVCHeaderDic];
            
            [fromViewController navHeaderViewDidShow:_headerView];
            
            [toViewController navHeaderViewDidDismiss:_headerView];
            
            NSLog(@"%@,%@",NSStringFromClass(self.class), @"手势返回放弃");
        } else {
            _headerView.titleView = [toViewController customNavHeaderView];
            _headerView.closeBtn.hidden = YES;
            
            [self updateHeaderViewWithHeaderInfoDic:toVCHeaderDic];
            
            [toViewController navHeaderViewDidShow:_headerView];
            
            [fromViewController navHeaderViewDidDismiss:_headerView];
            
            NSLog(@"%@,%@",NSStringFromClass(self.class), @"执行手势返回");
        }
        // 关闭返回手势限定
        _isPopGesture = NO;
    }
}

/// 计算转换进度方法
- (NSString *)getChangePointStrWithFromPointStr:(NSString *)fromPointStr toPointStr:(NSString *)toPointStr progress:(CGFloat)progress
{
    CGPoint tempFromPoint = CGPointFromString(fromPointStr); CGPoint tempToPoint = CGPointFromString(toPointStr);
    CGFloat tempChangePointX = tempFromPoint.x + (tempToPoint.x - tempFromPoint.x)*progress;
    CGFloat tempChangePointY;
    if (tempFromPoint.y <= tempToPoint.y) {
        tempChangePointY = tempFromPoint.y + (tempToPoint.y - tempFromPoint.y)*progress;
    } else {
        tempChangePointY = tempFromPoint.y - (tempFromPoint.y - tempToPoint.y)*progress;
    }
    return NSStringFromCGPoint(CGPointMake(tempChangePointX, tempChangePointY));
}

/// 更新视图样式
- (void)updateHeaderViewWithHeaderInfoDic:(NSDictionary *)headerInfoDic
{
    CGFloat headerViewH = [headerInfoDic[@"KHeaderViewH"] floatValue];
    _headerView.titleView.hidden = headerViewH<=0?YES:NO;
    _headerView.hidden = headerViewH<=0?YES:NO;
    // 默认系统导航栏
    _headerView.frame = CGRectMake(0, 0, KNHSCREEN_W, headerViewH);
    if (headerViewH <= 0) { return; }
    _headerView.startPoint = CGPointFromString(headerInfoDic[@"KStartPoint"]);
    _headerView.endPoint = CGPointFromString(headerInfoDic[@"KEndPoint"]);
    _headerView.controlPoint01 = CGPointFromString(headerInfoDic[@"KControlPoint01"]);
    _headerView.controlPoint02 = CGPointFromString(headerInfoDic[@"KControlPoint02"]);
    [_headerView setNeedsDisplay];
}

/// 设置控制器的导航栏信息
- (NSDictionary *)headerViewDicWithViewController:(BaseViewController *)viewController
{
    CGFloat headerView_H = 0;
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    CGPoint controlPoint01 = CGPointZero;
    CGPoint controlPoint02 = CGPointZero;
    NSDictionary *headerViewDic;
    switch (viewController.viewType) {
        case CNavHeaderViewTypeNone:
            headerView_H = 0;
            startPoint = CGPointMake(0.0, 0);
            endPoint = CGPointMake(KNHSCREEN_W, 0);
            controlPoint01 = CGPointMake(KNHSCREEN_W/2, 0);
            controlPoint02 = CGPointMake(KNHSCREEN_W/2, 0);
            break;
        case CNavHeaderViewTypeCustom:
            headerViewDic = [viewController navHeaderViewInfoDic];
            if (headerViewDic != nil) {
                return headerViewDic;
            }
        default:
            headerView_H = KNavHeight;
            startPoint = CGPointMake(0.0, KNavHeight - KArcHeight);
            endPoint = CGPointMake(KNHSCREEN_W, KNavHeight - KArcHeight);
            controlPoint01 = CGPointMake(KNHSCREEN_W/3, KNavHeight);
            controlPoint02 = CGPointMake(KNHSCREEN_W*2/3, KNavHeight);
            break;
    }
    
    return @{@"KHeaderViewH":@(headerView_H),
             @"KStartPoint":NSStringFromCGPoint(startPoint),
             @"KEndPoint":NSStringFromCGPoint(endPoint),
             @"KControlPoint01":NSStringFromCGPoint(controlPoint01),
             @"KControlPoint02":NSStringFromCGPoint(controlPoint02)};
}

/// 懒加载
- (CNavHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CNavHeaderView alloc] init];
        // 设置背景色
        _headerView.backgroundColor = [UIColor clearColor];
        // 设置阴影颜色
        _headerView.layer.shadowColor = [UIColor grayColor].CGColor;
        // 设置阴影的偏移量，默认是（0， -3）
        _headerView.layer.shadowOffset = CGSizeMake(3, 3);
        // 设置阴影不透明度，默认是0
        _headerView.layer.shadowOpacity = 0.8;
        // 设置阴影的半径，默认是3
        _headerView.layer.shadowRadius = 4;
        // 设置代理
        _headerView.delegate = self;
    }
    return _headerView;
}

// MARK:- BaseHeaderViewDelegate
- (void)didClickClosedBtn
{
    UIViewController *viewController = [self topViewController];
    // 记录将要放回的视图
    self.viewControllerPopping = (BaseViewController *)viewController;
    // 点击返回按钮时间
    [self.viewControllerPopping navHeaderViewDidClickBackBtn];
    
    [self popViewControllerAnimated:YES];
}

@end
