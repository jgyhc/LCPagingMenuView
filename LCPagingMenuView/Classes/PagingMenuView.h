//
//  PagingMenuView.h
//  PagingControllerDemo
//
//  Created by Zgmanhui on 2017/8/7.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCollectionViewFlowLayout.h"

@class PagingMenuModel, PagingMenuCell, PagingMenuView;

@protocol PagingMenuViewDelegate <NSObject>

@optional


/**
 当前页面 页面切换后调用

 @param pagingMenuView PagingMenuView
 @param currentPage 当前页
 */
- (void)pagingMenuView:(PagingMenuView *)pagingMenuView currentPage:(NSInteger)currentPage;


/**
 开始滚动的时候调用的

 @param pagingMenuView PagingMenuView
 @param nextPage 下一个界面
 */
- (void)pagingMenuView:(PagingMenuView *)pagingMenuView beginScrollNextPage:(NSInteger)nextPage;


/**
 减速完成

 @param pagingMenuView PagingMenuView
 @param currentPage 当前页面
 */
- (void)pagingMenuView:(PagingMenuView *)pagingMenuView endScrollCurrentPage:(NSInteger)currentPage;


@end

@interface PagingMenuView : UIView


- (instancetype)initWithFrame:(CGRect)frame model:(PagingMenuModel *)model;


@property (nonatomic, strong, readonly) PagingMenuModel *model;

/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id <PagingMenuViewDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) PMCollectionViewFlowLayout *layout;


#pragma mark -- 后面添加的方法

- (void)updateTitle:(NSString *)title index:(NSInteger)index;


/** 加了红点显示与否的决定 */
@property (nonatomic, strong) NSArray *counts;

@end


@interface PagingMenuModel : NSObject


#pragma mark -- 必传
/** 标题文本 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

/** 子视图 */
@property (nonatomic, strong) NSArray<UIView *> *views;


#pragma mark -- 有默认值的  非必须设置
/** 滑块颜色 */
@property (nonatomic, strong) UIColor *sliderColor;

/** 滑块高度 默认2*/
@property (nonatomic, assign) CGFloat sliderHeight;

/** 滑块宽度 默认屏幕宽五分之一*/
@property (nonatomic, assign) CGFloat sliderWidth;

/** 标题文字颜色正常 默认黑色*/
@property (nonatomic, strong) UIColor *titleNormalColor;

/** 标题文字颜色选中 默认橙色*/
@property (nonatomic, strong) UIColor *titleSelectColor;

/** 标题文字字体 默认15*/
@property (nonatomic, strong) UIFont *titleFont;

/** 选中时的i字体 默认15*/
@property (nonatomic, strong) UIFont * titleSelectFont;

/** 标题宽度 默认子视图大于5 屏幕宽五分之一 否则平分屏幕宽*/
@property (nonatomic, assign) CGFloat titleWidth;

/** 顶部高度 默认50*/
@property (nonatomic, assign) CGFloat headerHight;

/** 标题是否自适应宽度 默认NO*/
@property (nonatomic, assign) BOOL adaptiveWidth;

/** 滑块自适应 button宽度附加值 默认10*/
@property (nonatomic, assign) CGFloat widthOffButtonWidth;

/** 滑块自适应宽度 默认NO*/
@property (nonatomic, assign) BOOL adaptiveSliderWidth;

/** 滑块自适应宽度的 滑块宽度附加值 默认0*/
@property (nonatomic, assign) CGFloat widthOffWidth;

/** 点击按钮的时候 底部视图是否需要动画 默认不需要 */
@property (nonatomic, assign) BOOL scrollingAnimation;

/** 滑块圆角 默认0 */
@property (nonatomic, assign) NSInteger sliderCorners;

/** 是否屏蔽拖动动画  默认NO */
@property (nonatomic, assign) BOOL shieldingDragAnimation;

/** 是否添加底部的线条 */
@property (nonatomic, assign) BOOL isAddLine;

/** 线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 线条宽度 */
@property (nonatomic, assign) CGFloat lineHeight;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *collectionBackgroundColor;

/** 是否添加小红点 */
@property (nonatomic, assign) BOOL isAddRedDot;

/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;

@end


@interface PagingMenuCell : UICollectionViewCell

@property (nonatomic, strong) UIView *subView;

@end

