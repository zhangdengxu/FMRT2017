//
//  FMSelectShopCollectionView.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSelectDuobaoShopCollectionView.h"
#import "FMSelectShopCollectionViewFlowlayout.h"
#import "FMSelectShopCollectionViewItem.h"
#import "FMSelectShopCollectionReusableView.h"

#import "FMShopSpecModel.h"
@interface FMSelectDuobaoShopCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * myCollectionView;

@property (nonatomic, strong) UIColor * itemBackageColor,*itemSelectBackColor,*textColor,*selectTextColor,*unSelectColor;

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, assign) CGFloat itemCornerRadio;
@property (nonatomic, strong) NSMutableArray * selectItemDataSource;

@end

@implementation FMSelectDuobaoShopCollectionView


static NSString * const reuseIdentifier = @"FMSelectShopCollectionViewItem";
static NSString * const reuseIHeaderdentifier = @"tagHeaderListViewItemId";


-(NSMutableArray *)selectItemDataSource
{
    if (!_selectItemDataSource) {
        _selectItemDataSource = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    }
    return _selectItemDataSource;
}

-(void)setCurrentStore:(NSInteger)currentStore
{
    _currentStore = currentStore;
}

-(UICollectionView *)myCollectionView
{
    if (!_myCollectionView) {
        
        FMSelectShopCollectionViewFlowlayout * flowLayout = [[FMSelectShopCollectionViewFlowlayout alloc]initWithContentArray:self.dataSource];
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:flowLayout];
        
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[FMSelectShopCollectionViewItem class] forCellWithReuseIdentifier:reuseIdentifier];
        [_myCollectionView registerClass:[FMSelectShopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIHeaderdentifier];
        
        [self addSubview:_myCollectionView];
        
    }
    return _myCollectionView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setcollectionViewDataSource:(NSArray *)dataSource  WithSelectModel:(NSArray *)locationArray
{
    if (locationArray) {
        
        for (FMShopCollectionInfoModel * infoModel in locationArray) {
            if (infoModel.indexPath == nil) {
                NSInteger section = 0;
                NSInteger row = 0;
                for (NSInteger index = 0; index < dataSource.count; index ++) {
                    
                    FMShopSpecStringModel * modelString = dataSource[index];
                    if ([infoModel.spec_name isEqualToString:modelString.spec_name]) {
                        section = index;
                        for (NSInteger j = 0; j < modelString.styleStrings.count; j++) {
                            FMSpecStringModel * stringModel = modelString.styleStrings[j];
                            
                            if ([infoModel.contentString isEqualToString:stringModel.spec_name_value]) {
                                row = j;
                                break;
                            }
                            
                        }
                        
                        
                    }
                }
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                infoModel.indexPath = indexPath;
            }
        }
        
        [self.selectItemDataSource removeAllObjects];
        [self.selectItemDataSource addObjectsFromArray:locationArray];
    }
    
    
    if (self.showCountType == FMSelectShopCollectionViewTypeShowCount) {
        FMShopSpecStringModel * countModel = [[FMShopSpecStringModel alloc]init];
        countModel.spec_name = @"购买数量";
        countModel.styleStrings = nil;
        countModel.isShowCountView = YES;
        NSMutableArray * array = [NSMutableArray arrayWithArray:dataSource];
        [array addObject:countModel];
        self.dataSource = [array mutableCopy];
    }else
    {
        self.dataSource = [dataSource mutableCopy];;
    }
    
    [self setUpUI];
    
}


-(void)setUpUI
{
    self.itemCornerRadio = 7.0;
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.myCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
}



