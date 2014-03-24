//
//  WPFCollectionReusableView.m
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import "WPFCollectionReusableView.h"

@implementation WPFCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        subView.frame = self.bounds;
    }
}

- (void)prepareForReuse {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
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
