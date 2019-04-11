//
//  MJMoreButton.m
//  ManJi
//
//  Created by manjiwang on 2018/11/7.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import "MJMoreButton.h"
#import "CTMediator.h"

@implementation MJMoreButton

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserNotReadCountNotificationName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mjShopingCartGoodsCountUpdateNotice" object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initSubView {
    [super initSubView];
    [self userMoreCountDidChange:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userMoreCountDidChange:) name:@"UserNotReadCountNotificationName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userMoreCountDidChange:) name:@"mjShopingCartGoodsCountUpdateNotice" object:nil];
}

- (void)userMoreCountDidChange:(NSNotification *)notification {
    NSUInteger messageCount = [[[CTMediator sharedInstance] performTarget:@"MJMessage" action:@"messageCount" params:nil shouldCacheTarget:YES] integerValue];
    NSInteger shopingCartCount = [[[CTMediator sharedInstance] performTarget:@"goodsshopingcar" action:@"shopingCartCount" params:nil shouldCacheTarget:YES] integerValue];
    self.count = messageCount + shopingCartCount;
}




@end
