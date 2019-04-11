//
//  MJAmountLabel.h
//  ManJi
//
//  Created by manjiwang on 2018/10/9.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


static CGFloat amountFontDifference = 2;
static CGFloat amountFontSize = 14;

typedef NS_ENUM(NSInteger, MJAmountLabelShowType) {
    MJAmountLabelShowTypeSimple,//省略小数点后末尾的0 ￥符号和小数点后的字体比整数部分小 默认2  例如：￥1231

    MJAmountLabelShowTypeComplete,//小数点后保留两位小数，不会省略小数部分 ￥符号和小数点后的字体比整数部分小 默认2
};


/**
 金额类型
 */
typedef NS_ENUM(NSInteger, MJAmountLabelAmountType) {
    MJAmountLabelAmountTypeReal,//卖价
    
    MJAmountLabelAmountTypeOriginal//原价
};


@interface MJAmountLabel : UILabel

- (instancetype)initWithShowType:(MJAmountLabelShowType)showType amountType:(MJAmountLabelAmountType)amountType;


/**
 原价还是卖价
 */
@property (nonatomic, assign) MJAmountLabelAmountType amountType;


/**
 是否省略小数点后的末位0
 */
@property (nonatomic, assign) MJAmountLabelShowType showType;
/**
 传入需要显示金额
 */
@property (nonatomic, strong) NSNumber * amount;

/**
 ￥符号和整数部分字体大小的差 默认2
 */
@property (nonatomic, assign) CGFloat symbolFontDifference;

/**
 小数部分和部分字体大小的差 默认2
 */
@property (nonatomic, assign) CGFloat decimalFontDifference;

/** 数字部分字体默认苹果方 13 */
@property (nonatomic, strong) UIFont * decimalFont;

/** 符号部分字体默认苹果方 13 */
@property (nonatomic, strong) UIFont * symbolFont;

@property (nonatomic, assign) CGFloat fontSize;


@end

NS_ASSUME_NONNULL_END
