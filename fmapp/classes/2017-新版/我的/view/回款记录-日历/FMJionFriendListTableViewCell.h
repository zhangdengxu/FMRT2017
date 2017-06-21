//
//  FMJionFriendListTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/23.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMJoinFriendModel;

@interface FMJionFriendListTableViewCell : UITableViewCell

@property (nonatomic, strong) FMJoinFriendModel * joinModel;

@end



@interface FMJoinFriendModel : NSObject

@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *timeString;

@end


