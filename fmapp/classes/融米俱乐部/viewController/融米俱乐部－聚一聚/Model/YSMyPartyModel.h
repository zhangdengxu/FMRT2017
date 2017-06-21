//
//  YSMyPartyModel.h
//  fmapp
//
//  Created by yushibo on 16/7/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMyPartyModel : NSObject
/** 时间  */
@property (nonatomic, strong)NSString *party_timeslot;
/** 标题  */
@property (nonatomic, strong)NSString *party_theme;
/** 报名人数  */
@property (nonatomic, strong)NSString *party_adder;
/** 标签数组 */
@property (nonatomic, strong)NSMutableArray *party_labelArray;
/** pid  */
@property (nonatomic, copy)NSString *pid;
/** 结束  */
@property (nonatomic, strong)NSString *jieshu;
/** 能否修改状态值  */
@property (nonatomic, copy)NSString *states;



/**
sharecontent = Sdfa25;
sharepic = "https://www.rongtuojinrong.com";
sharetitle = Sdfa25;
shareurl = "https://www.rongtuojinrong.com/rongtuoxinsoc/juyijuparty/partyfindparty/id/41";
*/
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
