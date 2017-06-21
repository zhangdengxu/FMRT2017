//
//  FMRTMonthAcountTableViewCell.m
//  fmapp
//
//  Created by apple on 2017/2/17.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTMonthAcountTableViewCell.h"
#import "FMRTCirlceHalfView.h"
#import "FMRTMonthAcountCollectionViewCell.h"
#import "FMRTMonthAcountModel.h"
#import "MJExtension.h"

@interface FMRTMonthAcountTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) FMRTCirlceHalfView* circleView;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* dataSource;

@end

@implementation FMRTMonthAcountTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createContentViews];
    }
    return self;
}

- (void)createContentViews {
    

    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionLayout.minimumInteritemSpacing = 1;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[FMRTMonthAcountCollectionViewCell class] forCellWithReuseIdentifier:@"FMRTMonthAcountCollectionViewCell"];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.circleView.centerY);
        make.left.equalTo(self.centerX);
        make.right.equalTo(self.right);
        make.height.equalTo(@160);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (FMRTCirlceHalfView *)circleView{
    if (!_circleView) {
        _circleView = [[FMRTCirlceHalfView alloc] initWithFrame:CGRectMake(0, 0, KProjectScreenWidth/2,250)];
        [self.contentView addSubview:_circleView];
    }
    return _circleView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count-1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KProjectScreenWidth/2, 25);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FMRTMonthAcountCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FMRTMonthAcountCollectionViewCell" forIndexPath:indexPath];
    cell.row = indexPath.item;

    cell.number = self.dataSource[indexPath.item];
    return cell;
}

- (void)setModel:(FMRTMonthDataModel *)model{
    _model = model;
    
    NSArray *detailArr = [NSArray arrayWithObjects:@"充值",@"回款本金",@"本月佣金",@"本月收益",@"其他收入",@"", nil];
    NSArray *colorArr = [NSArray arrayWithObjects:@"#2cb6f2",@"#fd6165",@"#0159d5",@"#3eb78a",@"#feb358",@"#e4ebf1", nil];
    
    model.huise = 100;

    self.dataSource = [NSArray arrayWithObjects:@(model.RechargeAmt),@(model.BackPrincipalAmt),@(model.CommissionAmt),@(model.IncomeAmt),@(model.OtherIncomeAmt),@(model.huise), nil];
    
    NSMutableArray *arr = [NSMutableArray array];
    double number = 0;
    
    for (int i = 0; i< _dataSource.count; i++) {
        
        FMRTMonthAcountModel *model = [[FMRTMonthAcountModel alloc]init];
        model.name = detailArr[i];
        model.number = self.dataSource[i];
        number +=[model.number doubleValue];
        model.color = colorArr[i];
        if ([model.number longLongValue] !=0) {
            [arr addObject:model.mj_keyValues];
        }
    }
    
    if (number>100) {
        self.circleView.hasZheXian = 0;
        [arr removeLastObject];
    }else{
        self.circleView.hasZheXian = 0;
    }
    
    [self.circleView loadDataArray:arr withType:MYHCircleManageViewTypeRound];
    [self.collectionView reloadData];
}


@end
