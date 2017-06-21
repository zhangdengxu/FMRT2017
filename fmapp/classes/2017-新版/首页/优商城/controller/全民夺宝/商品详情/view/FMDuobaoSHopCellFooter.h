//
//  FMDuobaoSHopCellFooter.h
//  fmapp
//
//  Created by runzhiqiu on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockButtonOnClickFooter)(NSInteger  section);

@interface FMDuobaoSHopCellFooter : UITableViewHeaderFooterView

@property (nonatomic,copy) blockButtonOnClickFooter buttonBlock;

@property (nonatomic, assign) NSInteger section;

@end
