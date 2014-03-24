//
//  WPFHorizonCollectionView.m
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import "WPFHorizonCollectionView.h"
#import "WPFHorizonCollectionViewLayout.h"
#import "WPFCollectionReusableView.h"


typedef struct {
    BOOL numberOfSection        : 1;
    BOOL itemNumberInSection    : 1;
    BOOL cellForItem            : 1;
    BOOL headerOfSection        : 1;
}WPFHorizonCollectionViewDatasourceFlag;

typedef struct {
    BOOL widthForItem           : 1;
    BOOL heighRatioForItem      : 1;
    BOOL sizeForHeader          : 1;
}WPFHorizonCollectionViewDelegateFlag;


@interface WPFHorizonCollectionView () {
    WPFHorizonCollectionViewLayout *_layout;
    UICollectionView *_internalCollectionView;
    
    WPFHorizonCollectionViewDatasourceFlag _datasourceFlag;
    WPFHorizonCollectionViewDelegateFlag   _delegateFlag;
}

@end

@interface WPFHorizonCollectionView (UICollectionViewAdditions) <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@interface WPFHorizonCollectionView (WPFHotizonCollectionViewLayout) <WPFHorizonCollectionViewLayoutDatasource>

@end

@implementation WPFHorizonCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _layout = [[WPFHorizonCollectionViewLayout alloc] init];
        _layout.datasource = self;
        _internalCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                     collectionViewLayout:_layout];
        
        _internalCollectionView.dataSource = self;
        _internalCollectionView.delegate = self;
        [_internalCollectionView registerClass:[WPFCollectionReusableView class]
                    forSupplementaryViewOfKind:WPFHorizonCollectionViewSupplementaryKindHeader
                           withReuseIdentifier:WPFHorizonCollectionViewSupplementaryKindHeader];
        _internalCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_internalCollectionView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _internalCollectionView.frame = self.bounds;
    [_layout invalidateLayout];
    [_layout setup];

}

- (void)setDelegate:(id<WPFHorizonCollectionViewDelegate>)delegate {
    if (_delegate == delegate) {
        return;
    }
    
    _delegate = delegate;
    
    _delegateFlag.sizeForHeader = [_delegate respondsToSelector:@selector(horizonCollectionView:sizeForHeaderInSection:)];
    _delegateFlag.widthForItem = [_delegate respondsToSelector:@selector(horizonCollectionView:widthForItemAtIndexPath:)];
    _delegateFlag.heighRatioForItem = [_delegate respondsToSelector:@selector(horizonCollectionView:heightScaleForItemAtIndexPath:)];

    [_layout setup];

}

- (void)setDatasource:(id<WPFHorizonCollectionViewDatasource>)datasource {
    if (_datasource == datasource) {
        return;
    }
    
    _datasource = datasource;
    _datasourceFlag.numberOfSection = [_datasource respondsToSelector:@selector(numberOfSectionInHorizonColletionView:)];
    _datasourceFlag.itemNumberInSection = [_datasource respondsToSelector:@selector(horizonCollectionView:numberOfItemsInSection:)];
    _datasourceFlag.cellForItem = [_datasource respondsToSelector:@selector(horizonCollectionView:cellForItemAtIndexPath:)];
    _datasourceFlag.headerOfSection = [_datasource respondsToSelector:@selector(horizonCollectionView:viewForHeaderInSection:)];

    [_layout setup];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [_internalCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath {
    return [_internalCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData {
    [_internalCollectionView reloadData];
    [_layout invalidateLayout];
    [_layout setup];
}

@end

@implementation WPFHorizonCollectionView (UICollectionViewAdditions)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_datasourceFlag.numberOfSection) {
        return [_datasource numberOfSectionInHorizonColletionView:self];
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_datasourceFlag.itemNumberInSection) {
        return [_datasource horizonCollectionView:self numberOfItemsInSection:section];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_datasourceFlag.cellForItem) {
        return [_datasource horizonCollectionView:self cellForItemAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return nil;
    }
    
    if ([kind isEqualToString:WPFHorizonCollectionViewSupplementaryKindHeader]) {
        if (!_datasourceFlag.headerOfSection) {
            return nil;
        }
        
        UIView *headerView = [_datasource horizonCollectionView:self viewForHeaderInSection:indexPath.section];
        if (headerView == nil) {
            return nil;
        }
        
        WPFCollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                      withReuseIdentifier:WPFHorizonCollectionViewSupplementaryKindHeader forIndexPath:indexPath];
        
        [reuseableView addSubview:headerView];
        return reuseableView;
    }
    
    return nil;
}

@end

@implementation WPFHorizonCollectionView (WPFHotizonCollectionViewLayout)

- (CGFloat)layout:(WPFHorizonCollectionViewLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegateFlag.widthForItem) {
        return [self.delegate horizonCollectionView:self widthForItemAtIndexPath:indexPath];
    }
    
    return 0.0;
}

- (CGFloat)layout:(WPFHorizonCollectionViewLayout *)layout heightScaleForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegateFlag.heighRatioForItem) {
        return [self.delegate horizonCollectionView:self heightScaleForItemAtIndexPath:indexPath];
    }
    
    return 1.0;
}

- (CGSize)layout:(WPFHorizonCollectionViewLayout *)layout sizeForHeaderInSection:(NSInteger)section {
    if (_delegateFlag.sizeForHeader) {
        return [self.delegate horizonCollectionView:self sizeForHeaderInSection:section];
    }
    
    return CGSizeZero;
}

@end


