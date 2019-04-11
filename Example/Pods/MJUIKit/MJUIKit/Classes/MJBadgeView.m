//
//  MJBadgeView.m
//  ManJi
//
//  Created by manjiwang on 2018/6/23.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import "MJBadgeView.h"

@interface MJBadgeView ()

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, assign) CGFloat badgeWidth;

@end

@implementation MJBadgeView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = 7.5;
    self.clipsToBounds = YES;
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:10];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, _badgeWidth, 15);
    self.label.frame = self.bounds;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    if (count > 0) {
        NSString *str_count = count <= 99 ? [NSString stringWithFormat:@"%ld", count] : @"99+";
        self.hidden = NO;
        CGSize size = [str_count sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10],NSFontAttributeName,nil]];
        CGFloat width = MIN(20.0, MAX(15, size.width));
        _badgeWidth = width + 4;
        self.bounds = CGRectMake(0, 0, _badgeWidth, 15);
        self.label.frame = self.bounds;
        _label.text = str_count;
    }else {
        self.hidden = YES;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.label.textColor = textColor;
}



@end
