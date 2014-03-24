//
//  WPFTemperatureCell.m
//  WPFHorizonCollectionDemo
//
//  Created by PanFengfeng  on 14-3-20.
//  Copyright (c) 2014年 WingPan. All rights reserved.
//

#import "WPFTemperatureCell.h"

@implementation WPFTemperatureCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:(rand()%255)/255.0
                                               green:(rand()%255)/255.0
                                                blue:(rand()%255)/255.0
                                               alpha:1.0];
    }
    return self;
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
