//
//  MJBadgeButton.h
//  ManJi
//
//  Created by manjiwang on 2018/11/7.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJBadgeButton : UIButton

@property (nonatomic, assign) NSInteger count;

+ (instancetype)button;

/** 角标背景色 */
@property (nonatomic, strong) UIColor *dotColor;

/** 角标文本颜色 */
@property (nonatomic, strong) UIColor * dotTextColor;

- (void)initSubView;
@end

NS_ASSUME_NONNULL_END
