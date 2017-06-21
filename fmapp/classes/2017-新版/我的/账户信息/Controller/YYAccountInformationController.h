//
//  YYAccountInformationController.h
//  fmapp
//
//  Created by yushibo on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"

@interface YYAccountInformationController : FMViewController
/**  是否完成 */
@property (nonatomic, strong) NSString *IsDone;
@end

@interface FMAccountInfoModel : NSObject

@property (nonatomic,copy) NSString *avlBal;
@property (nonatomic,copy) NSString *outOfTime;

@end

