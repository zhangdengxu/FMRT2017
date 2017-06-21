//
//  FMRTWellStoreHeaderView.m
//  fmapp
//
//  Created by apple on 2016/12/2.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTWellStoreHeaderView.h"
#import "FMRTWellStoreCollectionModel.h"
#import "FMRTWellStoreTopCollectionViewCell.h"
#import "FMRTWellStoreProductModel.h"

@interface FMRTWellStoreHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, weak)   UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FMRTWellStoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self createContentView];
    }
    return self;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)createContentView{
    
    [self addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
        make.height.equalTo(KProjectScreenWidth * 348/640);
    }];
    
    UIImageView *bottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"优商城首页_海报底_36"]];
    [self addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.equalTo(self.scrollView);
    }];
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionLayout.minimumInteritemSpacing = 1;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[FMRTWellStoreTopCollectionViewCell class] forCellWithReuseIdentifier:@"FMRTWellStoreTopCollectionViewCell"];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.scrollView.bottom);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(@65);
    }];
    
    
    UIButton *allTakeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [allTakeBtn setBackgroundImage:[UIImage imageNamed:@"优商城_全民夺宝_36"] forState:(UIControlStateNormal)];
    [allTakeBtn addTarget:self action:@selector(allTakeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:allTakeBtn];
    [allTakeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.collectionView.bottom).equalTo(5);
        make.left.equalTo(self.left);
        make.width.equalTo(KProjectScreenWidth/3);
        make.height.equalTo(KProjectScreenWidth/3*236/212);
    }];
    
    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self addSubview:leftLine];
    [leftLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(allTakeBtn.top);
        make.right.equalTo(allTakeBtn.right);
        make.width.equalTo(@1);
        make.bottom.equalTo(allTakeBtn.bottom);
    }];
    
    UIButton *killBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [killBtn setBackgroundImage:[UIImage imageNamed:@"优商城_限时秒杀_36"] forState:(UIControlStateNormal)];
    [killBtn addTarget:self action:@selector(killBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:killBtn];
    [killBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.collectionView.bottom).equalTo(5);
        make.left.equalTo(allTakeBtn.right);
        make.width.equalTo(KProjectScreenWidth/3);
        make.height.equalTo(KProjectScreenWidth/3*236/212);
    }];
    
    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor = [HXColor colorWithHexString:@"#e4ebf1"];
    [self addSubview:rightLine];
    [rightLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(killBtn.top);
        make.right.equalTo(killBtn.right);
        make.width.equalTo(@1);
        make.bottom.equalTo(killBtn.bottom);
    }];
    
    UIButton *jifenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [jifenBtn setBackgroundImage:[UIImage imageNamed:@"优商城_积分换购_36"] forState:(UIControlStateNormal)];
    [jifenBtn addTarget:self action:@selector(jifenBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:jifenBtn];
    [jifenBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.collectionView.bottom).equalTo(5);
        make.right.equalTo(self.right);
        make.width.equalTo(KProjectScreenWidth/3);
        make.height.equalTo(KProjectScreenWidth/3*236/212);
    }];
}

- (void)jifenBtnAction{
    if (self.jinfenBlock) {
        self.jinfenBlock();
    }
}

- (void)killBtnAction{
    if (self.killBlock) {
        self.killBlock();
    }
}

- (void)allTakeAction{
    if (self.allTakeBlcok) {
        self.allTakeBlcok();
    }
}

- (SDCycleScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = ({
            
            SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:[UIImage imageNamed:@"美读时光headerBack_02"]];
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.showPageControl = NO;
            scrollView.autoScrollTimeInterval = 5.0;
            scrollView.autoScroll = YES;
            FMWeakSelf;
            scrollView.begingBlock = ^(){
                if (weakSelf.beginBlcok) {
                    weakSelf.beginBlcok();
                }
            };
            
            scrollView.endBlock = ^(){
                if (weakSelf.endBlcok) {
                    weakSelf.endBlcok();
                }
            };
            
            
            scrollView.clickItemOperationBlock = ^(NSInteger currentIndex){
                if (weakSelf.scroBlock) {
                    weakSelf.scroBlock(currentIndex);
                }
            };
            scrollView;
        });
    }
    return _scrollView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KProjectScreenWidth/self.dataSource.count - 2, 65);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FMRTWellStoreTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FMRTWellStoreTopCollectionViewCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.collectionBlock) {
        self.collectionBlock(indexPath.row);
    }
}

- (void)setScrollArr:(NSArray *)scrollArr{
    _scrollArr = scrollArr;
    NSMutableArray *data = [NSMutableArray array];
    for (FMRTWellScroModel *model in scrollArr) {
        [data addObject:model.img];
    }
    
    self.scrollView.imageURLStringsGroup = [data copy];

    [self.collectionView reloadData];
}

- (void)setTuijian:(NSString *)tuijian{
    _tuijian = tuijian;
    
    if ([tuijian integerValue] == 1) {
        _dataSource = [NSMutableArray arrayWithArray:[FMRTWellStoreCollectionModel dataSource]];
    }else{
        _dataSource = [NSMutableArray arrayWithArray:[FMRTWellStoreCollectionModel dataArr]];
    }
}

@end
