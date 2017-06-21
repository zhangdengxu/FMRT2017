//
//  FMRTRankingCollectionViewCell.m
//  fmapp
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMRTRankingCollectionViewCell.h"
#import "FMRTAucModel.h"


@interface FMRTRankingCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation FMRTRankingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        [self createMainView];
    }
    return self;
}

- (UIImageView *)photoView {
    
    if (!_photoView) {
        
        _photoView = ({
            UIImageView *photoView = [[UIImageView alloc]init];
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.image = [UIImage imageNamed:@"竞拍幸运榜_03"];
            photoView;
        });
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableview= [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
            tableview.delegate=self;
            tableview.dataSource=self;
            tableview.scrollEnabled = NO;
            tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
            tableview;
        });
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

- (void)createMainView{
    
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(KProjectScreenWidth/2 - 75);
        make.height.equalTo((KProjectScreenWidth/2 - 70)*97 /167);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.photoView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.alertLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"FMRTLuckyRankViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    
    FMRankingModel *model = self.dataArr[indexPath.row];
    
    if ([model.phone length]>5) {
        NSMutableString *str = [[NSMutableString  alloc] initWithString:model.phone];
        [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row + 1, str];
    }

    cell.detailTextLabel.text = [NSString stringWithFormat:@"    %@",model.goods_name];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.textColor = [HXColor colorWithHexString:@"#1e1e1e"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.text = @"敬请期待";
        _alertLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.alertLabel];
    }
    return _alertLabel;
}

- (void)setModel:(FMRTAucFirstModel *)model{
    _model = model;

    if (model.phoneTitles.count!=0 && ![model.phoneTitles isKindOfClass:[NSNull class]]) {
        _dataArr = [model.phoneTitles copy];
        [self.tableView reloadData];
        self.alertLabel.hidden = YES;
    }else if (model.phoneTitles.count==0){
        self.alertLabel.hidden = NO;
    }

}

@end
