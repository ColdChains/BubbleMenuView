//
//  LCBubbleMenuView.h
//  LCBubbleMenuView
//
//  Created by lax on 2022/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LCMenuListViewArrowPosition) {
    LCMenuListViewArrowPositionNone = 0,
    LCMenuListViewArrowPositionLeft = 1 << 0,
    LCMenuListViewArrowPositionRight = 1 << 1,
};

typedef NS_OPTIONS(NSUInteger, LCMenuListViewBubblePosition) {
    LCMenuListViewBubblePositionNone = 0,
    LCMenuListViewBubblePositionUp = 1 << 0,
    LCMenuListViewBubblePositionDown = 1 << 1,
};

@interface LCBubbleMenuView : UIView

// 点击cell回调
@property (nonatomic, copy) void(^selectBlock)(NSNumber *index);

// 菜单内容
@property (nonatomic, strong, readonly) UIImageView *contentView;

// 气泡显示位置
@property (nonatomic, readonly) LCMenuListViewBubblePosition bubblePosition;

// 箭头显示位置
@property (nonatomic, readonly) LCMenuListViewArrowPosition arrowPosition;

// 默认气泡位置上边
@property (nonatomic) LCMenuListViewBubblePosition defaultBubblePosition;

// 默认箭头位置左边
@property (nonatomic) LCMenuListViewArrowPosition defaultArrowPosition;

// 气泡高度
@property (nonatomic, readonly) CGFloat bubbleHeight;

// 选择菜单后自动隐藏 默认YES
@property (nonatomic) BOOL autoHidden;

// 气泡距离四周的最小边距
@property (nonatomic) UIEdgeInsets edgeInsets;

// 菜单大小
@property (nonatomic) CGSize itemSize;

// 菜单字体
@property (nonatomic, strong) UIFont *itemFont;

// 菜单颜色
@property (nonatomic, strong) UIColor *itemFontColor;

// 分割线颜色
@property (nonatomic, strong) UIColor *dividerColor;

// 显示
- (void)showInView:(UIView *)view targetView:(UIView *)targetView dataArray:(NSArray<NSString *> *)dataArray;

/// 显示
/// @param view 父view
/// @param targetView 箭头指向的view
/// @param margin 箭头距离指向view的间距
/// @param dataArray 数据源
/// @param animated 动画
- (void)showInView:(UIView *)view targetView:(UIView *)targetView dataArray:(NSArray<NSString *> *)dataArray margin:(CGFloat)margin animated:(BOOL)animated;

// 隐藏
- (void)hideWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
