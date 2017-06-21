//
//  YYPermissionSettingCell.h
//  fmapp
//
//  Created by yushibo on 2017/3/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYPermissionSettingCell : UITableViewCell
@property (nonatomic,strong) NSArray *dataSource;

/**  传递模型 */
@property (nonatomic, copy) void(^modelBlock)(NSString *title);
@end
