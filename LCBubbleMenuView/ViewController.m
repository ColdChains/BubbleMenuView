//
//  ViewController.m
//  LCBubbleMenuView
//
//  Created by lax on 2022/6/23.
//

#import "ViewController.h"
#import "LCBubbleMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonAction:(UIButton *)sender {
    LCBubbleMenuView *menuView = [[LCBubbleMenuView alloc] init];
    menuView.edgeInsets = UIEdgeInsetsMake(22, 22, 22, 22);
    // 自定义样式
    menuView.defaultBubblePosition = LCMenuListViewBubblePositionDown;
    menuView.defaultArrowPosition = LCMenuListViewArrowPositionRight;
    menuView.itemFontColor = [UIColor redColor];
    menuView.itemSize = CGSizeMake(50, 25);
    menuView.contentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;;
    menuView.selectBlock = ^(NSNumber * _Nonnull index) {
        NSLog(@"%@", index);
    };
    // 显示
    [menuView showInView:self.view targetView:sender dataArray:@[@"确定", @"取消"] margin:8 animated:YES];
}

@end
