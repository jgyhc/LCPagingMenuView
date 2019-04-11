//
//  PMCollectionViewFlowLayout.m
//  ManJi
//
//  Created by manjiwang on 2018/5/8.
//  Copyright © 2018年 Zgmanhui. All rights reserved.
//

#import "PMCollectionViewFlowLayout.h"

@implementation PMCollectionViewFlowLayout



- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.collectionView.contentOffset = self.offsetpoint;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    return NO;
}


@end
