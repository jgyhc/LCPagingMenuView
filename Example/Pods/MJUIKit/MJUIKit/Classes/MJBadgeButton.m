//
//  MJBadgeButton.m
//  ManJi
//
//  Created by manjiwang on 2018/11/7.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import "MJBadgeButton.h"
#import "MJBadgeView.h"

@interface MJBadgeButton ()

@property (nonatomic, strong) MJBadgeView *badgeView;

@end

@implementation MJBadgeButton


+ (instancetype)button {
    return [self buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.badgeView];
    self.badgeView.hidden = YES;
}

- (void)setNormalImage:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    [self setImage:image forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat super_center_width = self.bounds.size.width;
    CGFloat super_centet_height = self.bounds.size.height;
    self.badgeView.center = CGPointMake(super_center_width / 2 + 8, super_centet_height / 2 - 6);
    //    self.badgeView.bounds = CGRectMake(0, 0, _badgeWidth > 0 ? _badgeWidth : 18, 15);
    self.badgeView.count = _count; 
}

- (void)setCount:(NSInteger)count {
    _count = count;
    self.badgeView.count = count;
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    self.badgeView.backgroundColor = dotColor;
}

- (void)setDotTextColor:(UIColor *)dotTextColor {
    _dotTextColor = dotTextColor;
    self.badgeView.textColor = dotTextColor;
}

- (MJBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[MJBadgeView alloc] init];
        _badgeView.userInteractionEnabled = NO;
    }
    return _badgeView;
}
@end
