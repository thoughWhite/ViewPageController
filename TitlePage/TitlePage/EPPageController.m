//
//  EPPageController.m
//  TitlePage
//
//  Created by 邢大象 on 16/3/15.
//  Copyright © 2016年 邢大象. All rights reserved.
//

#import "EPPageController.h"

#import "UIView+Additions.h"
#import "TitlePagerView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define EPKController @"UIViewController"

@interface EPPageController ()<ViewPagerDataSource,ViewPagerDelegate,TitlePagerViewDelegate>

@property (nonatomic,strong) NSMutableArray *controllers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) TitlePagerView *pagingTitleView;

@end

@implementation EPPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    
    // Do not auto load data
    self.manualLoadData = YES;
    self.currentIndex = 0;
    
    self.navigationItem.titleView = self.pagingTitleView;

    [self reloadData];
    
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.controllers.count;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    return [self createViewControllerWithClassName:self.controllers[index]];
}

- (UIViewController *)createViewControllerWithClassName:(NSString *)index {
    Class class = NSClassFromString(index);
    UIViewController *controller = [[class alloc]init];
    controller.view.backgroundColor = [UIColor redColor];
    return controller;
}

- (void)didTouchBWTitle:(NSUInteger)index {
    //    NSInteger index;
    UIPageViewControllerNavigationDirection direction;
    
    if (self.currentIndex == index) {
        return;
    }
    
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    if (viewController) {
        __weak typeof(self) weakself = self;
        [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:^(BOOL finished) {
            weakself.currentIndex = index;
        }];
    }
}

- (void)setCurrentIndex:(NSInteger)index {
    _currentIndex = index;
    [self.pagingTitleView adjustTitleViewByIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if (self.currentIndex != 0 && contentOffsetX <= SCREEN_WIDTH * 2) {
        contentOffsetX += SCREEN_WIDTH * self.currentIndex;
    }
    
    [self.pagingTitleView updatePageIndicatorPosition:contentOffsetX];
}

- (void)scrollEnabled:(BOOL)enabled {
    self.scrollingLocked = !enabled;
    
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = enabled;
            view.bounces = enabled;
        }
    }
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    self.currentIndex = index;
}

- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [NSMutableArray array];
        [_controllers addObject:EPKController];
        [_controllers addObject:EPKController];
        [_controllers addObject:EPKController];
    }
    return _controllers;
}

- (TitlePagerView *)pagingTitleView {
    if (!_pagingTitleView) {
        _pagingTitleView = [[TitlePagerView alloc] init];
        _pagingTitleView.frame = CGRectMake(0, 0, 0, 40);
        _pagingTitleView.font = [UIFont systemFontOfSize:15];
        NSArray *titleArray = @[@"最新", @"热门", @"招聘"];
        _pagingTitleView.width = [TitlePagerView calculateTitleWidth:titleArray withFont:self.pagingTitleView.font];
        [self.pagingTitleView addObjects:titleArray];
        self.pagingTitleView.delegate = self;
    }
    return _pagingTitleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
