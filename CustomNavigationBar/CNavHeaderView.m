//
//  CNavHeaderView.m
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import "CNavHeaderView.h"

@implementation CNavHeaderView

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(didClickClosed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat KSelfWidth = CGRectGetWidth(self.frame);
    CGFloat KSelfHeight = CGRectGetHeight(self.frame);
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.titleView.backgroundColor = [UIColor grayColor];
    self.titleView.frame = CGRectMake((KSelfWidth - CGRectGetWidth(self.titleView.frame))/2, (KSelfHeight - CGRectGetHeight(self.titleView.frame))/2 , CGRectGetWidth(self.titleView.frame), CGRectGetHeight(self.titleView.frame));
    [self addSubview:self.titleView];
    
    CGFloat KItemHeight = 30;
    CGFloat KItemY = KSelfHeight>=KNavHeight?KStatuBarHeight + (KNavBarHeight - KItemHeight)/2:(KSelfHeight - KStatuBarHeight - KArcHeight)/2;
    
    self.closeBtn.frame = CGRectMake(15, KItemY, KItemHeight, KItemHeight);
    [self addSubview:self.closeBtn];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor redColor] set]; //设置线条颜色
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [path moveToPoint:CGPointMake(0.0, 0.0)];//起点
    [path addLineToPoint:_startPoint];
    if (!CGPointEqualToPoint(_controlPoint01, CGPointZero) && CGPointEqualToPoint(_controlPoint02, CGPointZero)) {
        [path addQuadCurveToPoint:_endPoint controlPoint:_controlPoint01];
    }
    if (CGPointEqualToPoint(_controlPoint01, CGPointZero) && !CGPointEqualToPoint(_controlPoint02, CGPointZero)) {
        [path addQuadCurveToPoint:_endPoint controlPoint:_controlPoint02];
    }
    if (!CGPointEqualToPoint(_controlPoint01, CGPointZero) && !CGPointEqualToPoint(_controlPoint02, CGPointZero)) {
        [path addCurveToPoint:_endPoint controlPoint1:_controlPoint01 controlPoint2:_controlPoint02];
    }
    // Draw the lines
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0.0)];
    [path closePath];//通过调用closePath方法得到的
    [path fill];//颜色填充
}

- (void)didClickClosed:(UIButton *)closeBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickClosedBtn)]) {
        return [self.delegate didClickClosedBtn];
    }
}

@end
