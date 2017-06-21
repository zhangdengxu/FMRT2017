//
//  FMSelectKillShopCollectionView.m
//  fmapp
//
//  Created by runzhiqiu on 16/8/22.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMSelectKillShopCollectionView.h"

#import "FMSelectShopCollectionViewFlowlayout.h"
#import "FMSelectShopCollectionViewItem.h"
#import "FMSelectShopCollectionReusableView.h"

#import "FMShopSpecModel.h"

@interface FMSelectKillShopCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * myCollectionView;

@property (nonatomic, strong) UIColor * itemBackageColor,*itemSelectBackColor,*textColor,*selectTextColor,*unSelectColor;

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * modelDataSource;

@property (nonatomic, assign) CGFloat itemCornerRadio;
@property (nonatomic, strong) NSMutableArray * selectItemDataSource;
@property (nonatomic, strong) FMSelectShopInfoModel * selectModel;



@end

@implementation FMSelectKillShopCollectionView


static NSString * const reuseIdentifier = @"FMSelectShopCollectionViewItem";
static NSString * const reuseIHeaderdentifier = @"tagHeaderListViewItemId";


-(FMSelectShopInfoModel *)selectModel
{
    if (!_selectModel) {
        _selectModel = [[FMSelectShopInfoModel alloc]init];
        _selectModel.selectCount = 1;
        _selectModel.isAllShopInfo = NO;
    }
    return _selectModel;
}

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

//-(UICollectionView *)myCollectionView
//{
//    if (!_myCollectionView) {
//        
//        FMSelectShopCollectionViewFlowlayout * flowLayout = [[FMSelectShopCollectionViewFlowlayout alloc]initWithContentArray:self.dataSource];
//        
//        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:flowLayout];
//        
//        
//        _myCollectionView.delegate = self;
//        _myCollectionView.dataSource = self;
//        _myCollectionView.showsHorizontalScrollIndicator = NO;
//        _myCollectionView.showsVerticalScrollIndicator = NO;
//        [_myCollectionView registerClass:[FMSelectShopCollectionViewItem class] forCellWithReuseIdentifier:reuseIdentifier];
//        [_myCollectionView registerClass:[FMSelectShopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIHeaderdentifier];
//        
//        [self addSubview:_myCollectionView];
//        
//    }
//    return _myCollectionView;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

