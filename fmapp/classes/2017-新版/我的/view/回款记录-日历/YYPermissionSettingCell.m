//
//  YYPermissionSettingCell.m
//  fmapp
//
//  Created by yushibo on 2017/3/2.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "YYPermissionSettingCell.h"
#import "YYNumberPermissionCell.h"
#import "YYPermissionSettingModel.h"
static NSString *YYNumberPermissionCellID = @"YYNumberPermissionCell";

@interface YYPermissionSettingCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionDataSource;
@end
@implementation YYPermissionSettingCell

#pragma mark --  懒加载
-(NSMutableArray *)collectionDataSource{

    if (!_collectionDataSource) {
        _collectionDataSource = [NSMutableArray array];
    }
    return _collectionDataSource;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
    }
    return self;
}
- (void)createContentView{
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"设置推荐权限:";
//    leftLabel.backgroundColor = [UIColor redColor];
    leftLabel.font = [UIFont systemFontOfSize:19];
    leftLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(10);
//        make.width.equalTo(80);
        
    }];
    
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewLayout.itemSize = CGSizeMake(60, 25);
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(18, 0, 0, 10);
    collectionViewLayout.minimumLineSpacing = 30;
    collectionViewLayout.minimumInteritemSpacing = 20;
    
    /**  创建 UICollectionView  */
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    [collectionView registerClass:[YYNumberPermissionCell class] forCellWithReuseIdentifier:YYNumberPermissionCellID];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    collectionView.backgroundColor = [HXColor colorWithHexString:@"#ffffff"];
//    collectionView.backgroundColor = [UIColor redColor];

    [self.contentView addSubview:collectionView];
    
    [collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLabel.mas_right).offset(20);
        
        if (KProjectScreenWidth >= 414) {
           
            make.right.equalTo(self.contentView.mas_right).offset(-70);
        }else if (KProjectScreenWidth >= 375){
            
            make.right.equalTo(self.contentView.mas_right).offset(-40);
        }else{
            
            make.right.equalTo(self.contentView.mas_right);
        }
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(60);
    }];

    

}

#pragma mark --  UICollectionView 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count) {

    return self.dataSource.count;
    }else{
    
        return 0;
    }
}

#pragma mark --  UICollectionView 代理方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YYNumberPermissionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YYNumberPermissionCellID forIndexPath:indexPath];
    if (self.collectionDataSource.count) {
        
        cell.dataItem = self.collectionDataSource[indexPath.row];
    }

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{    
    /**  点击 修改模型数据 */
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i < self.dataSource.count; i++) {
        
        YYPermissionSettingModel *model = self.collectionDataSource[i];
        if (i == indexPath.row) {
            
            model.selectedState = YES;
        }else{
        
            model.selectedState = NO;
        }
        
        
        [tempArray addObject:model];

    }
    self.collectionDataSource = tempArray;
    [self.collectionView reloadData];
    
    if (self.modelBlock) {
        
        self.modelBlock([self.collectionDataSource[indexPath.row] title]);
    }
}

-(void)setDataSource:(NSArray *)dataSource{

    _dataSource = dataSource;
    
    if (self.dataSource.count) {

        /**  更新 UICollectionView 高度 */

        [self.collectionView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo((int)ceilf(self.dataSource.count / 2) * 60);
        }];
        
        /**  保存模型数据 */
        for (int i=0; i < self.dataSource.count; i++) {
            if (i == 0) {
                
                YYPermissionSettingModel *model = [[YYPermissionSettingModel alloc]initWithArray:[NSString stringWithFormat:@"%@", [dataSource objectAtIndex:i]] selectedState:YES];
                [self.collectionDataSource addObject:model];
            }else{
                
                YYPermissionSettingModel *model = [[YYPermissionSettingModel alloc]initWithArray:[NSString stringWithFormat:@"%@", [dataSource objectAtIndex:i]] selectedState:NO];
                [self.collectionDataSource addObject:model];
            }
        }
    }
    
    [self.collectionView reloadData];
}

@end
