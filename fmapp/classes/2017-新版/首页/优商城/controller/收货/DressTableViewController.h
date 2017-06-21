//
//  DressTableViewController.h
//  fmapp
//
//  Created by 秦秦文龙 on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BlockWithDress)(NSString *,NSString *,NSString *,NSString *);

@interface DressTableViewController : UITableViewController

@property (nonatomic, copy) BlockWithDress blockWithDress;

@end
