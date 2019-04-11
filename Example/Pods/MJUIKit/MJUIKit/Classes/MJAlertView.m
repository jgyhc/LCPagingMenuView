//
//  MJAlertView.m
//  ManJi
//
//  Created by manjiwang on 2019/1/15.
//  Copyright © 2019 Zgmanhui. All rights reserved.
//

#import "MJAlertView.h"
#import "Masonry.h"

NSString * const MJAlertViewButtonTitleKey = @"title";
NSString * const MJAlertViewButtonTextColorKey = @"textColor";
NSString * const MJAlertViewButtonFontKey = @"font";
NSString * const MJAlertViewButtonNormalBackgroundColorKey = @"normalBackgroundColor";
NSString * const MJAlertViewButtonHighlightedBackgroundColorKey = @"highlightedBackgroundColor";
@interface MJAlertView ()

@property (nonatomic, strong) UIAlertView * alertView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIControl * backgroundControl;

@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, strong) NSArray * buttonViews;
@end

@implementation MJAlertView

+ (instancetype)initWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertViewCompletionBlock)tapBlock {
    return [[MJAlertView alloc] initWithTitle:title content:content buttons:buttons tapBlock:tapBlock];
}

- (instancetype)initWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertViewCompletionBlock)tapBlock {
    self = [super init];
    if (self) {
        self.tapBlock = tapBlock;
        self.title = title;
        self.buttons = buttons;
        self.content = content;
        [self initSubViews];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    if ([self isCanBackBackgroundView]) {
        [self addBackgroundControl];
    }
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).mas_offset(50);
        make.right.mas_equalTo(self.mas_right).mas_offset(-50);
        make.height.mas_greaterThanOrEqualTo([self buttonHeight] + 40 + 30);
    }];
}

- (void)show {
    if ([_title isKindOfClass:[NSString class]] && _title.length > 0 && [self isAddTitleView]) {
        _contentTopSpace = 40;
        [self addTitleView];
        self.titleLabel.text = _title;
    }else {
        _contentTopSpace = 5;
    }
    
    [self updateButtons];
    
    if ([_content isKindOfClass:[NSString class]] && _content.length > 0) {
        [self addContentLabel];
        self.contentLabel.text = _content;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    self.containerView.alpha = 0;
    self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 0.5, 0.5);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 1/0.5, 1/0.5);
        self.containerView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 0.5, 0.5);
        self.containerView.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        self.containerView.alpha = 1;
        self.containerView.transform = CGAffineTransformScale(self.containerView.transform, 1/0.5, 1/0.5);
        [self removeFromSuperview];
    }];
}

- (BOOL)isCanBackBackgroundView {
    return NO;
}

- (BOOL)isAddTitleView {
    return YES;
}

- (CGFloat)buttonHeight {
    return 44.0;
}



- (void)updateButtons {
    CGFloat buttonHeight = [self buttonHeight];
    if (_buttons.count == 0) {
        _contentBottomSpace = 5;
        return;
    }
    if (_buttons.count == 1) {
        UIButton *button = [self getButtonWithObj:[_buttons objectAtIndex:0]];
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView.mas_bottom);
            make.left.mas_equalTo(self.containerView.mas_left);
            make.right.mas_equalTo(self.containerView.mas_right);
            make.height.mas_equalTo(buttonHeight);
            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.contentTopSpace);
        }];
        _contentBottomSpace = buttonHeight;
        _buttonViews = @[button];
    }else if (_buttons.count == 2) {
        UIButton *button = [self getButtonWithObj:[_buttons objectAtIndex:0]];
        UIButton *button1 = [self getButtonWithObj:[_buttons objectAtIndex:1]];
        if (button.currentTitle.length > 6 || button1.currentTitle.length > 6) {
            [self multipleColumnsTypographyWithButtonHeight:buttonHeight];
            return;
        }
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.containerView.mas_left);
            make.bottom.mas_equalTo(self.containerView.mas_bottom);
            make.height.mas_equalTo(buttonHeight);
            make.width.mas_equalTo(self.containerView.mas_width).multipliedBy(0.5);
            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.contentTopSpace);
        }];
        
        [self.containerView addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.containerView.mas_bottom);
            make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-0.5);
            make.height.mas_equalTo(buttonHeight);
            make.width.mas_equalTo(self.containerView.mas_width).multipliedBy(0.5).mas_offset(1);
            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.contentTopSpace);
        }];
        _contentBottomSpace = buttonHeight;
        _buttonViews = @[button, button1];
    }else {
        [self multipleColumnsTypographyWithButtonHeight:buttonHeight];
    }
}


