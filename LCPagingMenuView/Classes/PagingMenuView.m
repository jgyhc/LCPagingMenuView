//
//  PagingMenuView.m
//  PagingControllerDemo
//
//  Created by Zgmanhui on 2017/8/7.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "PagingMenuView.h"
#import "MJBadgeView.h"
#import "Masonry.h"

#define PM_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PM_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PagingMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) PagingMenuModel *model;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) UILabel *selectLabel;

/** collectionView子视图的宽 */
@property (nonatomic, assign) CGFloat content_width;

@property (nonatomic, strong) NSMutableArray *redViews;

@end

@implementation PagingMenuView

- (instancetype)initWithFrame:(CGRect)frame model:(PagingMenuModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        _currentPage = _model.currentPage;
        if (_model.views.count == _model.titles.count) {
            [self initCollectionView];
        }
        [self initScrollView];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)initScrollView {
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    __weak typeof(self) wself = self;
    
    __block CGFloat titleWidth = _model.titleWidth;
    __block CGFloat lastView_right_x = 0;
    [self.buttons removeAllObjects];
    if (wself.model.isAddRedDot) {
        [self.redViews removeAllObjects];
    }
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_model.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wself.model.adaptiveWidth) {
            titleWidth = [wself getViewWidthForTextContentWithTitle:obj] + wself.model.widthOffButtonWidth;
        }
//        UIButton *titlesButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [titlesButton setTitle:obj forState:UIControlStateNormal];
//        [titlesButton setTitleColor:wself.model.titleNormalColor forState:UIControlStateNormal];
//        [titlesButton setTitleColor:wself.model.titleSelectColor forState:UIControlStateSelected];
//        titlesButton.titleLabel.font = wself.model.titleFont;
//        titlesButton.frame = CGRectMake(lastView_right_x, 0, titleWidth, wself.model.headerHight);
//        lastView_right_x = lastView_right_x + titleWidth;
//        titlesButton.tag = 1000 + idx;
//        [wself.buttons addObject:titlesButton];
//        [wself.scrollView addSubview:titlesButton];
//        [titlesButton addTarget:wself action:@selector(handleTitleEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = UILabel.new;
        NSMutableParagraphStyle *style = NSMutableParagraphStyle.new;
        style.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *mAttri = [[NSMutableAttributedString alloc]initWithString:obj attributes:@{NSFontAttributeName : wself.model.titleFont,NSParagraphStyleAttributeName : style}];
        label.frame = CGRectMake(lastView_right_x, 0, titleWidth, wself.model.headerHight);
        lastView_right_x = lastView_right_x + titleWidth;
        label.tag = 1000 + idx;
        [wself.buttons addObject:label];
        [wself.scrollView addSubview:label];
        if (idx == wself.currentPage) {
                wself.selectLabel = label;
//            wself.selectButton.selected = YES;
            [mAttri addAttribute:NSForegroundColorAttributeName value:wself.model.titleSelectColor range:NSMakeRange(0, mAttri.length)];
        }else{
            [mAttri addAttribute:NSForegroundColorAttributeName value:wself.model.titleNormalColor range:NSMakeRange(0, mAttri.length)];
        }
        label.attributedText = mAttri;
        if (wself.model.isAddRedDot) {
            [wself addReddotWithButton:label contentAttri:mAttri];
        }
    }];
    
    
    self.sliderView.layer.cornerRadius = _model.sliderCorners;
    self.sliderView.center = CGPointMake(titleWidth / 2 + titleWidth * _currentPage, _model.headerHight - _model.sliderHeight / 2);
    
    CGFloat sliderWidth = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        sliderWidth = _selectLabel.bounds.size.width + _model.widthOffWidth - _model.widthOffButtonWidth;
    }
    
    _sliderView.bounds = CGRectMake(0, 0, sliderWidth, _model.sliderHeight);
    _sliderView.backgroundColor = _model.sliderColor;
    [_scrollView addSubview:_sliderView];
    _scrollView.contentSize = CGSizeMake(lastView_right_x, _model.headerHight);
    
    if (_model.isAddLine) {
        UIView *line = [UIView new];
        line.frame = CGRectMake(0, _model.headerHight - _model.lineHeight, PM_SCREEN_WIDTH, _model.lineHeight);
        [line setBackgroundColor:_model.lineColor];
        [self addSubview:line];
    }
}

