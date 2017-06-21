//
//  XZProjectDetailCell.m
//  fmapp
//
//  Created by admin on 17/4/10.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "XZProjectDetailCell.h"
#import "XZBaskOrderListInnerItem.h" // 只带图片的item
#import "XZProjectDetailPicWordItem.h" // 带文字和图片的item

static NSString *reuseID = @"ProjectDetailItem";

@interface XZProjectDetailCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectProjectDetail;

@end

@implementation XZProjectDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpProjectDetailCell];
    }
    return self;
}

#pragma mark ---- 
- (void)setUpProjectDetailCell {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZBaskOrderListInnerItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    item.photoUrl = @"";
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ---- 懒加载
- (UICollectionView *)collectProjectDetail {
    if (!_collectProjectDetail) {
        CGFloat kHeight = (KProjectScreenWidth - 24) / 4.0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        CGFloat width =  kHeight * 2 - 19;
        CGFloat width = kHeight * 316 / 222.0;
        flowLayout.itemSize = CGSizeMake(width, kHeight + 10); // + 45
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 22
        _collectProjectDetail = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, KProjectScreenWidth, kHeight + 25 + 10) collectionViewLayout:flowLayout];
        _collectProjectDetail.backgroundColor = [UIColor whiteColor];
        _collectProjectDetail.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectProjectDetail.showsHorizontalScrollIndicator = NO;
        _collectProjectDetail.dataSource = self;
        _collectProjectDetail.delegate = self;
        [_collectProjectDetail registerClass:[XZBaskOrderListInnerItem class] forCellWithReuseIdentifier:reuseID];
    }
    return _collectProjectDetail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
