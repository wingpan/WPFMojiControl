//
//  DemoController.m
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import "DemoController.h"
#import "WPFHorizonCollectionView.h"
#import "WPFTemperatureCell.h"

@interface DemoController (WPFHorizonCollectionView) <WPFHorizonCollectionViewDatasource, WPFHorizonCollectionViewDelegate>

@end

@implementation DemoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WPFHorizonCollectionView *tv = [[WPFHorizonCollectionView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
    tv.backgroundColor = [UIColor yellowColor];
    tv.datasource = self;
    tv.delegate = self;
    [self.view addSubview:tv];
    
    [tv registerClass:[WPFTemperatureCell class]
forCellWithReuseIdentifier:NSStringFromClass([WPFTemperatureCell class])];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation DemoController (WPFHorizonCollectionView)

- (NSInteger)numberOfSectionInHorizonColletionView:(WPFHorizonCollectionView *)horizonView {
    return 5;
}

- (NSInteger)horizonCollectionView:(WPFHorizonCollectionView *)horizonView numberOfItemsInSection:(NSInteger)section {
    return section + 10;
}

- (UICollectionViewCell *)horizonCollectionView:(WPFHorizonCollectionView *)horizonView
                         cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [horizonView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WPFTemperatureCell class])
                                                  forIndexPath:indexPath];
}

- (CGFloat)horizonCollectionView:(WPFHorizonCollectionView *)horizonView heightScaleForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (random()%255)/255.0;
}

- (CGFloat)horizonCollectionView:(WPFHorizonCollectionView *)horizonView widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGSize)horizonCollectionView:(WPFHorizonCollectionView *)horizonView sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(40, 20);
}

- (UIView *)horizonCollectionView:(WPFHorizonCollectionView *)horizonView viewForHeaderInSection:(NSInteger)section {
    UIView *tv = [[UIView alloc] initWithFrame:CGRectZero];
    tv.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.0
                                           green:(rand()%255)/255.0
                                            blue:(rand()%255)/255.0
                                           alpha:1.0];
    return tv;
}


@end
