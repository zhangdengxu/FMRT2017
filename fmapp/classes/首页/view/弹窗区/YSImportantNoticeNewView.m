//
//  YSImportantNoticeNewView.m
//  fmapp
//
//  Created by yushibo on 2016/9/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSImportantNoticeNewView.h"

#import "YSImportantNoticeCell.h"
#import "YSImportantNoticeTitleCell.h"
#import "YSImportantNoticeFooterCell.h"
@interface YSImportantNoticeNewView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *chengweiLabel;

@end

@implementation YSImportantNoticeNewView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createContentView];
    }
    return self;
    
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}
- (void)setImportantNoticeModel:(YSImportantNoticeModel *)ImportantNoticeModel{
    _ImportantNoticeModel = ImportantNoticeModel;
    self.dataSource = [ImportantNoticeModel.neirong copy];
    [_tableView reloadData];
}
- (void)createContentView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.mas_top).offset(KProjectScreenHeight / 10);
        make.bottom.equalTo(self.mas_bottom).offset(-(KProjectScreenHeight / 9));
    }];
    
    UIButton *knowBtn = [[UIButton alloc]init];
    //  knowBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#0159D5"];
    knowBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [knowBtn setTitleColor:[UIColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
    [knowBtn addTarget:self action:@selector(knowAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:knowBtn];
    [knowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(backView.mas_bottom);
        make.height.equalTo( (KProjectScreenWidth * 350) / 972 / 2);
    }];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [UIColor grayColor];
    [backView addSubview:lineV];
    [lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(knowBtn.mas_top);
        make.height.equalTo(@1);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //   self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [backView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(backView.mas_top);
        make.bottom.equalTo(lineV.mas_top);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    return self.dataSource.count;
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
            static NSString *ID1 = @"YSImportantNoticeTitleCell";
            YSImportantNoticeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
            if (cell == nil) {
                cell = [[YSImportantNoticeTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            }
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor orangeColor];
            if (self.ImportantNoticeModel.title && self.ImportantNoticeModel.chengwei) {
                cell.statu1 = self.ImportantNoticeModel.title;
                cell.statu2 = self.ImportantNoticeModel.chengwei;

            }
        return cell;
 
    }else if (indexPath.row == 1) {
        
        static NSString *ID2 = @"YSImportantNoticeCell";
        YSImportantNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (cell == nil) {
            cell = [[YSImportantNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
        }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor redColor];
        if (self.dataSource.count) {
            cell.status = self.dataSource;
        }
        return cell;

    }else  if (indexPath.row == 2) {
        
        static NSString *ID3 = @"YSImportantNoticeFooterCell";
        YSImportantNoticeFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID3];
        if (cell == nil) {
            cell = [[YSImportantNoticeFooterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID3];
        }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor redColor];
        if (self.ImportantNoticeModel.author && self.ImportantNoticeModel.date) {
            cell.authorStatu = self.ImportantNoticeModel.author;
            cell.dateStatu = self.ImportantNoticeModel.date;
        }
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIImageView *imageV = [[UIImageView alloc]init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.ImportantNoticeModel.pic]];
    return imageV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return ((KProjectScreenWidth * 350) /972);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        CGFloat titleW = KProjectScreenWidth - 130;
        CGSize titleMaxSize = CGSizeMake(titleW, MAXFLOAT);
        NSDictionary *titleAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGFloat titleH = [ [NSString stringWithFormat:@"%@", self.ImportantNoticeModel.title] boundingRectWithSize:titleMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrs context:nil].size.height;
        
        CGFloat chengweiW = KProjectScreenWidth - 110;
        CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
        NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGFloat chengweiH = [ [NSString stringWithFormat:@"%@", self.ImportantNoticeModel.chengwei] boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
        return titleH + chengweiH + 30 + 20 ;
        
    }
    if (indexPath.row == 1) {
        
        NSString *content = [NSString string];

        for (int i = 0; i < [self.dataSource count] ; i++) {

            if (i == 0) {
                content =[NSString stringWithFormat:@"        %@", self.dataSource[i]];
            }else{
                content =[NSString stringWithFormat:@"%@/n/n        %@",content, self.dataSource[i]];
            }
            
        }
//        content = @"打开就看懂巨款是没看电视看vc没贷款率赌命烤串撒旦了妈的了马克思领导们 麦迪时刻拉麻烦考虑到是麻烦考了多少穆克拉麻烦 莫德凯撒两方面的顺口溜麻烦速度快了父母的斯科拉没电了萨没法打了是模仿考了多少麻烦快点拉萨马上到可拉伸到昆明路\n扫防静电咳嗽安静的口水金佛看电视剧空大\n单家三口放大镜看撒娇反倒是咖啡机的顺口溜方\n";
        CGFloat textW = KProjectScreenWidth - 110;
        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
        NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGFloat textH = [content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
        NSLog(@"******%f*****%ld", textH, (long)indexPath.row);
        return textH;
        
        return [YSImportantNoticeCell hightForCellWithModel:content];
    }
    if (indexPath.row == 2) {
        
        CGFloat authorW = KProjectScreenWidth - 130;
        CGSize authorMaxSize = CGSizeMake(authorW, MAXFLOAT);
        NSDictionary *authorAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGFloat authorH = [ [NSString stringWithFormat:@"%@", self.ImportantNoticeModel.author] boundingRectWithSize:authorMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:authorAttrs context:nil].size.height;
        
        CGFloat dateW = KProjectScreenWidth - 110;
        CGSize dateMaxSize = CGSizeMake(dateW, MAXFLOAT);
        NSDictionary *dateAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGFloat dateH = [ [NSString stringWithFormat:@"%@", self.ImportantNoticeModel.date] boundingRectWithSize:dateMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dateAttrs context:nil].size.height;
        return authorH + dateH + 30 + 20;
    }
   
    return 0;
}
- (void)knowAction:(UIButton *)button{
    
    [self removeFromSuperview];
}
@end
