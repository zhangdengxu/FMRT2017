//
//  YSImportantNoticeView.m
//  fmapp
//
//  Created by yushibo on 16/9/20.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "YSImportantNoticeView.h"

#import "YSImportantNoticeCell.h"
@interface YSImportantNoticeView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *chengweiLabel;



@end

@implementation YSImportantNoticeView

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self createContentView];
    }
    return self;
    
}

- (void)setImportantNoticeModel:(YSImportantNoticeModel *)ImportantNoticeModel{
    _ImportantNoticeModel = ImportantNoticeModel;
    self.dataSource = [ImportantNoticeModel.neirong copy];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:ImportantNoticeModel.pic]];
//    self.titleLabel.text = ImportantNoticeModel.title;
    self.titleLabel.text = @"接发大水看风景的空房间快递劫匪卡死了就爱看了发动机屎壳郎富家大室开了房就上课了打飞机的顺口溜富家大室可浪费就奥数傀儡风较大";

//    self.chengweiLabel.text = ImportantNoticeModel.chengwei;
    self.chengweiLabel.text = @"接发大水看风景的空房间快递劫匪卡死了就爱看了发动机屎壳郎富家大室开了房就上课了打飞机的顺口溜富家大室可浪费就奥数傀儡风较大";

    [self.tableView reloadData];
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
    
    UIImageView *imageV = [[UIImageView alloc]init];
    
    self.imageV = imageV;
    [backView addSubview:imageV];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(backView.mas_top);
        make.height.equalTo((KProjectScreenWidth * 350) /972);
    }];
    
    UIButton *knowBtn = [[UIButton alloc]init];
  //  knowBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#0159D5"];
    knowBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [knowBtn setTitleColor:[UIColor colorWithHexString:@"#0159D5"] forState:UIControlStateNormal];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
 //   self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = [self setUpTableHeaderView];

    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [backView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.top.equalTo(imageV.mas_bottom);
        make.bottom.equalTo(lineV.mas_top);
    }];

}
//- (CGRect)setUpTableHeaderViewFrame{
//}
- (UIView *)setUpTableHeaderView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor greenColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor grayColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
//        titleLabel.text = self.ImportantNoticeModel.title;
//    titleLabel.text = @"饭店开房呢四块浪费你屎壳郎饭你说达克罗宁发的啥夸得饭你说快递费你独守空房纳斯达克愤怒地说客服纳斯达克浪费你速度快愤怒地说客服";
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.equalTo(view.mas_top).offset(10);
        //        make.bottom.equalTo(view.mas_bottom).offset(-60);
    }];
    
    UILabel *chengweiLabel = [[UILabel alloc]init];
    chengweiLabel.textAlignment = NSTextAlignmentLeft;
    chengweiLabel.backgroundColor = [UIColor grayColor];
    chengweiLabel.numberOfLines = 0;
    self.chengweiLabel = chengweiLabel;
//        chengweiLabel.text = self.ImportantNoticeModel.chengwei;
//    chengweiLabel.text = @"和发动机的福克斯雷锋精神可浪费就但是看了飞机上都看到了富家大室看到了福建省的刻录机但是看了积分的可视对讲付款了三分就";
    chengweiLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    chengweiLabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:chengweiLabel];
    [chengweiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        //        make.bottom.equalTo(view.mas_bottom).offset(-60);
    }];
    
    CGFloat textW = KProjectScreenWidth - 110;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
    CGFloat textH = [ [NSString stringWithFormat:@"     %@", self.titleLabel.text] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    
    CGFloat chengweiW = KProjectScreenWidth - 110;
    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
    CGFloat chengweiH = [ [NSString stringWithFormat:@"     %@", self.chengweiLabel.text] boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
//    return textH + chengweiH + 30 + 20;
    view.frame = CGRectMake(0, 0, KProjectScreenWidth - 110, textH + chengweiH + 30 + 20 + 20);
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID1 = @"YSImportantNoticeCell";
    YSImportantNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (cell == nil) {
        cell = [[YSImportantNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
    }
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    if (self.dataSource.count) {
        cell.status = self.dataSource[indexPath.row];
    }

    
    return cell;
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor greenColor];
//    
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.backgroundColor = [UIColor grayColor];
//
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.numberOfLines = 0;
////    titleLabel.text = self.ImportantNoticeModel.title;
//    titleLabel.text = @"饭店开房呢四块浪费你屎壳郎饭你说达克罗宁发的啥夸得饭你说快递费你独守空房纳斯达克愤怒地说客服纳斯达克浪费你速度快愤怒地说客服";
//    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [view addSubview:titleLabel];
//    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left).offset(10);
//        make.right.equalTo(view.mas_right).offset(-10);
//        make.top.equalTo(view.mas_top).offset(10);
////        make.bottom.equalTo(view.mas_bottom).offset(-60);
//    }];
//    
//    UILabel *chengweiLabel = [[UILabel alloc]init];
//    chengweiLabel.textAlignment = NSTextAlignmentLeft;
//    chengweiLabel.backgroundColor = [UIColor grayColor];
//    chengweiLabel.numberOfLines = 0;
////    chengweiLabel.text = self.ImportantNoticeModel.chengwei;
//    chengweiLabel.text = @"和发动机的福克斯雷锋精神可浪费就但是看了飞机上都看到了富家大室看到了福建省的刻录机但是看了积分的可视对讲付款了三分就";
//    chengweiLabel.textColor = [UIColor colorWithHexString:@"#000000"];
//    chengweiLabel.font = [UIFont systemFontOfSize:20];
//    [view addSubview:chengweiLabel];
//    [chengweiLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left);
//        make.right.equalTo(view.mas_right);
//        make.top.equalTo(titleLabel.mas_bottom).offset(20);
//        //        make.bottom.equalTo(view.mas_bottom).offset(-60);
//    }];
//    return view;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor greenColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat textW = KProjectScreenWidth - 110;
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
    CGFloat textH = [ [NSString stringWithFormat:@"     %@", self.dataSource[indexPath.row]] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
    return textH + 20;
    
//    return [YSImportantNoticeCell hightForCellWithModel:self.dataSource[indexPath.row]];
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//        CGFloat textW = KProjectScreenWidth - 110;
//        CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
//        NSDictionary *textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
//        CGFloat textH = [ [NSString stringWithFormat:@"     %@", self.ImportantNoticeModel.title] boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
//    
//    CGFloat chengweiW = KProjectScreenWidth - 110;
//    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
//    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
//    CGFloat chengweiH = [ [NSString stringWithFormat:@"     %@", self.ImportantNoticeModel.chengwei] boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
//        return textH + chengweiH + 30 + 20;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 120;
}
@end
