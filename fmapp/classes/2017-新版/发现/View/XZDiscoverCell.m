//
//  XZDiscoverCell.m
//  fmapp
//
//  Created by admin on 17/2/13.
//  Copyright © 2017年 yk. All rights reserved.
//  融讯融言一栏

#import "XZDiscoverCell.h"
#import "XZRongMiClubItem.h"
#import "FMBeautifulModel.h"

static NSString *reuseID = @"rongMiClub";

@interface XZDiscoverCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionClub;

@end

@implementation XZDiscoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpDiscoverCell];
    }
    return self;
}

- (void)setUpDiscoverCell {
//    self.contentView.backgroundColor = [UIColor redColor];
    
    UILabel *labelMessage = [[UILabel alloc] init];
    [self.contentView addSubview:labelMessage];
    [labelMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView); // .offset(-20)
        make.top.equalTo(self.contentView).offset(5);
    }];
    labelMessage.text = @"融讯融言";
    labelMessage.font = [UIFont systemFontOfSize:16.0f];
    
    UIImageView *imgArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imgArrow];
    [imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelMessage.mas_right).offset(10);
        make.centerY.equalTo(labelMessage);
        make.width.equalTo(@(12 * 0.6));
        make.height.equalTo(@(18 * 0.6));
    }];
    imgArrow.image = [UIImage imageNamed:@"帮助中心_三角箭头_1702"];
    
    // 覆盖的button
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.equalTo(@22);
        make.left.equalTo(labelMessage);
        make.right.equalTo(imgArrow).offset(10);
    }];
    [cover addTarget:self action:@selector(didClickCoverButton) forControlEvents:UIControlEventTouchUpInside];
    
    // collection
    [self.contentView addSubview:self.collectionClub];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    [self.contentView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelMessage);
        make.top.equalTo(self.collectionClub.mas_bottom).offset(5);
    }];
    labelTitle.text = @"推荐活动";
    labelTitle.font = [UIFont systemFontOfSize:16.0f];
}

#pragma mark ---- 点击了融讯融言
- (void)didClickCoverButton {
    if (self.blockCoverButton) {
        self.blockCoverButton();
    }
}

- (void)setDiscovers:(NSArray *)discovers {
    _discovers = discovers;
    [self.collectionClub reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZRongMiClubItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    FMBeautifulModel *model;
    if (self.discovers.count > 0) {
        model = self.discovers[indexPath.item];
    }
    item.momdelRongmi = model;
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidClickItem) {
        self.blockDidClickItem(indexPath);
    }
}

#pragma mark ---- 懒加载
- (UICollectionView *)collectionClub {
    if (!_collectionClub) {
        CGFloat kHeight = (KProjectScreenWidth - 24) / 4.0 + 10;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        CGFloat width =  kHeight * 2 - 19;
        CGFloat width = kHeight * 316 / 222.0;
        flowLayout.itemSize = CGSizeMake(width, kHeight + 10); // + 45
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 22
        _collectionClub = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, KProjectScreenWidth, kHeight + 25 + 10) collectionViewLayout:flowLayout];
        _collectionClub.backgroundColor = [UIColor whiteColor];
        _collectionClub.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionClub.showsHorizontalScrollIndicator = NO;
        _collectionClub.dataSource = self;
        _collectionClub.delegate = self;
        [_collectionClub registerClass:[XZRongMiClubItem class] forCellWithReuseIdentifier:reuseID];
    }
    return _collectionClub;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
