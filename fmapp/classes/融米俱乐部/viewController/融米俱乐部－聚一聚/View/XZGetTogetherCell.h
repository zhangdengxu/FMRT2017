//
//  XZGetTogetherCell.h
//  XZLearning
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZGetTogetherModel;
@interface XZGetTogetherCell : UITableViewCell

@property (nonatomic, copy) void(^blockBtnPublish)(UIButton *);

@property (nonatomic, strong) XZGetTogetherModel *modelTother;
@end
