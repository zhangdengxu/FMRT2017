//
//  MoreProjectController.h
//  fmapp
//
//  Created by apple on 15/3/15.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "ProjectModel.h"
//#import "ProjectDetailController.h"
#import "WLNewProjectDetailViewController.h"
#import "UIButton+Bootstrap.h" //修改右侧button

@interface MoreProjectController : FMViewController

- (id)initWithProjectModel:(ProjectModel *)model;

@property(nonatomic,assign)int  projectStyle;
@property(nonatomic,copy)NSString *projectId;
@property(nonatomic,copy)NSString *fengxiandengji;
@property(nonatomic,copy)NSString *dizenge;

@end
