//
//  MJShoppingCartButton.m
//  ManJi
//
//  Created by mei Wang on 2017/4/11.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "MJShoppingCartButton.h"
#import "CTMediator.h"


@implementation MJShoppingCartButton

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mjShopingCartGoodsCountUpdateNotice" object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initSubView {
    [super initSubView];
    [self shopingCarUpdateCount:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopingCarUpdateCount:) name:@"mjShopingCartGoodsCountUpdateNotice" object:nil];
}

- (void)shopingCarUpdateCount:(NSNotification *)notification {
    self.count = [[[CTMediator sharedInstance] performTarget:@"goodsshopingcar" action:@"shopingCartCount" params:nil shouldCacheTarget:YES] integerValue];
}


@end
