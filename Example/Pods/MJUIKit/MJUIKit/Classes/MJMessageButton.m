//
//  MJMessageButton.m
//  ManJi
//
//  Created by manjiwang on 2018/11/7.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import "MJMessageButton.h"
//#import "MJGetUserNotReadCountManager.h"
#import "CTMediator.h"

@implementation MJMessageButton

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserNotReadCountNotificationName" object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initSubView {
    [super initSubView];
    [self userNotReadCountDidChange:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotReadCountDidChange:) name:@"UserNotReadCountNotificationName" object:nil];
}

- (void)userNotReadCountDidChange:(NSNotification *)notification {
    NSUInteger count = [[[CTMediator sharedInstance] performTarget:@"MJMessage" action:@"messageCount" params:nil shouldCacheTarget:YES] integerValue];
    self.count = count;
}


@end
