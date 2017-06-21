//
//  YSMyPartyViewCell.m
//  fmapp
//
//  Created by yushibo on 16/7/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSMyPartyViewCell.h"

@interface YSMyPartyViewCell()
/** 时间  */
@property (nonatomic, strong)UILabel *party_timeslot;
/** 标题  */
@property (nonatomic, strong)UILabel *party_theme;
/** 标签  */
@property (nonatomic, strong)UILabel *party_label;
/** 报名人数  */
@property (nonatomic, strong)UILabel *party_adder;
/** 标签数组 */
@property (nonatomic, strong)NSMutableArray *party_labelArray;
@property (nonatomic, strong)UILabel *party_label0;
@property (nonatomic, strong)UILabel *party_label1;
@property (nonatomic, strong)UILabel *party_label2;
@property (nonatomic, strong)UILabel *party_label3;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation YSMyPartyViewCell

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
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(party_timeslot.mas_bottom).offset(13);
        make.left.equalTo(party_timeslot.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-11);
        make.height.equalTo(1);
    }];
    //标签
    
    /**
     *  这块迫不得已,写了全局的4个label  为了来用mas.做约束,准备了5个label,相信后台不会出现5个以上的传递! 恩,不会的. 同时  对不住龙哥教我的for循环了....
     */
    //报名人数
    UILabel *hanzi = [[UILabel alloc]init];
    hanzi.text = @"报名";
    hanzi.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:hanzi];
    [hanzi makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right);
        make.top.equalTo(lineView.mas_bottom).offset(14);
    }];
    UILabel *party_adder = [[UILabel alloc]init];
    party_adder.textColor = [UIColor orangeColor];
    party_adder.font = [UIFont systemFontOfSize:13];
    self.party_adder = party_adder;
    [self.contentView addSubview:party_adder];
    [party_adder makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hanzi.mas_left);
        make.centerY.equalTo(hanzi.mas_centerY);
    }];
}

/**
 *  设置子控件显示数据
 */
- (void)setDataSource:(YSMyPartyModel *)dataSource{

    _dataSource = dataSource;
    self.party_labelArray = dataSource.party_labelArray;
    self.party_theme.text = dataSource.party_theme;
    self.party_timeslot.text = dataSource.party_timeslot;
    self.party_adder.text = dataSource.party_adder;
    

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
                    make.left.equalTo(self.lineView.mas_left);
                    make.top.equalTo(_lineView.mas_bottom).offset(13);
                }];
            }
            if(i == 1){
                self.party_label1 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label0.mas_right).offset(7);
                    make.top.equalTo(_lineView.mas_bottom).offset(13);
                }];
            }
            if(i == 2){
                self.party_label2 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label1.mas_right).offset(7);
                    make.top.equalTo(_lineView.mas_bottom).offset(13);
                }];
            }
            if( i == 3){
                self.party_label3 = party_label;
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label2.mas_right).offset(7);
                    make.top.equalTo(_lineView.mas_bottom).offset(13);
                }];
            }
            if( i == 4){
                [party_label makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.party_label3.mas_right).offset(7);
                    make.top.equalTo(_lineView.mas_bottom).offset(13);
                }];
            }
            
        }
        
    }

}

@end
