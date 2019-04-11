//
//  MJDropDownMenuView.h
//  ManJi
//
//  Created by manjiwang on 2018/7/28.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBadgeView.h"

@class MJDropDownMenuView, MJDropDownMenuCell, MJDropDownMenuItem;

@protocol MJDropDownMenuViewDelegate <NSObject>

- (NSArray<MJDropDownMenuItem *> *)dataSourceDropDownMenuView:(MJDropDownMenuView *)dropDownMenuView;

@optional
- (void)dropDownMenuView:(MJDropDownMenuView *)dropDownMenuView didSelectItem:(NSInteger)item;

@end



@interface MJDropDownMenuView : UIView

@property (nonatomic, strong, readonly) NSArray * dataSource;

@property (nonatomic, weak) id <MJDropDownMenuViewDelegate> delegate;

- (void)show;

- (void)reloadData;

@end

@interface MJDropDownMenuItem : NSObject


@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * imageName;

@property (nonatomic, assign) NSInteger count;

@end

@interface MJDropDownMenuCell : UITableViewCell

@property (nonatomic, strong) MJDropDownMenuItem * item;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * iconImageView;

@property (nonatomic, strong) MJBadgeView * badgeView;

@end
