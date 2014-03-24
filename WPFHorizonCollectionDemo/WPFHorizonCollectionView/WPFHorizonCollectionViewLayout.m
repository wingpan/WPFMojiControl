//
//  WPFHorizonCollectionViewLayout.m
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import "WPFHorizonCollectionViewLayout.h"

NSString *WPFHorizonCollectionViewSupplementaryKindHeader = @"kWPFHorizonCollectionViewSupplementaryKindHeader";


typedef struct {
    BOOL widthForItem           : 1;
    BOOL heigthScaleForItem     : 1;
    BOOL sizeForHeader          : 1;
}WPFHorizonCollectionViewLayoutDatasourceFlag;

@interface WPFHorizonCollectionViewLayout () {
    WPFHorizonCollectionViewLayoutDatasourceFlag _datasourceFlag;
}

@property (nonatomic, strong)NSArray      *cellAttributesArray;
@property (nonatomic, strong)NSArray      *sectionHeaderSizeArray;
@property (nonatomic, strong)NSArray      *sectionStartXArray;


@end

@interface WPFHorizonCollectionViewLayout (Private)

- (UICollectionViewLayoutAttributes *)p_attributesAtIndexPath:(NSIndexPath *)indexPath;
- (NSRange)p_sectionRangeInRect:(CGRect)rect;

@end

@implementation WPFHorizonCollectionViewLayout

static const CGFloat kWPFHorizonCellWidth = 60;
- (BOOL)setup {
    NSMutableArray *tmpHeaderSizes = [NSMutableArray array];
    NSMutableArray *tmpCellAttributes = [NSMutableArray array];
    NSMutableArray *tmpSectionStartXArray = [NSMutableArray array];
    
    CGFloat offset = 0.0;
    NSInteger sectionCount = self.collectionView.numberOfSections;
    for (int section = 0; section < sectionCount; section++) {
        [tmpSectionStartXArray addObject:@(offset)];
        
        //初始化header view size
        CGFloat headerHeight = 0.0;
        CGFloat headerWidth = 0.0;
        
        if (_datasourceFlag.sizeForHeader) {
            CGSize size = [self.datasource layout:self sizeForHeaderInSection:section];
            headerHeight = MIN(CGRectGetHeight(self.collectionView.frame), size.height);
            headerWidth = MIN(CGRectGetWidth(self.collectionView.frame), size.width);
        }
        
        [tmpHeaderSizes addObject:[NSValue valueWithCGSize:CGSizeMake(headerWidth, headerHeight)]];
        
        
        //生成cell的attributes
        NSInteger itemCountInSection = [self.collectionView numberOfItemsInSection:section];
        for (int itemIndex = 0; itemIndex < itemCountInSection; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:section];
            
            CGFloat itemWidth = kWPFHorizonCellWidth;
            if (_datasourceFlag.sizeForHeader) {
                itemWidth = [self.datasource layout:self widthForItemAtIndexPath:indexPath];
            }
            
            CGFloat itemHeightScale = 1.0;
            if (_datasourceFlag.heigthScaleForItem) {
                itemHeightScale = MIN(itemHeightScale,
                                      MAX(0.0,
                                          [self.datasource layout:self heightScaleForItemAtIndexPath:indexPath]));
            }
            
            CGFloat itemHeight = (CGRectGetHeight(self.collectionView.frame) - headerHeight)*itemHeightScale;
            
            UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            cellAttributes.size = CGSizeMake(itemWidth, itemHeight);
            cellAttributes.center = CGPointMake(offset + itemWidth/2.0,
                                                CGRectGetHeight(self.collectionView.frame) - itemHeight/2.0);
            
            [tmpCellAttributes addObject:cellAttributes];
            
            //更新offset
            offset += itemWidth;
            
        }
    }
    
    self.cellAttributesArray = tmpCellAttributes;
    self.sectionHeaderSizeArray = tmpHeaderSizes;
    self.sectionStartXArray = tmpSectionStartXArray;
    
    return YES;
}


- (void)setDatasource:(id<WPFHorizonCollectionViewLayoutDatasource>)datasource {
    if (_datasource == datasource) {
        return;
    }
    
    _datasource = datasource;
    
    _datasourceFlag.sizeForHeader = [_datasource respondsToSelector:@selector(layout:sizeForHeaderInSection:)];
    _datasourceFlag.widthForItem = [_datasource respondsToSelector:@selector(layout:widthForItemAtIndexPath:)];
    _datasourceFlag.heigthScaleForItem = [_datasource respondsToSelector:@selector(layout:heightScaleForItemAtIndexPath:)];
}

@end