- (void)multipleColumnsTypographyWithButtonHeight:(CGFloat)buttonHeight {
    CGFloat bottomSpace = 0;
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger idx = _buttons.count - 1; idx >= 0; idx --) {
        UIButton *button = [self getButtonWithObj:_buttons[idx]];
        [buttons addObject:button];
        [self.containerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.containerView.mas_left);
            make.right.mas_equalTo(self.containerView.mas_right);
            make.height.mas_equalTo(buttonHeight);
            make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-1 * bottomSpace);
            make.top.mas_greaterThanOrEqualTo(self.containerView.mas_top).mas_offset(self.contentTopSpace);
        }];
        bottomSpace = bottomSpace + buttonHeight - 0.5;
    }
    _buttonViews = buttons;
    _contentBottomSpace = bottomSpace;
}



- (void)addTitleView {
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left);
        make.right.mas_equalTo(self.containerView.mas_right);
        make.top.mas_equalTo(self.containerView.mas_top);
        make.height.mas_equalTo(40);
    }];
}

- (void)addContentLabel {
    [self.containerView addSubview:self.contentLabel];
    CGFloat topSpace = _contentTopSpace + 15;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top).mas_offset(topSpace);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-self.contentBottomSpace - 15);
        make.left.mas_equalTo(self.containerView.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.containerView.mas_right).mas_offset(-15);
    }];
}

- (void)handleButtonEvent:(UIButton *)sender {
    if (self.tapBlock) {
        __block NSInteger buttonIdx = 0;
        [_buttonViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:sender]) {
                buttonIdx = idx;
            }
        }];
        self.tapBlock(self, sender.currentTitle, buttonIdx);
    }
    [self hide];
}

- (UIButton *)getButtonWithObj:(id)obj {
    if ([obj isKindOfClass:[UIButton class]]) {
        return obj;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0].CGColor;
    button.layer.borderWidth = 0.5;
    NSString *title;
    UIColor *textColor = [UIColor colorWithRed:55/255.0 green:161/255.0 blue:255/255.0 alpha:1.0];
    UIColor *backgroundColor = [UIColor whiteColor];
    UIColor *highlightedBackgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    if ([obj isKindOfClass:[NSString class]]) {
        title = obj;
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = obj;
        title = [dictionary objectForKey:MJAlertViewButtonTitleKey];
        UIColor *color = [dictionary objectForKey:MJAlertViewButtonTextColorKey];
        if (color) {
            textColor = color;
        }
        UIFont *font = [dictionary objectForKey:MJAlertViewButtonFontKey];
        if (font) {
            titleFont = font;
        }
        UIColor *objBackgroundColor = [dictionary objectForKey:MJAlertViewButtonNormalBackgroundColorKey];
        if (objBackgroundColor) {
            backgroundColor = objBackgroundColor;
        }
        UIColor *objHighlightedBackgroundColor = [dictionary objectForKey:MJAlertViewButtonHighlightedBackgroundColorKey];
        if (objHighlightedBackgroundColor) {
            highlightedBackgroundColor = objHighlightedBackgroundColor;
        }
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setBackgroundImage:[self imageWithColor:backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    return button;
}


- (void)addBackgroundControl {
    [self addSubview:self.backgroundControl];
}

- (void)setContainerBackgroundColor:(UIColor *)containerBackgroundColor {
    _containerBackgroundColor = containerBackgroundColor;
    self.containerView.backgroundColor = containerBackgroundColor;
}


#pragma mark -- getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleLabel.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UIControl *)backgroundControl {
    if (!_backgroundControl) {
        _backgroundControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backgroundControl.backgroundColor = [UIColor clearColor];
        [_backgroundControl addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundControl;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
