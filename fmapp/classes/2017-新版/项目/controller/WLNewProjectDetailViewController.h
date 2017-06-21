//
//  WLNewProjectDetailViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

typedef enum  {
    ProjectStartOperationStyle = 1,
    ProjectInprogressOperationStyle = 2,
    ProjectFinishOperationStyle = 3,
}ProjectOperationStyle;


@interface WLNewProjectDetailViewController : FMViewController

/**
 *  NO,代表底部button显示，YES表示底部button不显示
 */
@property(nonatomic,assign)BOOL isBottomViewShow;
@property(nonatomic,copy)NSString *rongzifangshi;

- (id)initWithUserOperationStyle:(int)m_OperationStyle WithProjectId:(NSString *)projectId;

/** 
 *  注资专标跳进去的不创建分享按钮
 */
@property(nonatomic,assign)BOOL NoCreateRightBtn;

@end
