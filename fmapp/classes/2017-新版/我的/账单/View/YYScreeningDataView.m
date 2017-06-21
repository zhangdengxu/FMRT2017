//
//  YYScreeningDataView.m
//  fmapp
//
//  Created by yushibo on 2017/2/27.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYScreeningDataView.h"
#import "YYScreeningDataCell.h"
#import "YYScreeningDataModel.h"

static NSString *ID1 = @"YYMineViewCell";
static NSString *ID2 = @"headerView";
static NSString *ID3 = @"footerView";


@interface YYScreeningDataView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *titleArray2;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation YYScreeningDataView


-(NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        /**  保存模型数据 */
        NSMutableArray *array1 = [NSMutableArray array];
        YYScreeningDataModel *model1 = [[YYScreeningDataModel alloc]initWithNSString:@"全部" selectedState:YES];
        [array1 addObject:model1];
        
        
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i=0; i < 4; i++) {
            YYScreeningDataModel *model2 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray objectAtIndex:i]] selectedState:NO];
            [array2 addObject:model2];
        }
        
        NSMutableArray *array3 = [NSMutableArray array];
        for (int i=0; i < 2; i++) {
            YYScreeningDataModel *model3 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray2 objectAtIndex:i]] selectedState:NO];
            [array3 addObject:model3];
        }
        
        
        [_dataSource addObject:array1];
        [_dataSource addObject:array2];
        [_dataSource addObject:array3];
    }
    return _dataSource;
}

-(NSArray *)titleArray{
    if(!_titleArray){
        _titleArray = [NSArray arrayWithObjects:@"充值",@"回款",@"奖励",@"其他", nil];
    }
    return _titleArray;
}

-(NSArray *)titleArray2{

    if (!_titleArray2) {
        _titleArray2 = [NSArray arrayWithObjects:@"投资",@"提现", nil];
    }
    return _titleArray2;
}
-(instancetype)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame:frame]) {
       
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//        [self setDataSource];
        [self createContentView];
    }
    return self;
}
- (void)createContentView{

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(KProjectScreenWidth / 3, 0, (KProjectScreenWidth / 3) * 2, KProjectScreenHeight - 20)];
    backView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
    [self addSubview:backView];
    UILabel *settingLabel = [[UILabel alloc]init];
    settingLabel.text = @"设置筛选条件";
    settingLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:settingLabel];
    [settingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.top.equalTo(backView.mas_top).offset(15);
//        make.left.equalTo(backView.mas_left).offset(15);

    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
//    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn setImage:[UIImage imageNamed:@"月账单_关闭--叉号_03_1702"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:closeBtn];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backView.mas_left).offset(15);
        make.top.equalTo(backView.mas_top).offset(15);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@50);

    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, (KProjectScreenWidth / 3) * 2, 1)];
    lineView.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];

    [backView addSubview:lineView];

    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewLayout.itemSize = CGSizeMake((KProjectScreenWidth / 3) - 30, 30);
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    collectionViewLayout.minimumLineSpacing = 20;
    collectionViewLayout.minimumInteritemSpacing = 10;
    collectionViewLayout.headerReferenceSize = CGSizeMake((KProjectScreenWidth / 3) * 2, 46);
    collectionViewLayout.footerReferenceSize = CGSizeMake((KProjectScreenWidth / 3) * 2, 20);

    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(KProjectScreenWidth / 3, 45, (KProjectScreenWidth / 3) * 2, KProjectScreenHeight - 64) collectionViewLayout:collectionViewLayout];
    [collectionView registerClass:[YYScreeningDataCell class] forCellWithReuseIdentifier:ID1];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ID2];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ID3];

    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
    [self addSubview:collectionView];
    
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else{
        return 2;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YYScreeningDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID1 forIndexPath:indexPath];

    if (self.dataSource.count) {
        NSMutableArray *array = self.dataSource[indexPath.section];
        cell.model = array[indexPath.item];
    }
    
    return cell;
}
#pragma mark ---- 创建 UICollectionView headerView 代理方法
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ID2 forIndexPath:indexPath];
        headerView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
//        headerView.backgroundColor = [UIColor redColor];
        
        if (headerView.subviews) {
            for (UIView *view in headerView.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    [view removeFromSuperview];
                }
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.tintColor = [HXColor colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont systemFontOfSize:17];
        if (indexPath.section == 0) {
            
        }else if (indexPath.section == 1){
        
            titleLabel.text = @"收入";
        }else if (indexPath.section == 2){
            titleLabel.text = @"支出";
        }
        [headerView addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(15);
            make.centerY.equalTo(headerView.mas_centerY);
        }];
        reusableView = headerView;
        FMWeakSelf
