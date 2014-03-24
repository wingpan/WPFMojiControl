//
//  WPFHorizonCollectionView.h
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPFHorizonCollectionViewDatasource ;
@protocol WPFHorizonCollectionViewDelegate;

@interface WPFHorizonCollectionView : UIView

@property (nonatomic, weak)id<WPFHorizonCollectionViewDatasource> datasource;
@property (nonatomic, weak)id<WPFHorizonCollectionViewDelegate>   delegate;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;

- (void)reloadData;

@end


@protocol  WPFHorizonCollectionViewDatasource<NSObject>

@required
- (NSInteger)horizonCollectionView:(WPFHorizonCollectionView *)horizonView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)horizonCollectionView:(WPFHorizonCollectionView *)horizonView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


@optional
- (NSInteger)numberOfSectionInHorizonColletionView:(WPFHorizonCollectionView *)horizonView;
- (UIView *)horizonCollectionView:(WPFHorizonCollectionView *)horizonView viewForHeaderInSection:(NSInteger)section;

@end

@protocol WPFHorizonCollectionViewDelegate <NSObject>

@optional
- (CGFloat)horizonCollectionView:(WPFHorizonCollectionView *)horizonView widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)horizonCollectionView:(WPFHorizonCollectionView *)horizonView heightScaleForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)horizonCollectionView:(WPFHorizonCollectionView *)horizonView sizeForHeaderInSection:(NSInteger)section;


@end
