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
        _headerView.titleView = [self getTitleViewWithViewController:viewController];
        _headerView.leftView = [self getLeftViewWithViewController:viewController];
        _headerView.rightView = [self getRightViewWithViewController:viewController];
        
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
        // 计算转换进度
        NSMutableDictionary *tempHeaderInfoDic = [NSMutableDictionary dictionary];
        _headerView.bgImageView.alpha = progress;
        if (progress <= 0.5f)
        {
            _headerView.titleView = [self getTitleViewWithViewController:fromViewController];
            _headerView.leftView = [self getLeftViewWithViewController:fromViewController];
            _headerView.rightView = [self getRightViewWithViewController:fromViewController];
            _headerView.titleView.alpha = 1-progress;
            _headerView.closeBtn.alpha = 1-progress;
            _headerView.leftView.alpha = 1-progress;
            _headerView.rightView.alpha = 1-progress;
            
            [fromViewController navHeaderView:_headerView didChangeWithProgress:progress];
            [tempHeaderInfoDic setObject:fromVCHeaderDic[@"KHeaderBgImgName"] forKey:@"KHeaderBgImgName"];
        } else {
            _headerView.titleView = [self getTitleViewWithViewController:toViewController];
            _headerView.leftView = [self getLeftViewWithViewController:toViewController];
            _headerView.rightView = [self getRightViewWithViewController:toViewController];
            _headerView.titleView.alpha = progress;
            _headerView.closeBtn.alpha = progress;
            _headerView.leftView.alpha = progress;
            _headerView.rightView.alpha = progress;
            
            [toViewController navHeaderView:_headerView didChangeWithProgress:progress];
            [tempHeaderInfoDic setObject:toVCHeaderDic[@"KHeaderBgImgName"] forKey:@"KHeaderBgImgName"];
        }
        
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
        _headerView.leftView.alpha = 1.0f;
        _headerView.rightView.alpha = 1.0f;
        _headerView.bgImageView.alpha = 1.0f;
        
        if (CGRectGetMinX(self.topViewController.view.superview.frame) < 0) {
            _headerView.titleView = [self getTitleViewWithViewController:fromViewController];
            _headerView.leftView = [self getLeftViewWithViewController:fromViewController];
            _headerView.rightView = [self getRightViewWithViewController:fromViewController];
            _headerView.closeBtn.hidden = NO;

            [self updateHeaderViewWithHeaderInfoDic:fromVCHeaderDic];
            
            [toViewController navHeaderViewDidDismiss:_headerView];
            
            [fromViewController navHeaderViewDidShow:_headerView];
            
            NSLog(@"%@,%@",NSStringFromClass(self.class), @"手势返回放弃");
        } else {
            _headerView.titleView = [self getTitleViewWithViewController:toViewController];
            _headerView.leftView = [self getLeftViewWithViewController:toViewController];
            _headerView.rightView = [self getRightViewWithViewController:toViewController];
            _headerView.closeBtn.hidden = YES;
            
            [self updateHeaderViewWithHeaderInfoDic:toVCHeaderDic];
            
            [fromViewController navHeaderViewDidDismiss:_headerView];
            
            [toViewController navHeaderViewDidShow:_headerView];
            
            NSLog(@"%@,%@",NSStringFromClass(self.class), @"执行手势返回");
        }
        // 关闭返回手势限定
        _isPopGesture = NO;
    }
}

