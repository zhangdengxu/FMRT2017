//
//  WLFirstPageHeaderViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/11/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "FMIndexHeaderModel.h"


@interface WLFirstPageHeaderViewController : FMViewController
@property (nonatomic,copy) NSString *shareURL;
@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic, strong) FMIndexHeaderModel * headerModel;
@property (nonatomic, copy)void(^refreshBackBlock)();
@end
