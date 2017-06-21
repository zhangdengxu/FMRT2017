//
//  XMCalenderCellMonth.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/26.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KDefaultCalenderCell @"XMCalenderViewItem"
#import "XMCalenderCellMonth.h"
#import "XMCalenderViewItem.h"
@interface XMCalenderCellMonth ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *weekContent;

@property (weak, nonatomic) IBOutlet UIView *monthContent;

@property (nonatomic , strong) NSArray *weekDayArray;

@property (nonatomic, weak) UICollectionView * collectionView;
@end

@implementation XMCalenderCellMonth

-(void)setSizeCell:(CGSize)sizeCell
{
    _sizeCell = sizeCell;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self clearAllContent:self.monthContent];
    [self createmonthContent];
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)clearAllContent:(UIView *)montherView
{
    for (UIView * view in montherView.subviews) {
        [view removeFromSuperview];
    }
}
-(void)createmonthContent
{
    CGRect rect = CGRectMake(0,0 , self.monthContent.frame.size.width, self.monthContent.frame.size.height );
    UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionLayout.minimumLineSpacing = 0.0;//行间距(最小值)
    collectionLayout.minimumInteritemSpacing = 0.0;//item间距(最小值)
    collectionLayout.itemSize = CGSizeMake( (self.sizeCell.width - 18 ) / 7, (self.sizeCell.height - 18 ) / 7);
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [collectionLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView * collection = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:collectionLayout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = KDefaultOrBackgroundColor;
    collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    collection.alwaysBounceVertical = YES;
    [collection registerNib:[UINib nibWithNibName:@"XMCalenderViewItem" bundle:nil] forCellWithReuseIdentifier:KDefaultCalenderCell];
    self.collectionView = collection;
    collection.bounces = NO;
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    [self.monthContent addSubview:collection];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMCalenderViewItem * item = [collectionView dequeueReusableCellWithReuseIdentifier:KDefaultCalenderCell forIndexPath:indexPath];
    item.model = self.dataSource[indexPath.item];
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(XMCalenderCellMonthDidSelectItem:withModel:)]) {
        [self.delegate XMCalenderCellMonthDidSelectItem:self withModel:self.dataSource[indexPath.item]];
    }
}

- (void)awakeFromNib {
    // Initialization code

    
    
}
/**
 *
 titlelabel.translatesAutoresizingMaskIntoConstraints = NO;
 if (lastView) {
 //titlelabel宽度与lastView宽度相等
 NSLayoutConstraint* titlelabelWidthConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
 //titlelabel左侧与lastView右侧对齐
 NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
 titlelabelWidthConstraint.active = YES;
 leftConstraint.active = YES;
 }else if(i == self.weekDayArray.count - 1)
 {
 //titlelabel左侧与lastView右侧对齐
 NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
 //最后一个
 //titlelabel右侧与父视图右侧对齐
 NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.weekContent attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
 //titlelabel宽度与lastView宽度相等
 NSLayoutConstraint* titlelabelWidthConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
 leftConstraint.active = YES;
 rightConstraint.active = YES;
 titlelabelWidthConstraint.active = YES;
 }else
 {
 //头一个
 //titlelabel左侧与父视图左侧对齐
 NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.weekContent attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
 
 leftConstraint.active = YES;
 
 }
 //titlelabel底部与父视图底部对齐
 NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.weekContent attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
 
 //titlelabel底部与父视图底部对齐
 NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:titlelabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.weekContent attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
 topConstraint.active = YES;
 bottomConstraint.active = YES;
 lastView = titlelabel;

 */
@end
