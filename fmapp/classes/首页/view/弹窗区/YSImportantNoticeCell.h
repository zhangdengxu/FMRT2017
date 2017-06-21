//
//  YSImportantNoticeCell.h
//  fmapp
//
//  Created by yushibo on 16/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSImportantNoticeCell : UITableViewCell

@property (nonatomic, strong) NSArray *status;

+(CGFloat)hightForCellWithModel:(NSString *)status;

@end