//        headerView.indevertBlock = ^(UIButton *sender){
//            [weakSelf indevertWhenMoney];
//        };
//        
//        headerView.quxianBlock = ^(UIButton *sender){
//            
//            [weakSelf withDrawMoney];
//        };
//        headerView.rechargeBlock = ^(UIButton *sender){
//            
//            [weakSelf rechageMoney];
//        };
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ID3 forIndexPath:indexPath];
    
        footerView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
        reusableView = footerView;
        
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray *array = self.dataSource[indexPath.section];
    YYScreeningDataModel *model = array[indexPath.item];
    NSString *title = model.title;
    NSString *type = [[NSString alloc]init];
    if ([title isEqualToString:@"其他"]) {
        
        type = @"0";
    }else if ([title isEqualToString:@"充值"]){
    
        type = @"1";
    }else if ([title isEqualToString:@"提现"]){
        
        type = @"2";
    }else if ([title isEqualToString:@"投资"]){
        
        type = @"3";
    }else if ([title isEqualToString:@"回款"]){
        
        type = @"4";
    }else if ([title isEqualToString:@"奖励"]){
        
        type = @"5";
    }else if ([title isEqualToString:@"全部"]){
        
        type = @"0,1,2,3,4,5";
    }


    if (self.modelBlock) {
        
        self.modelBlock(type);
    }

    [self.dataSource removeAllObjects];
    
    if (indexPath.section == 0) {
        /**  保存模型数据 */
        NSMutableArray *array1 = [NSMutableArray array];
        YYScreeningDataModel *model1 = [[YYScreeningDataModel alloc]initWithNSString:@"全部" selectedState:YES];
        [array1 addObject:model1];
        
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i=0; i < 4; i++) {
            YYScreeningDataModel *model2 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray objectAtIndex:i]] selectedState:NO];
            [array2 addObject:model2];
        }
        
        NSMutableArray *array3 = [NSMutableArray array];
        for (int i=0; i < 2; i++) {
            YYScreeningDataModel *model3 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray2 objectAtIndex:i]] selectedState:NO];
            [array3 addObject:model3];
        }

        [self.dataSource addObject:array1];
        [self.dataSource addObject:array2];
        [self.dataSource addObject:array3];
    
    }else if(indexPath.section == 1){
        /**  保存模型数据 */
        NSMutableArray *array1 = [NSMutableArray array];
        YYScreeningDataModel *model1 = [[YYScreeningDataModel alloc]initWithNSString:@"全部" selectedState:NO];
        [array1 addObject:model1];
        
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i=0; i < 4; i++) {
            if (i == indexPath.item) {
                YYScreeningDataModel *model2 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray objectAtIndex:i]] selectedState:YES];
                [array2 addObject:model2];

            }else{
            YYScreeningDataModel *model2 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray objectAtIndex:i]] selectedState:NO];
                [array2 addObject:model2];

            }
        }
        
        NSMutableArray *array3 = [NSMutableArray array];
        for (int i=0; i < 2; i++) {
            YYScreeningDataModel *model3 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray2 objectAtIndex:i]] selectedState:NO];
            [array3 addObject:model3];
        }
        
        [self.dataSource addObject:array1];
        [self.dataSource addObject:array2];
        [self.dataSource addObject:array3];
        
    }else if(indexPath.section == 2){
        /**  保存模型数据 */
        NSMutableArray *array1 = [NSMutableArray array];
        YYScreeningDataModel *model1 = [[YYScreeningDataModel alloc]initWithNSString:@"全部" selectedState:NO];
        [array1 addObject:model1];
        
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i=0; i < 4; i++) {
            
            YYScreeningDataModel *model2 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray objectAtIndex:i]] selectedState:NO];
            [array2 addObject:model2];

        }
        
        NSMutableArray *array3 = [NSMutableArray array];
        for (int i=0; i < 2; i++) {
            if (i == indexPath.item) {

                YYScreeningDataModel *model3 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray2 objectAtIndex:i]] selectedState:YES];
                [array3 addObject:model3];
            }else{
                
                YYScreeningDataModel *model3 = [[YYScreeningDataModel alloc]initWithNSString:[NSString stringWithFormat:@"%@", [self.titleArray2 objectAtIndex:i]] selectedState:NO];
                [array3 addObject:model3];

        
            }
        
        }
        
            [self.dataSource addObject:array1];
            [self.dataSource addObject:array2];
            [self.dataSource addObject:array3];

    }
    [self.collectionView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(KProjectScreenWidth, 20, KProjectScreenWidth, KProjectScreenHeight - 20);
        
    }];
}

-(void)closeBtnClick:(UIButton *)button{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(KProjectScreenWidth, 20, KProjectScreenWidth, KProjectScreenHeight - 20);
        
    }];
    
}
@end
