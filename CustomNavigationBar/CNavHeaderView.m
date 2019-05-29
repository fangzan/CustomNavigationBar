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

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self updateContentViewFrame];
}

- (void)updateContentViewFrame
{
    CGFloat KSelfWidth = CGRectGetWidth(self.frame);
    CGFloat KSelfHeight = CGRectGetHeight(self.frame);
    
    CGFloat KItemMargin = 5; CGFloat KItemHeight = 30;
    CGFloat KItemY = KSelfHeight>=KNavHeight?KStatuBarHeight + (KNavBarHeight - KItemHeight)/2:(KSelfHeight - KStatuBarHeight - KArcHeight)/2;
    
    self.bgImageView.frame = self.bounds;
    [self addSubview:self.bgImageView];
    
    self.closeBtn.frame = CGRectMake(KItemMargin*3, KItemY, KItemHeight, KItemHeight);
    [self addSubview:self.closeBtn];
    self.leftView.frame = CGRectMake(CGRectGetMaxX(self.closeBtn.frame) + KItemMargin, KItemY, CGRectGetWidth(self.leftView.frame), CGRectGetHeight(self.leftView.frame));
    [self addSubview:self.leftView];
    self.titleView.frame = CGRectMake((KSelfWidth - CGRectGetWidth(self.titleView.frame))/2, KItemY, CGRectGetWidth(self.titleView.frame), CGRectGetHeight(self.titleView.frame));
    [self addSubview:self.titleView];
    self.rightView.frame = CGRectMake(KSelfWidth - CGRectGetWidth(self.rightView.frame) - KItemMargin, KItemY, CGRectGetWidth(self.rightView.frame), CGRectGetHeight(self.rightView.frame));
    [self addSubview:self.rightView];
}

- (void)drawRect:(CGRect)rect
{
    if (_bgImageView.isHidden) {
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
}

- (void)didClickClosed:(UIButton *)closeBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickClosedBtn)]) {
        return [self.delegate didClickClosedBtn];
    }
}

@end
