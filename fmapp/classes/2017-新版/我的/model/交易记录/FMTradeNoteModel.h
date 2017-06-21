//
//  FMTradeNoteModel.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTradeNoteModel : NSObject
@property (nonatomic,copy) NSString *change;
@property (nonatomic,copy) NSString *memo;
@property (nonatomic,copy) NSString *transAmount;
@property (nonatomic,copy) NSString *transDesc;
@property (nonatomic,copy) NSString *transTime;




@property (nonatomic,copy) NSString *jilu_id;
@property (nonatomic,copy) NSString *fenshu;
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *beizhu;
@property (nonatomic,copy) NSString *jiajian;
@property (nonatomic,copy) NSString *leixing;
@property (nonatomic,copy) NSString *tag;


@property (nonatomic, assign) NSInteger isScore;


@end

@interface FMTradeNoteModelCateId : NSObject

@property (nonatomic,copy) NSString *type_id;
@property (nonatomic,copy) NSString *title;


@end




@interface FMJoinDetalPrizeNewModel : NSObject


@property (nonatomic,assign) NSInteger awardType;
@property (nonatomic,assign) NSInteger awardTrench;
@property (nonatomic,copy) NSString *awardTime;
@property (nonatomic,assign) double awardMoney;
@property (nonatomic,assign) double inviteeBidMoney;

@property (nonatomic,assign) NSInteger projDuration;

@end


