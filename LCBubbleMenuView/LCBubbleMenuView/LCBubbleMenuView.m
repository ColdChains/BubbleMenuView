//
//  LCBubbleMenuView.m
//  LCBubbleMenuView
//
//  Created by lax on 2022/6/22.
//

#import "LCBubbleMenuView.h"
#import <Masonry/Masonry.h>

#define LCMenu_SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCMenu_SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define LCMenu_IS_IPHONEX              (LCMenu_SCREEN_WIDTH >= 375.0f && LCMenu_SCREEN_HEIGHT >= 812.0f)

#define LCMenu_NAVIGATIONBAR_HEIGHT    (LCMenu_IS_IPHONEX ? 44.0f : 20.0f)

#define LCMenu_BOTTOM_MARGIN           (LCMenu_IS_IPHONEX ? 34.0f : 10.0f)

@interface LCBubbleMenuView ()

// 气泡位置 默认上边
@property (nonatomic) LCMenuListViewBubblePosition bubblePosition;

// 箭头位置 默认左边
@property (nonatomic) LCMenuListViewArrowPosition arrowPosition;

// 气泡高度
@property (nonatomic) CGFloat bubbleHeight;

@property (nonatomic, strong) UIImageView *contentView;

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, copy) NSArray<NSString *> *dataArray;

@end

@implementation LCBubbleMenuView

- (CGFloat)bubbleHeight {
    return self.dataArray.count * self.itemSize.height + 12 + 6;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        _contentView.userInteractionEnabled = YES;
        _contentView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(0, 2);
        _contentView.layer.shadowRadius = 8;
        _contentView.layer.shadowOpacity = 1;
    }
    return _contentView;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
    }
    return _stackView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.defaultBubblePosition = LCMenuListViewBubblePositionUp;
        self.defaultArrowPosition = LCMenuListViewArrowPositionLeft;
        
        self.autoHidden = YES;
        self.edgeInsets = UIEdgeInsetsMake(LCMenu_NAVIGATIONBAR_HEIGHT, 12, LCMenu_BOTTOM_MARGIN, 12);
        self.itemSize = CGSizeMake(96, 36);
        self.itemFont = [UIFont systemFontOfSize:12];
        self.itemFontColor = [UIColor darkTextColor];
        self.dividerColor = [UIColor colorWithWhite:0 alpha:0.05];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.stackView];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self hideWithAnimated:YES];
    }
}

- (void)showInView:(UIView *)view targetView:(UIView *)targetView dataArray:(NSArray<NSString *> *)dataArray {
    [self showInView:view targetView:targetView dataArray:dataArray margin:0 animated:YES];
}

- (void)showInView:(UIView *)view targetView:(UIView *)targetView dataArray:(NSArray<NSString *> *)dataArray margin:(CGFloat)margin animated:(BOOL)animated {
    if (dataArray.count == 0) {
        return;
    }
    
    self.dataArray = dataArray;
    
    CGRect rect = [targetView.superview convertRect:targetView.frame toView:view];
    
    LCMenuListViewBubblePosition bubblePosition = LCMenuListViewBubblePositionNone;
    if (CGRectGetMinY(rect) >= self.bubbleHeight + self.edgeInsets.top) {
        bubblePosition = bubblePosition | LCMenuListViewBubblePositionUp;
    }
    if (CGRectGetHeight(view.frame) - CGRectGetMaxY(rect) >= self.bubbleHeight + self.edgeInsets.bottom) {
        bubblePosition = bubblePosition | LCMenuListViewBubblePositionDown;
    }
    self.bubblePosition = self.defaultBubblePosition & bubblePosition;
    if (self.bubblePosition == LCMenuListViewArrowPositionNone) {
        self.bubblePosition = (bubblePosition & LCMenuListViewBubblePositionUp) ?: (bubblePosition & LCMenuListViewBubblePositionDown) ?: LCMenuListViewBubblePositionNone;
    }
    
    LCMenuListViewArrowPosition arrowPosition = LCMenuListViewArrowPositionNone;
    if (CGRectGetWidth(view.frame) - CGRectGetMinX(rect) >= self.itemSize.width + self.edgeInsets.right) {
        arrowPosition = arrowPosition | LCMenuListViewArrowPositionLeft;
    }
    if (CGRectGetMaxX(rect) >= self.itemSize.width + self.edgeInsets.left) {
        arrowPosition = arrowPosition | LCMenuListViewArrowPositionRight;
    }
    self.arrowPosition = self.defaultArrowPosition & arrowPosition;
    if (self.arrowPosition == LCMenuListViewArrowPositionNone) {
        self.arrowPosition = (arrowPosition & LCMenuListViewArrowPositionLeft) ?: (arrowPosition & LCMenuListViewArrowPositionRight) ?: LCMenuListViewArrowPositionNone;
    }
    
    if (self.bubblePosition == LCMenuListViewBubblePositionNone || self.arrowPosition == LCMenuListViewArrowPositionNone) {
        return;
    }
    
    [self initView];
    
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.arrowPosition == LCMenuListViewArrowPositionLeft) {
            make.left.mas_equalTo(MAX(self.edgeInsets.left, CGRectGetMinX(rect)));
        } else {
            make.right.mas_equalTo(-MAX(self.edgeInsets.right, CGRectGetWidth(view.frame) - CGRectGetMaxX(rect)));
        }
        if (self.bubblePosition == LCMenuListViewBubblePositionUp) {
            make.top.mas_equalTo(CGRectGetMinY(rect) - margin - self.bubbleHeight);
        } else {
            make.top.mas_equalTo(CGRectGetMaxY(rect) + margin);
        }
        make.width.mas_equalTo(self.itemSize.width);
    }];
    
    self.contentView.alpha = 0;
    [view layoutIfNeeded];
    
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        self.contentView.alpha = 1;
    }];
}

- (void)hideWithAnimated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.25 : 0 animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)initView {
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(self.bubblePosition == LCMenuListViewBubblePositionUp ? 6 : 12);
        make.bottom.mas_equalTo(self.bubblePosition == LCMenuListViewBubblePositionUp ? -12 : -6);
    }];
    
    UIImage *image = self.bubblePosition == LCMenuListViewBubblePositionUp ? [UIImage imageNamed:@"icon_bubble_down"] : [UIImage imageNamed:@"icon_bubble_up"];
    CGFloat left = self.arrowPosition == LCMenuListViewArrowPositionLeft ? 22 : 6;
    image = [image stretchableImageWithLeftCapWidth:left topCapHeight:12];
    self.contentView.image = image;
    
    for (UIView *view in self.stackView.subviews.reverseObjectEnumerator) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100 + i;
        label.text = self.dataArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.itemFontColor;
        label.font = self.itemFont;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
        [self.stackView addArrangedSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.itemSize.height);
        }];
        
        if (i < self.dataArray.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = self.dividerColor;
            [self.stackView addArrangedSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.5);
            }];
        }
        
    }
}

- (void)tapAction:(UIGestureRecognizer *)sender {
    if (sender.view.tag - 100 < 0 || sender.view.tag - 100 >= self.dataArray.count) {
        return;
    }
    if (self.autoHidden) {
        [self hideWithAnimated:NO];
    }
    if (self.selectBlock) {
        self.selectBlock(@(sender.view.tag - 100));
    }
}

@end