#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource
//有多少个Section

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    FMShopSpecStringModel * array = self.dataSource[section];
    
    return array.styleStrings.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMSelectShopCollectionViewFlowlayout *layout = (FMSelectShopCollectionViewFlowlayout *)collectionView.collectionViewLayout;
    
    
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    FMShopSpecStringModel * array = self.dataSource[indexPath.section];
    FMSpecStringModel * stringModel = array.styleStrings[indexPath.item] ;
    CGRect frame = [stringModel.spec_name_value boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMShopSpecStringModel * array = self.dataSource[indexPath.section];
    
    FMSelectShopCollectionViewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    FMSpecStringModel * stringModel = array.styleStrings[indexPath.item];
    
    
    
    cell.layer.cornerRadius = self.itemCornerRadio;
    cell.titleLabel.text = stringModel.spec_name_value;
    
    
    
    FMShopCollectionInfoModel * oldCollectionInfoModel;
    for (NSInteger i = 0; i < self.selectItemDataSource.count; i++) {
        oldCollectionInfoModel = self.selectItemDataSource[i];
        
        if ([oldCollectionInfoModel.spec_name isEqualToString:array.spec_name] ) {
            
            break;
        }
    }
    
    
    if ([oldCollectionInfoModel.contentString isEqualToString:stringModel.spec_name_value]) {
        
        cell.backgroundColor = self.itemSelectBackColor;
        cell.titleLabel.textColor = self.selectTextColor;
        stringModel.isOnClick = YES;
    }else
    {
        cell.backgroundColor = self.itemBackageColor;
        cell.titleLabel.textColor = self.textColor;
    }
    
    if (stringModel.product_id) {
        
        if ([stringModel.store integerValue] > 0) {
            
        }else
        {
            //无库存。
            cell.backgroundColor = self.itemBackageColor;
            cell.titleLabel.textColor = self.unSelectColor;
            stringModel.isOnClick = NO;
            if ([oldCollectionInfoModel.contentString isEqualToString:stringModel.spec_name_value])
            {
                [self.selectItemDataSource removeObject:oldCollectionInfoModel];
            }
            
        }
        
    }
    
    
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMSelectShopCollectionViewItem *cell = (FMSelectShopCollectionViewItem *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    FMShopSpecStringModel * array = self.dataSource[indexPath.section];
    FMSpecStringModel * stringModel = array.styleStrings[indexPath.item];
    
    
    //无库存，不能点击
    if (stringModel.product_id) {
        if ([stringModel.store integerValue] <= 0) {
            return;
        }
        
    }
    
    
    
    //先将颜色取反
    
    if (CGColorEqualToColor(cell.backgroundColor.CGColor, self.itemBackageColor.CGColor))
    {
        //NSLog(@"颜色相同");  为普通背景色
        cell.backgroundColor = self.itemSelectBackColor;
        
        
    }
    else
    {
        //NSLog(@"颜色不同");  为选中背景色
        cell.backgroundColor = self.itemBackageColor;
        
    }
    
    
    FMShopCollectionInfoModel * oldCollectionInfoModel;
    for (NSInteger i = 0; i < self.selectItemDataSource.count; i++) {
        FMShopCollectionInfoModel *linshi = self.selectItemDataSource[i];
        
        if ([linshi.spec_name  isEqualToString:array.spec_name]) {
            oldCollectionInfoModel = linshi;
            break;
        }
    }
    
    
    if (!oldCollectionInfoModel) {
        
        FMShopCollectionInfoModel * index = [[FMShopCollectionInfoModel alloc]init];
        
        index.contentString = stringModel.spec_name_value;
        index.spec_name = array.spec_name;
        index.indexPath = indexPath;
        
        [self.selectItemDataSource addObject:index];
        
        
    }else if(![oldCollectionInfoModel.contentString isEqualToString:stringModel.spec_name_value])
    {
        [self changeOldItemWithIndexPath:oldCollectionInfoModel.indexPath];
        [self.selectItemDataSource removeObject:oldCollectionInfoModel];
        
        
        FMShopCollectionInfoModel * index = [[FMShopCollectionInfoModel alloc]init];
        index.contentString = stringModel.spec_name_value;
        index.indexPath = indexPath;
        index.spec_name = array.spec_name;
        
        
        [self.selectItemDataSource addObject:index];
        
    }else
    {
        //点击同一个
        [self.selectItemDataSource removeObject:oldCollectionInfoModel];
    }
    
    
    if (self.shopSpecPro) {
        self.shopSpecPro(self.selectItemDataSource);
    }
    
    
    
}

-(void)changeModelDataSource:(NSArray *)dataSource;
{
    if (self.showCountType == FMSelectShopCollectionViewTypeShowCount) {
        FMShopSpecStringModel * countModel = [[FMShopSpecStringModel alloc]init];
        countModel.spec_name = @"购买数量";
        countModel.styleStrings = nil;
        countModel.isShowCountView = YES;
        NSMutableArray * array = [NSMutableArray arrayWithArray:dataSource];
        [array addObject:countModel];
        self.dataSource = [array mutableCopy];
    }else
    {
        self.dataSource = [dataSource mutableCopy];;
    }
    
    
    [self.myCollectionView reloadData];
}

-(void)changeOldItemWithIndexPath:(NSIndexPath *)indexPath
{
    FMSelectShopCollectionViewItem *cell = (FMSelectShopCollectionViewItem *)[self.myCollectionView cellForItemAtIndexPath:indexPath];
    //先将颜色取反
    
    if (CGColorEqualToColor(cell.backgroundColor.CGColor, self.itemBackageColor.CGColor))
    {
        //NSLog(@"颜色相同");  为普通背景色
        cell.backgroundColor = self.itemSelectBackColor;
        
        
    }
    else
    {
        //NSLog(@"颜色不同");  为选中背景色
        cell.backgroundColor = self.itemBackageColor;
        
    }
    
}


//设置头尾部内容

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableView =nil;
    
    if (kind ==UICollectionElementKindSectionHeader) {
        
        //定制头部视图的内容
        FMShopSpecStringModel * array = self.dataSource[indexPath.section];
        FMSelectShopCollectionReusableView *headerV = (FMSelectShopCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIHeaderdentifier forIndexPath:indexPath];
        
        headerV.currentCount = [NSString stringWithFormat:@"%zi",self.selectStore];
        headerV.maxCount = self.currentStore;
        __weak __typeof(&*self)weakSelf = self;
        headerV.selectShopCount = ^(NSInteger shopCount){
            [weakSelf changeSelectShopCount:shopCount];
        };
        headerV.titleShopLabel.text = array.spec_name;
        headerV.isShowAddView = array.isShowCountView;
        reusableView = headerV;
        
    }
    
    
    return reusableView;
    
}
-(void)changeSelectShopCount:(NSInteger)shopCount
{
    self.selectStore = shopCount;
    if (self.selectCountBlock) {
        self.selectCountBlock(shopCount);
    }
}





-(UIColor *)itemBackageColor
{
    if (!_itemBackageColor) {
        _itemBackageColor = [HXColor colorWithHexString:@"#e5e9f2"];
    }
    return _itemBackageColor;
}
-(UIColor *)itemSelectBackColor
{
    if (!_itemSelectBackColor) {
        _itemSelectBackColor = [HXColor colorWithHexString:@"#ff6633"];
    }
    return _itemSelectBackColor;
}
-(UIColor *)textColor
{
    
    if (!_textColor) {
        _textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    }
    return _textColor;
    
}

-(UIColor *)selectTextColor
{
    if (!_selectTextColor) {
        _selectTextColor = [UIColor whiteColor];
    }
    return _selectTextColor;
}

-(UIColor *)unSelectColor
{
    if (!_unSelectColor) {
        _unSelectColor = [HXColor colorWithHexString:@"#999999"];
    }
    return _unSelectColor;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
}


@end
