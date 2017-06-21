//
//  YYScreeningDataView.h
//  fmapp
//
//  Created by yushibo on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYScreeningDataView : UIView
/**  传递模型 */
@property (nonatomic, copy) void(^modelBlock)(NSString *title);
@end