- (void)setCounts:(NSArray *)counts {
    _counts = counts;
    if (counts.count != _redViews.count) {
        return;
    }
    __weak typeof(self) wself = self;
    [counts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull count, NSUInteger idx, BOOL * _Nonnull stop) {
        MJBadgeView *redView = wself.redViews[idx];
        redView.count = [count integerValue];
    }];
}

- (void)addReddotWithButton:(UILabel *)label contentAttri:(NSAttributedString *)contentAttri {
    MJBadgeView *badgeView = [[MJBadgeView alloc] init];
    [label addSubview:badgeView];
    CGSize size = [contentAttri boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGFloat offsetX = size.width > label.frame.size.width ? label.frame.size.width*0.5 : (label.frame.size.width - size.width)*0.5;
    CGFloat offsetY = size.height > label.frame.size.height ? label.frame.size.height*0.5 : (label.frame.size.height - size.height)*0.5;
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(button.titleLabel.mas_top).mas_offset(-7.5);
//        make.right.mas_equalTo(button.titleLabel.mas_right).mas_offset(2);
//        make.center.equalTo(label).sizeOffset(CGSizeMake(size.width*0.5, size.height*0.5));
        make.left.equalTo(label.mas_right).offset(-offsetX);
        make.bottom.equalTo(label.mas_top).offset(offsetY + 5);
        make.height.mas_equalTo(15);
    }];
    [self.redViews addObject:badgeView];
}

- (void)initCollectionView {
    _layout = [[PMCollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - _model.headerHight);
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.minimumLineSpacing = 0;
    _content_width = self.frame.size.width;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _model.headerHight, self.frame.size.width, self.frame.size.height - _model.headerHight) collectionViewLayout:_layout];
    [_collectionView setBackgroundColor:_model.collectionBackgroundColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[PagingMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([PagingMenuCell class])];
    [_collectionView setContentSize:CGSizeMake(self.frame.size.width * _model.views.count, self.frame.size.height - _model.headerHight)];
    _layout.offsetpoint = CGPointMake(self.frame.size.width * _currentPage, 0.f);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.views.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PagingMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PagingMenuCell class]) forIndexPath:indexPath];
    cell.subView = _model.views[indexPath.row];
    return cell;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_model.shieldingDragAnimation) {
        return;
    }
    CGFloat off_x = scrollView.contentOffset.x;
    CGFloat current_off_x = off_x - (_currentPage * (scrollView.contentSize.width / _model.views.count));
    
    CGFloat current_wdith = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        current_wdith = _selectLabel.bounds.size.width + _model.widthOffWidth - _model.widthOffButtonWidth;
    }
    
    CGFloat current_x = _selectLabel.center.x - current_wdith / 2;

    UIButton *nextButton = nil;
    if (current_off_x > 0) {//往下一页滑动
        if (_currentPage == _model.views.count - 1) {
            return;//最后一页的话 返回
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(pagingMenuView:beginScrollNextPage:)]) {
            [self.delegate pagingMenuView:self beginScrollNextPage:_currentPage + 1];
        }
        nextButton = [_scrollView viewWithTag:1000 + _currentPage + 1];//得到下一页的按钮对象
    }else {
        if (_currentPage == 0) {
            return;//第一页的话 返回
        }
        if (self.delegate &&[self.delegate respondsToSelector:@selector(pagingMenuView:beginScrollNextPage:)]) {
            [self.delegate pagingMenuView:self beginScrollNextPage:_currentPage - 1];
        }
        nextButton = [_scrollView viewWithTag:1000 + _currentPage - 1];//得到下一页的按钮对象
    }
    CGFloat next_wdith = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        next_wdith = nextButton.bounds.size.width + _model.widthOffWidth - _model.widthOffButtonWidth;
    }
    CGFloat distance = 0;
    
    CGFloat all_width =  distance + next_wdith;
    
    CGFloat off_percentage = current_off_x / _content_width;
    if (current_off_x > 0) {
        distance = nextButton.center.x - _selectLabel.center.x - current_wdith / 2 - next_wdith / 2;
        CGFloat next_right_x = nextButton.center.x + next_wdith / 2;

        if (off_percentage < 0.5) {
            all_width = distance + next_wdith;
            CGFloat slider_width = current_wdith + off_percentage * all_width * 2;
            _sliderView.frame = CGRectMake(current_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }else {
            all_width = distance + current_wdith;
            CGFloat slider_width = next_wdith + (1 - off_percentage) * all_width * 2;
            CGFloat current_left_x = next_right_x - slider_width;
            _sliderView.frame = CGRectMake(current_left_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }
    }else {
        distance = _selectLabel.center.x - nextButton.center.x - current_wdith / 2 - next_wdith / 2;
        CGFloat current_right_x = _selectLabel.center.x + current_wdith / 2;
        if (off_percentage > -0.5) {
            all_width = distance + next_wdith;
            CGFloat slider_width = current_wdith + (-off_percentage) * all_width * 2;
            CGFloat current_left_x = current_right_x - slider_width;
            _sliderView.frame = CGRectMake(current_left_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }else {
            CGFloat next_left_x = nextButton.center.x - next_wdith / 2 ;
            all_width = current_wdith + distance;
            CGFloat slider_width = next_wdith + (1 + off_percentage) * all_width * 2;
            _sliderView.frame = CGRectMake(next_left_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }
        
    }

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / _model.views.count);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pagingMenuView:endScrollCurrentPage:)]) {
        [self.delegate pagingMenuView:self endScrollCurrentPage:self.currentPage];
    }
}