-(void)createCollectionView
{
    FMSelectShopCollectionViewFlowlayout * flowLayout = [[FMSelectShopCollectionViewFlowlayout alloc]initWithContentArray:self.dataSource];
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:flowLayout];
    
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    [self.myCollectionView registerClass:[FMSelectShopCollectionViewItem class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.myCollectionView registerClass:[FMSelectShopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIHeaderdentifier];
    
    [self addSubview:self.myCollectionView];
}

- (void)setcollectionViewDataSource:(NSArray *)dataSource WithModelDataSource:(NSArray *)modelDataSource WithSelectModel:(FMSelectShopInfoModel *)selectModel WithCreateNew:(BOOL)isCreate;
{
    _selectModel = selectModel;
    
    
    self.selectItemDataSource = [NSMutableArray arrayWithArray:selectModel.locationArray];
    if (self.showCountType == FMSelectShopCollectionViewTypeShowCount) {
        FMShopSpecStringModel * countModel = [[FMShopSpecStringModel alloc]init];
        countModel.spec_name = @"购买数量";
        countModel.styleStrings = nil;
        countModel.isShowCountView = YES;
        NSMutableArray * array = [NSMutableArray arrayWithArray:dataSource];
        [array addObject:countModel];
        self.dataSource = array;
    }else
    {
        self.dataSource = dataSource;
    }
    
    if (isCreate) {
        [self createCollectionView];
    }
    
    self.modelDataSource = modelDataSource;
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
    
    CGRect frame = [array.styleStrings[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMShopSpecStringModel * array = self.dataSource[indexPath.section];
    
    FMSelectShopCollectionViewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    FMShopSpecStringModel * shopSpecModel = self.dataSource[indexPath.section];
    
    //    FMShopSpecModel * shopSpec = self.modelDataSource[indexPath.section];
    //    FMSpecProductModel * specPro = shopSpec.goods[indexPath.item];
    cell.backgroundColor = self.itemBackageColor;
    
    
    FMShopCollectionInfoModel * oldCollectionInfoModel;
    for (NSInteger i = 0; i < self.selectItemDataSource.count; i++) {
        oldCollectionInfoModel = self.selectItemDataSource[i];
        
        if ([oldCollectionInfoModel.spec_name isEqualToString:shopSpecModel.spec_name] ) {
            
            break;
        }
    }
    
    NSString * showString = array.styleStrings[indexPath.item];
    cell.layer.cornerRadius = self.itemCornerRadio;
    cell.titleLabel.text = showString;
    
    NSString * currentString = shopSpecModel.styleStrings[indexPath.item];
    
    if ([shopSpecModel.spec_name isEqualToString: oldCollectionInfoModel.spec_name] && [currentString isEqualToString:oldCollectionInfoModel.contentString]  && oldCollectionInfoModel != nil) {
        cell.backgroundColor = self.itemSelectBackColor;
        cell.titleLabel.textColor = self.selectTextColor;
    }else{
        
        cell.backgroundColor = self.itemBackageColor;
        
        //        //改变选中状态
        //        if (specPro.store) {
        //            cell.backgroundColor = self.itemBackageColor;
        //        }else
        //        {
        //            cell.backgroundColor = self.unSelectColor;
        //        }
        
        
        cell.titleLabel.textColor = self.textColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMShopSpecModel * shopSpec = self.modelDataSource[indexPath.section];
    FMSpecProductModel * specPro = shopSpec.goods[indexPath.item];
    
    FMShopSpecStringModel * shopSpecString = self.dataSource[indexPath.section];
    NSString * currentString = shopSpecString.styleStrings[indexPath.item];
    
    //    if (!specPro.store) {
    //        return;
    //    }
    
    FMShopCollectionInfoModel * oldCollectionInfoModel;
    for (NSInteger i = 0; i < self.selectItemDataSource.count; i++) {
        FMShopCollectionInfoModel *linshi = self.selectItemDataSource[i];
        
        if ([linshi.spec_name  isEqualToString:shopSpec.spec_name]) {
            oldCollectionInfoModel = linshi;
            break;
        }
    }
    
    if (!oldCollectionInfoModel) {
        
        FMShopCollectionInfoModel * index = [[FMShopCollectionInfoModel alloc]init];
        index.indexPath = indexPath;
        index.contentString = currentString;
        index.spec_name = shopSpec.spec_name;
        
        [self.selectItemDataSource addObject:index];
        [self clickItemWithIndexPath:index.indexPath];
        
        
    }else if(![oldCollectionInfoModel.contentString isEqualToString:currentString])
    {
        [self changeOldItemWithIndexPath:oldCollectionInfoModel.indexPath];
        [self.selectItemDataSource removeObject:oldCollectionInfoModel];
        
        
        FMShopCollectionInfoModel * index = [[FMShopCollectionInfoModel alloc]init];
        index.contentString = currentString;
        index.indexPath = indexPath;
        index.spec_name = shopSpec.spec_name;
        
        
        [self.selectItemDataSource addObject:index];
        [self clickItemWithIndexPath:index.indexPath];
        
    }else
    {
        return;
    }
    
    if (self.selectItemDataSource.count <= self.modelDataSource.count ) {
        
        NSMutableString * selectString = [NSMutableString string];
        for (FMShopCollectionInfoModel * collectionInfoModel in self.selectItemDataSource) {
            //            FMShopSpecStringModel * shopSpecString = self.dataSource[collectionInfoModel.indexPath.section];
            
            //            NSString * linshiString = collectionInfoModel.contentString;
            [selectString appendString:collectionInfoModel.spec_name];
            [selectString appendString:@":"];
            [selectString appendString:collectionInfoModel.contentString];
            [selectString appendString:@"   "];
            
            
            
            
        }
        
        //        if (!specPro.product_id) {
        //            return;
        //        }
        
        
        
        self.selectModel.product_id = specPro.product_id;
        self.selectModel.locationArray = self.selectItemDataSource;
        self.selectModel.currentStyle = selectString;
        
        
        if (self.selectItemDataSource.count == self.modelDataSource.count) {
            self.selectModel.isAllShopInfo = YES;
        }else{
            self.selectModel.isAllShopInfo = NO;
            
            NSMutableArray * titleArray = [NSMutableArray array];
            for (FMShopSpecStringModel * stringModel in self.dataSource) {
                
                BOOL isSave = NO;
                for (FMShopCollectionInfoModel * collectionInfoModel in self.selectItemDataSource) {
                    
                    if ([stringModel.spec_name isEqualToString:collectionInfoModel.spec_name]) {
                        isSave = YES;
                    }
                }
                if (!isSave) {
                    [titleArray addObject:stringModel.spec_name];
                }
                
                
            }
            
            
            if (titleArray.count > 0) {
                self.selectModel.unselectInfo = [NSString stringWithFormat:@"请选择: %@",titleArray[0]];
            }
        }
        if (self.shopSpecPro) {
            self.shopSpecPro(self.selectModel);
        }
        
    }
    
}

-(void)changeModelDataSource:(NSArray *)modelDataSource;
{
    self.modelDataSource = modelDataSource;
}

-(void)changeOldItemWithIndexPath:(NSIndexPath *)indexPath
{
    FMSelectShopCollectionViewItem *cell = (FMSelectShopCollectionViewItem *)[self.myCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = self.itemBackageColor;
    cell.titleLabel.textColor = self.textColor;
}
-(void)clickItemWithIndexPath:(NSIndexPath *)indexPath
{
    
    FMSelectShopCollectionViewItem *cell = (FMSelectShopCollectionViewItem *)[self.myCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = self.itemSelectBackColor;
    cell.titleLabel.textColor = self.selectTextColor;
}



//设置头尾部内容

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableView =nil;
    
    if (kind ==UICollectionElementKindSectionHeader) {
        
        //定制头部视图的内容
        FMShopSpecStringModel * array = self.dataSource[indexPath.section];
        FMSelectShopCollectionReusableView *headerV = (FMSelectShopCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIHeaderdentifier forIndexPath:indexPath];
        
        headerV.currentCount = [NSString stringWithFormat:@"%zi",self.selectModel.selectCount];
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
    self.selectModel.selectCount = shopCount;
}

-(void)reloadCollectionView;
{
    [self.myCollectionView reloadData];
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
        _unSelectColor = [UIColor colorWithWhite:0.75 alpha:1];
    }
    return _unSelectColor;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
}
-(void)setModelDataSource:(NSArray *)modelDataSource
{
    _modelDataSource = modelDataSource;
}


@end