/// 自定义标题视图
- (UIView *)getTitleViewWithViewController:(BaseViewController *)viewController
{
    // 获取自定义的视图
    UIView *titleView = [viewController customNavTitleView];
    if (titleView==nil) {
        // 默认titleView
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.textColor = [UIColor whiteColor];
        titleLB.text = viewController.title;
        [titleLB sizeToFit];
        titleView = titleLB;
    }
    return titleView;
}
/// 自定义左边视图
- (UIView *)getLeftViewWithViewController:(BaseViewController *)viewController
{
    // 获取自定义的视图
    UIView *titleView = [viewController customNavLeftView];
    if (titleView==nil) {
        titleView = [[UIView alloc] init];
    }
    return titleView;
}
/// 自定义右边视图
- (UIView *)getRightViewWithViewController:(BaseViewController *)viewController
{
    // 获取自定义的视图
    UIView *titleView = [viewController customNavRightView];
    if (titleView==nil) {
        titleView = [[UIView alloc] init];
    }
    return titleView;
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
    NSString *bgImgName = headerInfoDic[@"KHeaderBgImgName"];
    if (bgImgName.length > 0) {
        _headerView.bgImageView.hidden = NO;
        _headerView.bgImageView.image = [UIImage imageNamed:headerInfoDic[@"KHeaderBgImgName"]];
    } else {
        _headerView.bgImageView.hidden = YES;
    }
    _headerView.startPoint = CGPointFromString(headerInfoDic[@"KStartPoint"]);
    _headerView.endPoint = CGPointFromString(headerInfoDic[@"KEndPoint"]);
    _headerView.controlPoint01 = CGPointFromString(headerInfoDic[@"KControlPoint01"]);
    _headerView.controlPoint02 = CGPointFromString(headerInfoDic[@"KControlPoint02"]);
    [_headerView setNeedsDisplay];
}

/// 设置控制器的导航栏信息
- (NSDictionary *)headerViewDicWithViewController:(BaseViewController *)viewController
{
    CGFloat headerView_H = 0.0f;
    NSString *headerBgImgName = @"";
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    CGPoint controlPoint01 = CGPointZero;
    CGPoint controlPoint02 = CGPointZero;
    NSMutableDictionary *headerViewDic = [NSMutableDictionary dictionaryWithDictionary:[viewController navHeaderViewInfoDic]];
    if (headerViewDic != nil) {
        headerView_H = [headerViewDic[@"KHeaderViewH"] floatValue]>0?[headerViewDic[@"KHeaderViewH"] floatValue]:0.0f;
        headerBgImgName = headerViewDic[@"KHeaderBgImgName"]!=nil?headerViewDic[@"KHeaderBgImgName"]:@"";
        if (headerViewDic[@"KHeaderBgImgName"]==nil) {
            startPoint = headerViewDic[@"KStartPoint"]!=nil?CGPointFromString(headerViewDic[@"KStartPoint"]):CGPointZero;
            endPoint = headerViewDic[@"KEndPoint"]!=nil?CGPointFromString(headerViewDic[@"KEndPoint"]):CGPointZero;
            controlPoint01 = headerViewDic[@"KControlPoint01"]!=nil?CGPointFromString(headerViewDic[@"KControlPoint01"]):CGPointZero;
            controlPoint02 = headerViewDic[@"KControlPoint02"]!=nil?CGPointFromString(headerViewDic[@"KControlPoint02"]):CGPointZero;
        } else {
            startPoint = CGPointMake(0.0f, 0.0f);
            endPoint = CGPointMake(KNHSCREEN_W, 0.0f);
            controlPoint01 = CGPointMake(KNHSCREEN_W/3, 0.0f);
            controlPoint02 = CGPointMake(KNHSCREEN_W*2/3, 0.0f);
        }
    } else {
        switch (viewController.viewType) {
            case CNavHeaderViewTypeCustom:
                @throw [NSException exceptionWithName:@"headerViewDic" reason:@"导航条信息不能为空!" userInfo:nil];
            case CNavHeaderViewTypeNone:
                headerView_H = 0;
                headerBgImgName = @"";
                startPoint = CGPointMake(0.0, 0);
                endPoint = CGPointMake(KNHSCREEN_W, 0);
                controlPoint01 = CGPointMake(KNHSCREEN_W/3, 0);
                controlPoint02 = CGPointMake(KNHSCREEN_W*2/3, 0);
                break;
            default:
                headerView_H = KNavHeight;
                headerBgImgName = @"";
                startPoint = CGPointMake(0.0, KNavHeight - KArcHeight);
                endPoint = CGPointMake(KNHSCREEN_W, KNavHeight - KArcHeight);
                controlPoint01 = CGPointMake(KNHSCREEN_W/3, KNavHeight);
                controlPoint02 = CGPointMake(KNHSCREEN_W*2/3, KNavHeight);
                break;
        }
    }
    
    return @{@"KHeaderViewH":@(headerView_H),
             @"KHeaderBgImgName":headerBgImgName,
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
