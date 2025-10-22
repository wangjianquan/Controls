//
//  CustomTabBarController.m
//  Controls
//
//  Created by jieyue_M1 on 2025/8/4.
//  Copyright © 2025 WJQ. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomNavigationController.h"

#import "ViewController.h"
#import "RAViewController.h"
#import "PortraitViewController.h"
#import "TextViewController.h"

// 颜色常量
#define TABBAR_NORMAL_COLOR     [UIColor darkGrayColor]
#define TABBAR_SELECTED_COLOR   [UIColor redColor]
#define TABBAR_ITEM_FONT        [UIFont systemFontOfSize:12]

@interface CustomTabBarController ()<UITabBarControllerDelegate, UIContextMenuInteractionDelegate>

@property (nonatomic, strong) NSArray<NSString *> *tabTitles;
@property (nonatomic, strong) NSArray<NSString *> *normalIcons;
@property (nonatomic, strong) NSArray<NSString *> *selectedIcons;

@end

@implementation CustomTabBarController
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientation{
    return self.selectedViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}
- (void)dealloc {
}

- (instancetype)init {
    if (self = [super init]) {
        if (@available(iOS 18, *)) {
            if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                self.traitOverrides.horizontalSizeClass = UIUserInterfaceSizeClassCompact; //TAB BAR ON BOTTOM
            }
        }
        self.delegate = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.delegate = self;
    
    // 配置数据
    self.tabTitles = @[@"首页", @"商城", @"学习",@"我的"];
    self.normalIcons = @[@"tabbar_home", @"tabbar_shop", @"tabbar_study",@"tabbar_user"];
    self.selectedIcons = @[@"tabbar_home_hl", @"tabbar_shop_hl", @"tabbar_study_hl",@"tabbar_user_hl"];
    
    [self configureTabBarAppearance];
    [self setupViewControllers];
    
    // 添加3D Touch支持
    if (@available(iOS 13.0, *)) {
        [self addContextMenuInteraction];
    }
}

- (void)configureTabBarAppearance {
    // 移除默认顶部阴影线
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.backgroundImage = [UIImage new];
    
    // 添加自定义阴影效果
    self.tabBar.layer.shadowColor = [UIColor colorWithWhite:0.75 alpha:0.8].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.15;
    self.tabBar.layer.shadowRadius = 3;
    
    // iOS 13+ 使用新API
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor systemBackgroundColor];
        
        // 1. 设置正常状态样式
        NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
        normalAttributes[NSForegroundColorAttributeName] = TABBAR_NORMAL_COLOR;
        normalAttributes[NSFontAttributeName] = TABBAR_ITEM_FONT;
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes;
        
        // 2. 设置选中状态样式 - 关键修复点
        NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
        selectedAttributes[NSForegroundColorAttributeName] = TABBAR_SELECTED_COLOR;
        selectedAttributes[NSFontAttributeName] = TABBAR_ITEM_FONT;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes;
        
        // 3. 移除顶部阴影线
        appearance.shadowColor = nil;
        
        // 应用样式
        self.tabBar.standardAppearance = appearance;
        
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    }

    else {
        self.tabBar.barTintColor = [UIColor whiteColor];
        
        // 全局设置文字样式
        [[UITabBarItem appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: TABBAR_NORMAL_COLOR,
            NSFontAttributeName: TABBAR_ITEM_FONT
        } forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: TABBAR_SELECTED_COLOR,
            NSFontAttributeName: TABBAR_ITEM_FONT
        } forState:UIControlStateSelected];
    }
}

- (void)setupViewControllers {
    NSMutableArray *controllers = [NSMutableArray array];
    for (int i = 0; i < self.tabTitles.count; i++) {
        UIViewController *vc;
        // 根据索引创建不同控制器
        switch (i) {
            case 0: vc = [[ViewController alloc] init]; break;
            case 1: vc = [[RAViewController alloc] init]; break;
            case 2: vc = [[PortraitViewController alloc] init]; break;
            case 3: vc = [[TextViewController alloc] init]; break;
        }
        UINavigationController *nav = [self navigationControllerForViewController:vc index:i];
        [controllers addObject:nav];
    }
    self.viewControllers = controllers;
}

- (UINavigationController *)navigationControllerForViewController:(UIViewController *)vc index:(NSInteger)index {
    vc.title = self.tabTitles[index];
    UIImage *normalImage = [UIImage imageNamed:self.normalIcons[index]];
    UIImage *selectedImage = [UIImage imageNamed:self.selectedIcons[index]];
    // 确保图片存在
    if (!normalImage) {
        NSLog(@"⚠️ 正常图标缺失: %@", self.normalIcons[index]);
        normalImage = [UIImage systemImageNamed:@"circle"];
    }
    if (!selectedImage) {
        NSLog(@"⚠️ 选中图标缺失: %@", self.selectedIcons[index]);
        selectedImage = [UIImage systemImageNamed:@"circle.fill"];
    }
    // 使用原始渲染模式
    vc.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 单独设置文字样式 - 确保覆盖系统默认
    [vc.tabBarItem setTitleTextAttributes:@{
        NSForegroundColorAttributeName: TABBAR_NORMAL_COLOR,
        NSFontAttributeName: TABBAR_ITEM_FONT
    } forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{
        NSForegroundColorAttributeName: TABBAR_SELECTED_COLOR,
        NSFontAttributeName: TABBAR_ITEM_FONT
    } forState:UIControlStateSelected];
    return [[CustomNavigationController alloc] initWithRootViewController:vc];
}

#pragma mark - 3D Touch 上下文菜单
- (void)addContextMenuInteraction {
    for (UITabBarItem *item in self.tabBar.items) {
        UIView *view = [item valueForKey:@"view"];
        if (view) {
            UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
            [view addInteraction:interaction];
        }
    }
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UIView *view = [self.tabBar.items[i] valueForKey:@"view"];
        if (view == interaction.view) {
            return [self contextMenuConfigurationForIndex:i];
        }
    }
    return nil;
}

- (UIContextMenuConfiguration *)contextMenuConfigurationForIndex:(NSUInteger)index {
    NSString *title = self.tabTitles[index];
    
    return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIAction *action1 = [UIAction actionWithTitle:@"刷新内容" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 处理刷新操作
        }];
        
        UIAction *action2 = [UIAction actionWithTitle:@"查看通知" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 处理通知操作
        }];
        return [UIMenu menuWithTitle:title children:@[action1, action2]];
    }];
}

#pragma mark - 标签项点击动画
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    [self animateTabItemSelectionAtIndex:index];
    return YES;
}

- (void)animateTabItemSelectionAtIndex:(NSUInteger)index {
    NSArray *tabItems = self.tabBar.items;
    if (index < tabItems.count) {
        UIView *iconView = [tabItems[index] valueForKey:@"view"];
        
        [UIView animateWithDuration:0.1
                         animations:^{
            iconView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                iconView.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }
}

#pragma mark - 徽章管理
- (void)setBadgeValue:(NSString *)value atIndex:(NSInteger)index badgeColor:(UIColor *)color textColor:(UIColor *)textColor {
    if (index < self.tabBar.items.count) {
        UITabBarItem *item = self.tabBar.items[index];
        item.badgeValue = value;
        if (@available(iOS 10.0, *)) {
            [item setBadgeColor:color];
            [item setBadgeTextAttributes:@{NSForegroundColorAttributeName: textColor} forState:UIControlStateNormal];
        }
    }
}


@end
