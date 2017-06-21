//
//  FMRTAuctionHeaderView.m
//  fmapp
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTAuctionHeaderView.h"

#import "Fm_Tools.h"
#import "FMRTAuSecView.h"
#import "FMRTProductCollectionViewCell.h"
#import "FMRTRankingCollectionViewCell.h"
#import "SDCycleScrollView.h"

@interface FMRTAuctionHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FMRTAuSecView *auSecView;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end
static NSString *FMRTProductCollectionCell = @"FMRTProductCollectionViewCell";
static NSString *FMRTRankingCollectionCell = @"FMRTRankingCollectionViewCell";


@implementation FMRTAuctionHeaderView
-(void)dealloc
{
//    NSLog(@"^^^^ 释放喽…………:)");
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createTopView];
    }
    return self;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (FMRTAuSecView *)auSecView{
    
    if (!_auSecView) {
        
        _auSecView = ({
            __weak typeof (self) weakSelf = self;
            FMRTAuSecView *auSecView = [FMRTAuSecView new];
            auSecView.ruleBlcok = ^(){
                [weakSelf activityRuleDisplay];
            };
            auSecView.auctionStartBlcok = ^(){
                [weakSelf activityAllBeginStart];
            };
            auSecView.auctionEndBlcok = ^(){
                [weakSelf activityAllEnd];
            };
            auSecView;
        });
        [self addSubview:self.auSecView];

    }
    return _auSecView;
}

- (void)activityRuleDisplay{
    if (self.ABlock) {
        self.ABlock();
    }
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc]init];
            collectionLayout.minimumLineSpacing = 1;
            collectionLayout.minimumInteritemSpacing = 1;//(KProjectScreenWidth - 40)/2 + 150
            collectionLayout.itemSize = CGSizeMake((KProjectScreenWidth -1)/2 ,(KProjectScreenWidth - 40)/2 + 150);
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
            collectionView.backgroundColor = KDefaultOrBackgroundColor;
            collectionView.scrollEnabled = NO;
            collectionView.alwaysBounceVertical = YES;
            [collectionView registerClass:[FMRTProductCollectionViewCell class] forCellWithReuseIdentifier:FMRTProductCollectionCell];//
            [collectionView registerClass:[FMRTRankingCollectionViewCell class] forCellWithReuseIdentifier:FMRTRankingCollectionCell];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView;
        });
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataSource.count - 1) {
        FMRTRankingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMRTRankingCollectionCell forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else{
        
        FMRTProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMRTProductCollectionCell forIndexPath:indexPath];
        __weak typeof (self) weakSelf = self;
        cell.PBlock = ^(UIButton *sender,NSInteger type, NSString *auctionId,NSString *productId,NSInteger endCount){
            [weakSelf buttonAction:sender type:type ID:auctionId productId:productId endCount:endCount];
        };
        cell.RBlock = ^(NSString *auctionId){
            [weakSelf recordAction:auctionId];
        };
        cell.model = self.dataSource[indexPath.row];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSource.count - 1) {
        
    }else{
       FMRTAucFirstModel *model = self.dataSource[indexPath.row];
        
        if ([model.current_price floatValue]== [model.max_price floatValue]) {
            model.activity_state = @"3";
        }else{
            
        }
        
       if (self.productDetailBlock) {
           self.productDetailBlock(model.product_id,model.auction_id,model.activity_state,model.current_price);
       }
    }
}

- (void)recordAction:(NSString *)auctionId{
    if (self.RBlock) {
        self.RBlock(auctionId);
    }
}

- (void)buttonAction:(UIButton *)sender type:(NSInteger)type ID:(NSString *)auctionId productId:(NSString *)productId endCount:(NSInteger )count{
    if (self.PBlock) {
        self.PBlock(sender,type,auctionId,productId,count);
    }
}

- (SDCycleScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = ({
            
            SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:[UIImage imageNamed:@"美读时光headerBack_02"]];
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.showPageControl = NO;
            scrollView.autoScroll = YES;
            self.scrollView = scrollView;
            scrollView.clickItemOperationBlock = ^(NSInteger currentIndex){
                if (self.topImageBlock) {
                    self.topImageBlock();
                }
            };
            scrollView;
        });
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)createTopView{
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(KProjectScreenWidth * 290 /640);
    }];
    
    [self.auSecView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.scrollView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@80);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.auSecView.mas_bottom).offset(1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(((KProjectScreenWidth - 40)/2 + 150) * 3);
    }];
}

/**
 *  进入界面后，竞拍结束后动作
 */
- (void)activityAllEnd{
    
    if (self.endBlock) {
        self.endBlock();
    }
    
    for (int i = 0; i < self.dataSource.count - 1; i++) {
        FMRTAucFirstModel *model = self.dataSource[i];
        model.activity_state = @"3";
    }
    [self.collectionView reloadData];
}

/**
 *  进入界面活动倒计时结束＝竞拍开始刷新表格数据
 */
- (void)activityAllBeginStart{

    for (int i = 0; i < self.dataSource.count - 1; i++) {
        FMRTAucFirstModel *model = self.dataSource[i];
        model.activity_state = @"2";
    }
    [self.collectionView reloadData];
    
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)sendDataWithModel:(FMRTAucDataModel *)model{
    
    _dataSource = [NSMutableArray arrayWithArray: model.aucDataSource];
    NSInteger typeCount = 0;
    for (int i = 0; i < self.dataSource.count - 1; i++) {
        FMRTAucFirstModel *model = self.dataSource[i];
        typeCount += [model.activity_state intValue];
            
    }
    if (typeCount >= (self.dataSource.count - 1) * 3) {
        
        self.auSecView.typeCount = typeCount;

    }else{
        self.auSecView.inAuctionTime = typeCount;
    }
    
    [self.collectionView reloadData];
}

- (void)setModel:(FMRTAucDataModel *)model{
    _model = model;
        
    if (model.topPhotoArr.count!=0 && ![model.topPhotoArr isKindOfClass:[NSNull class]]) {
        self.scrollView.imageURLStringsGroup = model.topPhotoArr;
    }else{
        self.scrollView.imageURLStringsGroup = [NSMutableArray array];
    }
    
    _dataSource = [NSMutableArray arrayWithArray: model.aucDataSource];
    NSInteger hh = (self.dataSource.count +1)/2;

    if (self.dataSource.count !=6 ) {
        [self.collectionView updateConstraints:^(MASConstraintMaker *make) {

            make.height.equalTo(((KProjectScreenWidth - 40)/2 + 150) * hh);
        }];
        [self.collectionView reloadData];

    }else{
        [self.collectionView reloadData];
    }

    if (self.dataSource.count > 1) {
        
        FMRTAucFirstModel *m = [self.dataSource firstObject];
        
        if (m.begin_time && m.end_time) {
            
            [self.auSecView sendDataWithBeginTime:[Fm_Tools getTotalTimeWithSecondsFromString:m.begin_time] endTime:[Fm_Tools getTotalTimeWithSecondsFromString:m.end_time]];
            
            NSInteger typeCount = 0;
            for (int i = 0; i < self.dataSource.count - 1; i++) {
                FMRTAucFirstModel *model = self.dataSource[i];
                typeCount += [model.activity_state intValue];
            }
            if (typeCount >= (self.dataSource.count - 1) * 3) {
                
                self.auSecView.typeCount = typeCount;
            }
        }
    }
    
    [self.collectionView reloadData];

}

@end
