//
//  ViewController.m
//  TitlePage
//
//  Created by 邢大象 on 16/3/15.
//  Copyright © 2016年 邢大象. All rights reserved.
//

#import "ViewController.h"

#import "UIView+Additions.h"
#import "TitlePagerView.h"
#import "ViewPagerController/ViewPagerController.h"

@interface ViewController ()<TitlePagerViewDelegate,ViewPagerDataSource>

@property (nonatomic,strong) TitlePagerView *pagingTitleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.pagingTitleView;
    
//    ViewPagerController *pageController = [[ViewPagerController alloc]init];
//    pageController.dataSource = self;
//    [self addChildViewController:pageController];
    
}

#pragma mark ViewPagerDataSource
// Asks dataSource how many tabs will be
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}

// The content for any tab. Return a view controller and ViewPager will use its view to show as content
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 1) {
        UIViewController *controller = [[UIViewController alloc]init];
        controller.view.backgroundColor = [UIColor redColor];
        return controller;
    } else if (index == 2) {
        UIViewController *controller = [[UIViewController alloc]init];
        controller.view.backgroundColor = [UIColor yellowColor];
        return controller;
    } else {
        UIViewController *controller = [[UIViewController alloc]init];
        controller.view.backgroundColor = [UIColor cyanColor];
        return controller;
    }
}

//- (UIView *)viewPager:(ViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index {
//    
//}



- (void)didTouchBWTitle:(NSUInteger)index {
    NSLog(@"%lu",(unsigned long)index);
}

- (TitlePagerView *)pagingTitleView {
    if (!_pagingTitleView) {
        _pagingTitleView = [[TitlePagerView alloc] init];
        _pagingTitleView.frame = CGRectMake(0, 0, 0, 40);
        _pagingTitleView.font = [UIFont systemFontOfSize:14];
        NSArray *titleArray = @[@"最新", @"热门"];
        _pagingTitleView.width = [TitlePagerView calculateTitleWidth:titleArray withFont:self.pagingTitleView.font];
        [_pagingTitleView addObjects:titleArray];
        _pagingTitleView.delegate = self;
    }
    return _pagingTitleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
