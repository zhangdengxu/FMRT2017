//
//  FMSelectShopCollectionViewItem.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSelectShopCollectionViewItem.h"
#import "HexColor.h"
@implementation FMSelectShopCollectionViewItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textColor = [HXColor colorWithHexString:@"#aaaaaa"];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}


@end
