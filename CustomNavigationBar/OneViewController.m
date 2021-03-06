//
//  OneViewController.m
//  CustomNavigationBar
//
//  Created by AoChen on 2019/5/20.
//  Copyright © 2019 ac. All rights reserved.
//

#import "OneViewController.h"
#import "ViewController.h"
@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewType = CNavHeaderViewTypeDefault;
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn0.frame = CGRectMake(100, 200, 50, 30);
    [btn0 setTitle:@"Push_0" forState:UIControlStateNormal];
    btn0.backgroundColor = [UIColor redColor];
    [btn0 addTarget:self action:@selector(clickBtn0) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn0];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(200, 200, 50, 30);
    [btn4 setTitle:@"Push_4" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor purpleColor];
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(100, 300, 50, 30);
    [btn3 setTitle:@"Push_3" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor purpleColor];
    [btn3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(200, 300, 50, 30);
    [btn5 setTitle:@"Push_5" forState:UIControlStateNormal];
    btn5.backgroundColor = [UIColor purpleColor];
    [btn5 addTarget:self action:@selector(clickBtn5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
}

///**
// 自定义titleView
// */
//- (UIView *)customNavTitleView {
//    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    titleLB.textAlignment = NSTextAlignmentCenter;
//    titleLB.text = @"OneViewController";
//    return titleLB;
//};

- (UIView *)customNavRightView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    [btn setTitle:@"right" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)didClick:(UIButton *)sender
{
    NSLog(@"One - right");
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



- (void)clickBtn0
{
    ViewController *VC = [[ViewController alloc] init];
    VC.viewType = 0;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickBtn4
{
    ViewController *VC = [[ViewController alloc] init];
    VC.viewType = 4;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickBtn3
{
    ViewController *VC = [[ViewController alloc] init];
    VC.viewType = 3;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickBtn5
{
    ViewController *VC = [[ViewController alloc] init];
    VC.viewType = 5;
    [self.navigationController pushViewController:VC animated:YES];
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