- (CGFloat)getViewWidthForTextContentWithTitle:(NSString *)title {
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:_model.titleFont}];
    return size.width;
}

//- (void)handleTitleEvent:(UIButton *)sender {
//    if (_selectButton == sender) {
//        return;
//    }
//    self.currentPage = sender.tag - 1000;
//}

- (void)setCurrentPage:(NSInteger)currentPage isAnimated:(BOOL)isAnimated {
    _currentPage = currentPage;
    UILabel *currentLabel = [_scrollView viewWithTag:1000 + currentPage];
    //
    NSMutableAttributedString *selectedAttri = [[NSMutableAttributedString alloc]initWithAttributedString:_selectLabel.attributedText];
    [selectedAttri addAttributes:@{NSForegroundColorAttributeName : self.model.titleNormalColor} range:NSMakeRange(0, selectedAttri.length)];
    _selectLabel.attributedText = selectedAttri;
    //
    NSMutableAttributedString *currentAttri = [[NSMutableAttributedString alloc]initWithAttributedString:currentLabel.attributedText];
    [currentAttri addAttributes:@{NSForegroundColorAttributeName : self.model.titleSelectColor} range:NSMakeRange(0, currentAttri.length)];
    currentLabel.attributedText = currentAttri;
    
//    _selectButton.selected = NO;
//    if (_model.titleSelectFont) {
//        _selectButton.titleLabel.font = _model.titleFont;
//    }
//    currentButton.selected = YES;
//    if (_model.titleSelectFont) {
//        currentButton.titleLabel.font = _model.titleSelectFont;
//    }
    
    _selectLabel = currentLabel;
    
    CGPoint center = _sliderView.center;
    CGFloat sliderWidth = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        sliderWidth = _selectLabel.bounds.size.width - _model.widthOffButtonWidth  + _model.widthOffWidth;
    }
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        wself.sliderView.bounds = CGRectMake(0, 0, sliderWidth, wself.model.sliderHeight);
        wself.sliderView.center = CGPointMake(currentLabel.center.x, center.y);
    }];
    
    CGFloat critical_point_x = PM_SCREEN_WIDTH / 2;
    CGFloat critical_point_x_last = _scrollView.contentSize.width - critical_point_x;
    CGFloat button_center_x = currentLabel.center.x;
    if (button_center_x >= critical_point_x && button_center_x <= critical_point_x_last) {
        [_scrollView setContentOffset:CGPointMake(currentLabel.center.x - critical_point_x, 0) animated:isAnimated];
    }
    if (button_center_x < critical_point_x) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:isAnimated];
    }
    if (button_center_x > critical_point_x_last) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.bounds.size.width, 0) animated:isAnimated];
    }
    [_collectionView setContentOffset:CGPointMake(self.frame.size.width * _currentPage, 0) animated:_model.scrollingAnimation];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pagingMenuView:currentPage:)]) {
        [self.delegate pagingMenuView:self currentPage:_currentPage];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [self setCurrentPage:currentPage isAnimated:YES];
}



