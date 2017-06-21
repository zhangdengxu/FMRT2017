//
//  XMConverNoteCell.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMConverNoteCell.h"
#import "UIImageView+WebCache.h"
#import "XmConverNotesModel.h"

@interface XMConverNoteCell ()

@property (weak, nonatomic) IBOutlet UILabel *scoreShopCity;
@property (weak, nonatomic) IBOutlet UILabel *goodsStates;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titlelaabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;
@property (weak, nonatomic) IBOutlet UILabel *countNumber;



@end

@implementation XMConverNoteCell


-(void)setUpConverDeleteButtonLayer;
{
    self.converDelete.layer.borderWidth = 0.5;
    self.converDelete.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
-(void)setNoteModel:(XmConverNotesModel *)noteModel
{
    _noteModel = noteModel;
    
    if ([noteModel.zhuangtai isEqualToString:@"1"]) {
        self.goodsStates.text = @"已发货";
    }else
    {
        self.goodsStates.text = @"待发货";
    }
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:noteModel.pic]];
    self.titlelaabel.text = noteModel.shangpinmingcheng;
    self.scoreCount.text = [NSString stringWithFormat:@"%@积分",noteModel.dangejifen];
    self.countNumber.text = [NSString stringWithFormat:@"x%@",noteModel.shuliang];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
