//
//  FMTradeNoteTableViewCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/12.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTradeNoteModel,FMJoinDetalPrizeNewModel;

@interface FMTradeNoteTableViewCell : UITableViewCell

@property (nonatomic, strong) FMTradeNoteModel * tradeNote;
@property (nonatomic, strong) FMJoinDetalPrizeNewModel * joinDetail;

@end
