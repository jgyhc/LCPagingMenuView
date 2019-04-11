//
//  Target_MJUIKitRouter.h
//  CTMediator
//
//  Created by manjiwang on 2019/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MJUIKitRouterCallbackInfoBlock)(NSDictionary *info);

@interface Target_MJUIKitRouter : NSObject

- (id)Action_showAlertView:(NSDictionary *)params;

- (id)Action_moreButton:(NSDictionary *)params;

- (id)Action_shoppingCartButton:(NSDictionary *)params;

- (id)Action_messageButton:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
