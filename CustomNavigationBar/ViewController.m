//
//  ViewController.m
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/15.
//  Copyright © 2019 ac. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"ViewController";
    
    self.viewType = CNavHeaderViewTypeCustom;
}

- (NSDictionary *)navHeaderViewInfoDic
{
    CGFloat headerView_H = KNavHeight*1.5;
    CGPoint startPoint = CGPointMake(0.0, KNavHeight + KArcHeight);
    CGPoint endPoint = CGPointMake(KNHSCREEN_W, KNavHeight + KArcHeight);
    CGPoint controlPoint01 = CGPointMake(KNHSCREEN_W/3, KNavHeight*1.5 + KArcHeight - 3);
    CGPoint controlPoint02 = CGPointMake(KNHSCREEN_W*2/3, KNavHeight*1 - KArcHeight + 3);

    return @{@"KHeaderViewH":@(headerView_H),
             @"KHeaderBgImgName":@"changecode_bg",
             @"KStartPoint":NSStringFromCGPoint(startPoint),
             @"KEndPoint":NSStringFromCGPoint(endPoint),
             @"KControlPoint01":NSStringFromCGPoint(controlPoint01),
             @"KControlPoint02":NSStringFromCGPoint(controlPoint02)};
}


/**
 自定义titleView
 */
- (UIView *)customNavTitleView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    [btn setTitle:@"ViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
};

- (void)didClick:(UIButton *)sender
{
    NSLog(@"123");
    
    [sender setTitle:@"123" forState:UIControlStateNormal];
}

- (UIView *)customNavRightView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    [btn setTitle:@"right" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didRightClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)didRightClick:(UIButton *)sender
{
    NSLog(@"View - right");
}

- (void)navHeaderViewDidClickBackBtn
{
    NSLog(@"%s",__func__);
}

- (void)navHeaderViewWillShow:(CNavHeaderView *)headerView
{
    NSLog(@"%s",__func__);
}

- (void)navHeaderViewDidShow:(CNavHeaderView *)headerView
{
    NSLog(@"%s",__func__);
}

- (void)navHeaderView:(CNavHeaderView *)headerView didChangeWithProgress:(CGFloat)progress
{
    NSLog(@"%s,progress:%.2f",__func__,progress);
}

- (void)navHeaderViewWillDismiss:(CNavHeaderView *)headerView
{
    NSLog(@"%s",__func__);
}

- (void)navHeaderViewDidDismiss:(CNavHeaderView *)headerView
{
    NSLog(@"%s",__func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
