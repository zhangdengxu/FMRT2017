//
//  YSMyPartyInCell.m
//  fmapp
//
//  Created by yushibo on 16/7/5.
//  Copyright © 2016年 yk. All rights reserved.
//
#define theButtonTag 100000
#import "YSMyPartyInCell.h"


@interface YSMyPartyInCell ()
/** 时间  */
@property (nonatomic, strong)UILabel *party_timeslot;
/** 标题  */
@property (nonatomic, strong)UILabel *party_theme;
/** 标签  */
@property (nonatomic, strong)UILabel *party_label;
/** 标签数组 */
@property (nonatomic, strong)NSMutableArray *party_labelArray;
@property (nonatomic, strong)UILabel *party_label0;
@property (nonatomic, strong)UILabel *party_label1;
@property (nonatomic, strong)UILabel *party_label2;
@property (nonatomic, strong)UILabel *party_label3;

@end

@implementation YSMyPartyInCell
/**
 *  添加子控件
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createContentView];
        
    }
    return self;
}

- (void)createContentView
{
    [super layoutSubviews];
    
    //标题
    UILabel *party_theme = [[UILabel alloc]init];
    self.party_theme = party_theme;
    party_theme.font = [UIFont systemFontOfSize:14];
    party_theme.textColor = [UIColor blackColor];
    [self.contentView addSubview:party_theme];
    [party_theme makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.left.equalTo(self.contentView.mas_left).offset(11);
    }];
    
    //时间
    UILabel *party_timeslot = [[UILabel alloc]init];
    self.party_timeslot = party_timeslot;
    party_timeslot.font = [UIFont systemFontOfSize:14];
    party_timeslot.textColor = [UIColor grayColor];
    [self.contentView addSubview:party_timeslot];
    [party_timeslot makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(party_theme.mas_left);
        make.top.equalTo(party_theme.mas_bottom).offset(15);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = KDefaultOrBackgroundColor;
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(107);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(1);
    }];
    
    //底部按钮
    //左
    UIImageView *imagV1 = [[UIImageView alloc]init];
    [imagV1 setImage:[UIImage imageNamed:@"进行中活动-查看"]];
    [self.contentView addSubview:imagV1];
    [imagV1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(11);
        make.centerX.equalTo(self.contentView.mas_left).offset((KProjectScreenWidth - 25) / 6);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"查看";
    label1.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imagV1.mas_bottom).offset(3);
        make.centerX.equalTo(imagV1.mas_centerX);
    }];
    //透明button
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setTag:theButtonTag];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn1];
    [btn1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_left).offset((KProjectScreenWidth - 25) / 3);
    }];
    
    //右
    UIImageView *imagV2 = [[UIImageView alloc]init];
    [imagV2 setImage:[UIImage imageNamed:@"进行中活动-分享"]];
    [self.contentView addSubview:imagV2];
    [imagV2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(11);
        make.centerX.equalTo(self.contentView.mas_right).offset(- (KProjectScreenWidth - 25) / 6);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"分享";
    label2.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imagV2.mas_bottom).offset(3);
        make.centerX.equalTo(imagV2.mas_centerX);
    }];
    //透明button
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTag:theButtonTag+1];
    [self.contentView addSubview:btn2];
    [btn2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.contentView.mas_right).offset(- (KProjectScreenWidth - 25) / 3);
    }];
    
    //中
    UIImageView *imagV3 = [[UIImageView alloc]init];
    [imagV3 setImage:[UIImage imageNamed:@"进行中活动-修改"]];
    [self.contentView addSubview:imagV3];
    [imagV3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(9);
        make.centerX.equalTo(self.contentView.mas_left).offset((KProjectScreenWidth - 25) / 2);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"修改";
    label3.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:label3];
    [label3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imagV3.mas_bottom).offset(2);
        make.centerX.equalTo(imagV3.mas_centerX);
    }];
    //透明button
    UIButton *btn3 = [[UIButton alloc]init];
    btn3.backgroundColor = [UIColor clearColor];
    [btn3 setTag:theButtonTag+2];
    [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn3];
    [btn3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(btn2.mas_left);
        make.left.equalTo(btn1.mas_right);
    }];
}


-(void)btnAction:(UIButton *)button{

    if (self.blockBtn) {
        self.blockBtn(button);
    }

}

/**
 *  设置子控件显示数据
 */
- (void)setDataSource:(YSMyPartyModel *)dataSource{
    
    _dataSource = dataSource;
    self.party_labelArray = dataSource.party_labelArray;
    self.party_theme.text = dataSource.party_theme;
    self.party_timeslot.text = dataSource.party_timeslot;
    [self createLabelWith:dataSource.party_labelArray];
}

- (void)createLabelWith:(NSArray *)arr{
    
    if (self.party_labelArray.count) {
        
        for(int i = 0; i < [self.party_labelArray count]; i++){
            
            UILabel *party_label = [[UILabel alloc]init];
            party_label.textColor = [UIColor whiteColor];
            party_label.font = [UIFont systemFontOfSize:13];
            NSDictionary *dict= self.party_labelArray[i];
            party_label.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@", dict[@"yanse"]]];
            party_label.text = [NSString stringWithFormat:@"%@",dict[@"mingcheng"]];
            party_label.layer.masksToBounds =YES;
            party_label.layer.cornerRadius = 3;
            [self.contentView addSubview:party_label];
            if (i == 0) {
                self.party_label0 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_timeslot.mas_left);
                    make.top.equalTo(_party_timeslot.mas_bottom).offset(13);
                }];
            }
            if(i == 1){
                self.party_label1 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label0.mas_right).offset(7);
                    make.top.equalTo(_party_timeslot.mas_bottom).offset(13);
                }];
            }
            if(i == 2){
                self.party_label2 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label1.mas_right).offset(7);
                    make.top.equalTo(_party_timeslot.mas_bottom).offset(13);
                }];
            }
            if( i == 3){
                self.party_label3 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label2.mas_right).offset(7);
                    make.top.equalTo(_party_timeslot.mas_bottom).offset(13);
                }];
            }
            if( i == 4){
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label3.mas_right).offset(7);
                    make.top.equalTo(_party_timeslot.mas_bottom).offset(13);
                }];
            }
            
        }
        
    }
    
}



@end
