//
//  WLDuobaoTableViewCell.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/14.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLDuobaoTableViewCell.h"
#import "XZBaskOrderListInnerItem.h" // item
#import "XZBaskOrderModel.h" // model
#import "WLAllPelpleModel.h"
#import "Fm_Tools.h"
#import "MJPhoto.h"

#import "MJPhotoBrowser.h"
@interface WLDuobaoTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIImageView *imgIcon;
@property(nonatomic,strong)UILabel *labelNickname;
@property(nonatomic,strong)UILabel *days;
@property(nonatomic,strong)UILabel *persons;
@property(nonatomic,strong)UIImageView *tickets1;
@property(nonatomic,strong)UIImageView *tickets2;
@property(nonatomic,strong)UIImageView *tickets3;

@end

@implementation WLDuobaoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBaskOrderListCell];
    }
    return self;
}

- (void)setupBaskOrderListCell {
    self.contentView.backgroundColor = [UIColor whiteColor];
    /** 头像 */
    UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
    [self.contentView addSubview:imgIcon];
    imgIcon.backgroundColor = [UIColor lightGrayColor];
    self.imgIcon = imgIcon;
    
    /** 标题 */
    UILabel *labelNickname = [[UILabel alloc] initWithFrame:CGRectMake(115, 15, KProjectScreenWidth-130, 20)];
    [labelNickname setText:@"Apple苹果 iPhone6s4.7寸后边的字看不到了"];
    labelNickname.textColor = [UIColor blackColor];
    labelNickname.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:labelNickname];
    self.labelNickname = labelNickname;
    
    CGFloat width = 185*KProjectScreenWidth/375;
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(115, 40, KProjectScreenWidth-165, (KProjectScreenWidth-width)/11)];
    [self.contentView addSubview:bjView];
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((KProjectScreenWidth-width)/3*i+10*i, 0, (KProjectScreenWidth-width)/3, (KProjectScreenWidth-width)/11)];
        [bjView addSubview:imageV];
        if (i == 0) {
            self.tickets1 = imageV;
        }else if (i == 1){
            self.tickets2 = imageV;
        }else{
            self.tickets3 = imageV;
        }
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, .5)];
    [lineView setBackgroundColor:KDefaultOrBackgroundColor];
    [self.contentView addSubview:lineView];
    
    UIImageView *clockImg = [[UIImageView alloc]init];
    [clockImg setImage:[UIImage imageNamed:@"时间-改版"]];
    [self.contentView addSubview:clockImg];
    [clockImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgIcon.mas_right).offset(15);
        make.top.equalTo(bjView.mas_bottom).offset(20);
        make.height.equalTo(15);
        make.width.equalTo(15);
    }];
    /** 天数 */
    UILabel *days = [[UILabel alloc] init];
    [days setTextColor:[HXColor colorWithHexString:@"#999999"]];
    days.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:days];
    [days mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clockImg.mas_right).offset(5);
        make.top.equalTo(clockImg.mas_top);
        make.height.equalTo(15);
    }];
    self.days = days;
    
    UIImageView *clockImg1 = [[UIImageView alloc]init];
    [clockImg1 setImage:[UIImage imageNamed:@"1014人数"]];
    [self.contentView addSubview:clockImg1];
    [clockImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(days.mas_right).offset(30);
        make.top.equalTo(bjView.mas_bottom).offset(20);
        make.height.equalTo(15);
        make.width.equalTo(15);
    }];
    /** 人数 */
    UILabel *persons = [[UILabel alloc] init];
    [persons setTextColor:[HXColor colorWithHexString:@"#999999"]];
    persons.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:persons];
    [persons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clockImg1.mas_right).offset(5);
        make.top.equalTo(clockImg1.mas_top);
        make.height.equalTo(15);
    }];
    self.persons = persons;
}

-(void)setModel:(WLAllPelpleModel *)model{
    _model = model;

    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"敬请稍后new_03"]];
    [self.labelNickname setText:model.goods_name];
    [self.days setText:[NSString stringWithFormat:@"%@天",model.residue]];
    [self.persons setText:[NSString stringWithFormat:@"%@人",model.sum_person]];
    NSArray *tecketsArr = [NSArray arrayWithArray:model.ways];
    
    
    if (tecketsArr.count>0) {
        if ([[tecketsArr[0] objectForKey:@"type"] intValue] == 1) {
            if ([[tecketsArr[0] objectForKey:@"unit_cost"] intValue]==1 ) {
                [self.tickets1 setImage:[UIImage imageNamed:@"全新1币得"]];
            }else if ([[tecketsArr[0] objectForKey:@"unit_cost"] intValue]==5){
                [self.tickets1 setImage:[UIImage imageNamed:@"全新5币得"]];
            }
        }else if ([[tecketsArr[0] objectForKey:@"type"] intValue] == 2){
        
            [self.tickets1 setImage:[UIImage imageNamed:@"全新老友价"]];
        }
    }
    
    if (tecketsArr.count>1) {
        if ([[tecketsArr[1] objectForKey:@"type"] intValue] == 1) {
            if ([[tecketsArr[1] objectForKey:@"unit_cost"] intValue]==1 ) {
                [self.tickets2 setImage:[UIImage imageNamed:@"全新1币得"]];
            }else if ([[tecketsArr[1] objectForKey:@"unit_cost"] intValue]==5){
                [self.tickets2 setImage:[UIImage imageNamed:@"全新5币得"]];
            }
        }else if ([[tecketsArr[1] objectForKey:@"type"] intValue] == 2){
            
            [self.tickets2 setImage:[UIImage imageNamed:@"全新老友价"]];
        }
    }

    if (tecketsArr.count>2) {
        if ([[tecketsArr[2] objectForKey:@"type"] intValue] == 1) {
            if ([[tecketsArr[2] objectForKey:@"unit_cost"] intValue]==1 ) {
                [self.tickets3 setImage:[UIImage imageNamed:@"全新1币得"]];
            }else if ([[tecketsArr[2] objectForKey:@"unit_cost"] intValue]==5){
                [self.tickets3 setImage:[UIImage imageNamed:@"全新5币得"]];
            }
        }else if ([[tecketsArr[2] objectForKey:@"type"] intValue] == 2){
            
            [self.tickets3 setImage:[UIImage imageNamed:@"全新老友价"]];
        }
    }

    if (tecketsArr.count==0) {
        [self.tickets1 setImage:[UIImage imageNamed:@""]];
        [self.tickets2 setImage:[UIImage imageNamed:@""]];
        [self.tickets3 setImage:[UIImage imageNamed:@""]];
    }else if (tecketsArr.count==1){
        [self.tickets2 setImage:[UIImage imageNamed:@""]];
        [self.tickets3 setImage:[UIImage imageNamed:@""]];
    }else if (tecketsArr.count==2){
        [self.tickets3 setImage:[UIImage imageNamed:@""]];
    }
}

/*
 (
 {
 id = 7;
 type = 1;
 "unit_cost" = 1;
 },
 {
 id = 8;
 type = 1;
 "unit_cost" = 5;
 },
 {
 id = 9;
 type = 2;
 "unit_cost" = 100;
 }
 )

 */

#pragma mark ---- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZBaskOrderListInnerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaskOrderListInnerItem" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}




@end
