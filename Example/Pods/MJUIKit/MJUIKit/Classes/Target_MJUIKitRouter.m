//
//  Target_MJUIKitRouter.m
//  CTMediator
//
//  Created by manjiwang on 2019/1/29.
//

#import "Target_MJUIKitRouter.h"
#import "MJAlertView.h"
#import "MJMoreButton.h"
#import "MJShoppingCartButton.h"
#import "MJMessageButton.h"

@implementation Target_MJUIKitRouter

- (id)Action_showAlertView:(NSDictionary *)params {
    MJAlertView *alertView = [[MJAlertView alloc] init];
    alertView.title = [params objectForKey:@"title"];
    alertView.content = [params objectForKey:@"content"];
    alertView.buttons = [params objectForKey:@"buttons"];
    [alertView setTapBlock:^(MJAlertView * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        MJUIKitRouterCallbackInfoBlock block = [params objectForKey:@"completion"];
        if (block) {
            block(@{@"title": title, @"buttonIndex": @(buttonIndex)});
        }
    }];
    [alertView show];
    return alertView;
}

- (id)Action_moreButton:(NSDictionary *)params {
    MJMoreButton *button = [MJMoreButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[self imageNamed:@"mjuikit_nav_more_icon" ofType:@"png"] forState:UIControlStateNormal];
    return button;
}

- (id)Action_shoppingCartButton:(NSDictionary *)params {
    MJShoppingCartButton *button = [MJShoppingCartButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[self imageNamed:@"mjuikit_nav_shopingcart_icon" ofType:@"png"] forState:UIControlStateNormal];
    return button;
}

- (id)Action_messageButton:(NSDictionary *)params {
    MJMessageButton *button = [MJMessageButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[self imageNamed:@"mjuikit_nav_msg_icon" ofType:@"png"] forState:UIControlStateNormal];
    return button;
}


- (UIImage *)imageNamed:(NSString *)imageName ofType:(NSString *)type {
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/%@",mainBundlePath,@"MJUIKit.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (bundle == nil) {
        bundlePath = [NSString stringWithFormat:@"%@/%@",mainBundlePath,@"Frameworks/MJUIKit.framework/MJUIKit.bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:type]];
    }
}



@end
