//
//  MJAmountLabel.m
//  ManJi
//
//  Created by manjiwang on 2018/10/9.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import "MJAmountLabel.h"

#define MJUIKit_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MJAmountLabel ()

@end

@implementation MJAmountLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeAmountLanel];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeAmountLanel];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeAmountLanel];
    }
    return self;
}

- (instancetype)initWithShowType:(MJAmountLabelShowType)showType amountType:(MJAmountLabelAmountType)amountType; {
    self = [super init];
    if (self) {
        self.amountType = amountType;
        self.showType = showType;
        [self initializeAmountLanel];
    }
    return self;
}


- (void)initializeAmountLanel {
    self.decimalFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:amountFontSize];
    self.symbolFont =  [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:amountFontSize - amountFontDifference];
    self.textColor = MJUIKit_UICOLOR_HEX(0xe60012);
    self.symbolFontDifference = amountFontDifference;
    self.decimalFontDifference = 0;
}


- (void)setAmount:(NSNumber *)amount {
    if (_amount == amount) {
        return;
    }
    _amount = amount;
    if (self.amountType == MJAmountLabelAmountTypeOriginal) {
        NSMutableAttributedString *startString = [self getAttributedStartString];
        [startString appendAttributedString:[self getDigitalAttributedString]];
        NSUInteger length = startString.length;
        [startString addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(1, length - 1)];
        [startString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(1, length - 1)];
        self.attributedText = startString;
    }else {
        self.attributedText = [self getCompleteAttributedString];
    }
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.decimalFont = [UIFont fontWithName:self.decimalFont.fontName size:fontSize];
    self.symbolFont = [UIFont fontWithName:self.symbolFont.fontName size:self.decimalFont.pointSize - amountFontDifference];
}

- (NSAttributedString *)getCompleteAttributedString {
    NSMutableAttributedString *startString = [self getAttributedStartString];
    [startString appendAttributedString:[self getDigitalAttributedString]];
    return startString;
}

- (NSMutableAttributedString *)getAttributedStartString {
    NSMutableAttributedString *startString = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    UIFont *startFont = self.symbolFont;
    [startString addAttributes:@{NSFontAttributeName:startFont, NSForegroundColorAttributeName:self.textColor} range:NSMakeRange(0, 1)];
    return startString;
}


- (NSAttributedString *)getDigitalAttributedString {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.maximumFractionDigits = 2;// 小数位最多位数
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSString *string = [numberFormatter stringFromNumber:_amount];
    NSArray *strings = [string componentsSeparatedByString:@"."];
    if (strings.count == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"0"];
    }
    
    NSString *middleString = [strings firstObject];
    if (middleString.length == 0) {
        middleString = @"0";
    }
    NSMutableAttributedString *middleAttributedString = [[NSMutableAttributedString alloc] initWithString:middleString];
    NSUInteger middleLength = [middleString length];
    UIFont *middleFont = self.decimalFont;
    [middleAttributedString addAttributes:@{NSFontAttributeName:middleFont, NSForegroundColorAttributeName:self.textColor} range:NSMakeRange(0, middleLength)];
    
    NSString *endString;
    if (strings.count > 1) {
        endString = [NSString stringWithFormat:@".%@", [strings lastObject]];
    }
    if (_showType == MJAmountLabelShowTypeComplete) {
        if (!endString || endString.length == 0) {
            endString = @".00";
        }
        if (endString.length == 1) {
            endString = [NSString stringWithFormat:@".%@0", [strings lastObject]];
        }
    }
    if (endString) {
        UIFont *endFont = [UIFont fontWithName:self.decimalFont.fontName size:self.decimalFont.pointSize - self.decimalFontDifference];
        NSAttributedString *endAttributedString = [[NSAttributedString alloc] initWithString:endString attributes:@{NSFontAttributeName:endFont, NSForegroundColorAttributeName:self.textColor}];
        [middleAttributedString appendAttributedString:endAttributedString];
    }
    return middleAttributedString;
}


@end
