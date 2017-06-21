//
//  FMAccountSelectViewController.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMViewController.h"

@class FMSelectAccountEnd;
typedef void(^FMAccountSelectViewControllerButtonOnClick)(FMSelectAccountEnd * selectAccount);
typedef void(^FMAccountUNSelectViewControllerButtonOnClick)(FMSelectAccountEnd * unSelect);


@interface FMAccountSelectViewController : FMViewController

@property (nonatomic,copy) FMAccountSelectViewControllerButtonOnClick selectModelBlock;
@property (nonatomic,copy) FMAccountUNSelectViewControllerButtonOnClick unSelectModelBlock;

@property (nonatomic, strong) FMSelectAccountEnd * currentSelectModel;


@end
