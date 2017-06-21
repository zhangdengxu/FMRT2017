//
//  WLNewBesureViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 17/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "ProjectModel.h"
@interface WLNewBesureViewController : FMViewController

@property(nonatomic,copy)NSString *projectId;
@property(nonatomic,copy)NSString *fengxiandengji;
@property(nonatomic,copy)NSString *dizenge;
@property(nonatomic,copy)NSString *lilvyou;
@property(nonatomic,strong)ProjectModel *model;

@end