@implementation WPFHorizonCollectionViewLayout (OverRide)

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSRange sectionRange = [self p_sectionRangeInRect:rect];
    
    if (!sectionRange.length) {
        return nil;
    }
    
    NSMutableArray *attributesForElements = [NSMutableArray array];
    
    for (int section = sectionRange.location; section <= sectionRange.location + sectionRange.length; section++) {
        NSInteger itemCountInSection = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *attributesInSection  = [NSMutableArray array];
        UICollectionViewLayoutAttributes *intersectCellAttributes = nil;
        for (int item = 0; item < itemCountInSection; item++) {
            UICollectionViewLayoutAttributes *attributes = [self p_attributesAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesInSection addObject:attributes];
                
                if (CGRectGetMinX(attributes.frame) <= self.collectionView.contentOffset.x &&
                    CGRectGetMaxX(attributes.frame) >= self.collectionView.contentOffset.x) {
                    intersectCellAttributes = attributes;
                }
            }
        }
        
        if (!attributesInSection.count) {
            continue;
        }
        
        CGSize sectionSize = [[self.sectionHeaderSizeArray objectAtIndex:section] CGSizeValue];
        if (!CGSizeEqualToSize(sectionSize, CGSizeZero)) {
            UICollectionViewLayoutAttributes *firstAttributes = [attributesInSection objectAtIndex:0];
            UICollectionViewLayoutAttributes *lastAttributes = [attributesInSection lastObject];
            if (CGRectGetMaxX(lastAttributes.frame) < self.collectionView.contentOffset.x) {
                continue;
            }

            
            UICollectionViewLayoutAttributes *sectionHeaderAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:WPFHorizonCollectionViewSupplementaryKindHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            sectionHeaderAttributes.size = [[self.sectionHeaderSizeArray objectAtIndex:section] CGSizeValue];

            if (firstAttributes.indexPath.row == 0 && CGRectGetMinX(firstAttributes.frame) >= self.collectionView.contentOffset.x) {
                sectionHeaderAttributes.center = CGPointMake(CGRectGetMinX(firstAttributes.frame)+sectionHeaderAttributes.size.width/2.0,
                                                             firstAttributes.frame.origin.y - sectionHeaderAttributes.size.height/2.0) ;
            }else if (CGRectGetMinX(lastAttributes.frame) <= self.collectionView.contentOffset.x){
                sectionHeaderAttributes.center = CGPointMake(CGRectGetMaxX(lastAttributes.frame) - sectionHeaderAttributes.size.width/2.0,
                                                             lastAttributes.frame.origin.y - sectionHeaderAttributes.size.height/2.0);
            }else {
                sectionHeaderAttributes.center = CGPointMake(self.collectionView.contentOffset.x + sectionHeaderAttributes.size.width/2.0,
                                                             intersectCellAttributes.frame.origin.y - sectionHeaderAttributes.size.height/2.0);
            }
            
            [attributesForElements addObject:sectionHeaderAttributes];
        }
        

        [attributesForElements addObjectsFromArray:attributesInSection];
    }
    
    return attributesForElements;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self p_attributesAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    
    if (![kind isEqualToString:WPFHorizonCollectionViewSupplementaryKindHeader] ||
        indexPath.row > 0) {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    }

    CGSize viewSize = [[self.sectionHeaderSizeArray objectAtIndex:indexPath.section] CGSizeValue];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:WPFHorizonCollectionViewSupplementaryKindHeader withIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self p_attributesAtIndexPath:indexPath];
    attributes.size = viewSize;
    attributes.center = CGPointMake(cellAttributes.center.x,
                                    cellAttributes.frame.origin.y - viewSize.height/2.0);
    return attributes;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    CGFloat totalWidth = 0.0;
    for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
        totalWidth += attributes.size.width;
    }
    
    return CGSizeMake(totalWidth, CGRectGetHeight(self.collectionView.frame));
    
}

@end

@implementation WPFHorizonCollectionViewLayout (Private)

- (UICollectionViewLayoutAttributes *)p_attributesAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat index = 0;
    for (NSInteger section = 0; section < indexPath.section; section++) {
        index += [self.collectionView numberOfItemsInSection:section];
    }
    
    index += indexPath.row;
    
    return [self.cellAttributesArray objectAtIndex:index];
}

- (NSRange)p_sectionRangeInRect:(CGRect)rect {
    if (!self.sectionStartXArray.count) {
        return NSMakeRange(0, 0);
    }
    
    NSInteger firstSection = NSNotFound;
    NSInteger lastSection = NSNotFound;
    
    for (int i = 0; i < self.sectionStartXArray.count-1; i++) {
        CGFloat thisSectionX = [[self.sectionStartXArray objectAtIndex:i] floatValue];
        CGFloat nextSectionX = [[self.sectionStartXArray objectAtIndex:i+1] floatValue];
        
        if (thisSectionX <= CGRectGetMinX(rect) && nextSectionX > CGRectGetMinX(rect)) {
            firstSection = i;
        }else if (thisSectionX < CGRectGetMaxX(rect) && nextSectionX > CGRectGetMaxX(rect)) {
            lastSection = i;
        }
        
        if (firstSection != NSNotFound && lastSection != NSNotFound) {
            break;
        }
    }
    
    if (firstSection == NSNotFound) {
        firstSection = 0;
    }
    
    if (lastSection == NSNotFound) {
        lastSection = self.sectionStartXArray.count - 1;
    }
    
    return NSMakeRange(firstSection, lastSection - firstSection);
}

@end