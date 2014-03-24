//
//  WPFHorizonCollectionViewLayout.h
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *WPFHorizonCollectionViewSupplementaryKindHeader;

@protocol WPFHorizonCollectionViewLayoutDatasource;

@interface WPFHorizonCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WPFHorizonCollectionViewLayoutDatasource> datasource;

- (BOOL)setup;


@end

@protocol WPFHorizonCollectionViewLayoutDatasource  <NSObject>

- (CGFloat)layout:(WPFHorizonCollectionViewLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)layout:(WPFHorizonCollectionViewLayout *)layout heightScaleForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)layout:(WPFHorizonCollectionViewLayout *)layout sizeForHeaderInSection:(NSInteger)section;


@end