- (void)updateTitle:(NSString *)title index:(NSInteger)index {
    if (_buttons.count <= index) {
        return;
    }
    UIButton *button = _buttons[index];
    [button setTitle:title forState:UIControlStateNormal];
}

#pragma mark -- getter method

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PM_SCREEN_WIDTH, _model.headerHight)];

        UITapGestureRecognizer *gensture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapAction:)];
        gensture.delegate = self;
        [_scrollView addGestureRecognizer:gensture];
    }
    return _scrollView;
}

- (void)scrollViewTapAction:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.scrollView];
    for (UILabel *label in self.buttons) {
        CALayer *layer = label.layer.presentationLayer;
        if (CGRectContainsPoint(layer.frame, point)) {
            if (_selectLabel == label) {
                return;
            }
            self.currentPage = label.tag - 1000;
            break;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
    }
    return _sliderView;
}

- (NSMutableArray *)redViews {
    if (!_redViews) {
        _redViews = [[NSMutableArray alloc] init];
    }
    return _redViews;
}

@end

@implementation PagingMenuModel

- (CGFloat)sliderWidth {
    if (!_sliderWidth) {
        _sliderWidth = PM_SCREEN_WIDTH / 5;
    }
    return _sliderWidth;
}

- (CGFloat)sliderHeight {
    if (!_sliderHeight) {
        _sliderHeight = 2;
    }
    return _sliderHeight;
}

- (UIColor *)titleNormalColor {
    if (!_titleNormalColor) {
        _titleNormalColor = [UIColor blackColor];
    }
    return _titleNormalColor;
}

- (UIColor *)titleSelectColor {
    if (!_titleSelectColor) {
        _titleSelectColor = [UIColor colorWithRed:1.00 green:0.40 blue:0.00 alpha:1.00];
    }
    return _titleSelectColor;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:15];
    }
    return _titleFont;
}

- (CGFloat)titleWidth {
    if (!_titleWidth) {
        _titleWidth = _titles.count > 5 ? PM_SCREEN_WIDTH / 5 : PM_SCREEN_WIDTH / _titles.count;
    }
    return _titleWidth;
}

- (CGFloat)headerHight {
    if (!_headerHight) {
        _headerHight = 50;
    }
    return _headerHight;
}

- (UIColor *)sliderColor {
    if (!_sliderColor) {
        _sliderColor = [UIColor colorWithRed:1.00 green:0.40 blue:0.00 alpha:1.00];
    }
    return _sliderColor;
}

- (CGFloat)widthOffButtonWidth {
    if (!_widthOffButtonWidth) {
        _widthOffButtonWidth = 10;
    }
    return _widthOffButtonWidth;
}

- (BOOL)getDragAnimation {
    return YES;
}

@end

@implementation PagingMenuCell

- (void)setSubView:(UIView *)subView {
    if (![_subView isEqual:subView]) {
        [_subView removeFromSuperview];
        _subView = subView;
        [self addSubview:_subView];
        _subView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    }
}

@end


