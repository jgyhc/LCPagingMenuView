//
//  MJAlertView.h
//  ManJi
//
//  Created by manjiwang on 2019/1/15.
//  Copyright © 2019 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class MJAlertView;
extern  NSString * const MJAlertViewButtonTitleKey;
extern  NSString * const MJAlertViewButtonTextColorKey;
extern  NSString * const MJAlertViewButtonFontKey;
extern  NSString * const MJAlertViewButtonNormalBackgroundColorKey;
extern  NSString * const MJAlertViewButtonHighlightedBackgroundColorKey;

typedef void (^MJAlertViewCompletionBlock) (MJAlertView * __nonnull controller, NSString * __nonnull title, NSInteger buttonIndex);

@interface MJAlertView : UIView

- (void)initSubViews;

+ (instancetype)initWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertViewCompletionBlock)tapBlock;

- (instancetype)initWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttons:(nullable NSArray *)buttons tapBlock:(nullable MJAlertViewCompletionBlock)tapBlock;

- (void)show;

- (void)hide;

@property (nonatomic, strong) UIView * containerView;

@property (nonatomic, strong) UIColor * containerBackgroundColor;

/** 传入@[@"str",@"str"]  或者@[@"str", @{@"title":@"str",
 @"textColor":UIColor,
 @"font":UIFont]
 }, UIButton] */
@property (nonatomic, strong) NSArray * buttons;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) MJAlertViewCompletionBlock tapBlock;


/** 是否添加点击背景取消的功能 */
- (BOOL)isCanBackBackgroundView;


@property (nonatomic, strong, readonly) NSArray * buttonViews;

//可放置内容的区间
@property (nonatomic, assign) CGFloat contentBottomSpace;

@property (nonatomic, assign) CGFloat contentTopSpace;
@end

NS_ASSUME_NONNULL_END
