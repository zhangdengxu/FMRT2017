//
//  FMRegisterBankView.m
//  fmapp
//
//  Created by runzhiqiu on 2017/5/11.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRegisterBankView.h"
#import "FMBankCardAndNumberTableViewCell.h"


@interface FMRegisterBankView ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIView * backGroundButton;
@property (nonatomic, strong) UIView  * whiteViewContent;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation FMRegisterBankView


static NSString * flagBankCardTableViewCell = @"flagBankCardTableViewCell";


-(void)removeAllViewFromSuperView
{
    [self removeFromSuperview];
}
-(void)backGroundButtonOnClick:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

-(UIView *)backGroundButton
{
    if (!_backGroundButton) {
        _backGroundButton = [[UIView alloc]init];
        _backGroundButton.userInteractionEnabled = YES;
        
        _backGroundButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundButtonOnClick:)];
        [_backGroundButton addGestureRecognizer:tapGesture];
        

    }
    return _backGroundButton;
}
- (instancetype)initWithArray:(NSArray *)dataSource;
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KProjectScreenWidth, KProjectScreenHeight);
        
        UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
       
        
        [self addSubview:self.backGroundButton];
        [self.backGroundButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        NSMutableArray * dataSelfData = [NSMutableArray array];
        for (RegisterBankViewModel * model in dataSource) {
            FMBankCardAndNumberModel * model2 = [[FMBankCardAndNumberModel alloc]init];
            model2.leftTitleString = model.bankName;
            model2.rightTitleString = model.cashAmt;
            [dataSelfData addObject:model2];
        }
        
        self.dataSource = dataSelfData;
        
        UIView * whiteViewContent = [[UIView alloc]init];
        whiteViewContent.layer.cornerRadius = 7.0;
        whiteViewContent.layer.masksToBounds = YES;
        whiteViewContent.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteViewContent];
        [whiteViewContent makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(35);
            make.right.equalTo(self.mas_right).offset(-35);
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY).offset(-30);
            make.height.equalTo(self.height).multipliedBy(0.68);
            

        }];
        
        
        UIView * lineBlueView1 = [[UIView alloc]init];
        lineBlueView1.backgroundColor = [HXColor colorWithHexString:@"#0f5ed2"];
        [whiteViewContent addSubview:lineBlueView1];
        
        
        
        UIView * lineBlueView2 = [[UIView alloc]init];
        lineBlueView2.backgroundColor = [HXColor colorWithHexString:@"#0f5ed2"];
        [whiteViewContent addSubview:lineBlueView2];
        
        
        UILabel * middleLabel = [[UILabel alloc]init];
        middleLabel.text = @"推荐银行";
        middleLabel.textColor = [UIColor colorWithHexString:@"#0f5ed2"];
        middleLabel.font = [UIFont systemFontOfSize:18];
        [whiteViewContent addSubview:middleLabel];
        
        [middleLabel makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(whiteViewContent.mas_centerX);
            make.top.equalTo(whiteViewContent.mas_top).offset(30);
            
        }];
        
        
        [lineBlueView1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteViewContent.mas_left).offset(20);
            make.right.equalTo(middleLabel.mas_left).offset(-20);
            make.centerY.equalTo(middleLabel.mas_centerY);
            make.height.equalTo(@1);
            
        }];
        [lineBlueView2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(middleLabel.mas_right).offset(20);
            make.right.equalTo(whiteViewContent.mas_right).offset(-20);
            make.centerY.equalTo(middleLabel.mas_centerY);
            make.height.equalTo(@1);
        }];
        
        if (self.dataSource.count > 0) {
            UIView * headerView = [[UIView alloc]init];
            headerView.backgroundColor = [UIColor whiteColor];
            [whiteViewContent addSubview:headerView];
            [headerView makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(middleLabel.mas_bottom).offset(7);
                make.centerX.equalTo(whiteViewContent.mas_centerX);
                make.height.equalTo(@30);
                make.width.equalTo(whiteViewContent.mas_width);
                
            }];
            
            
            UILabel * leftTitleView = [[UILabel alloc]init];
            leftTitleView.text = @"渠道银行";
            leftTitleView.font = [UIFont systemFontOfSize:15];
            leftTitleView.textColor = [UIColor blackColor];
            leftTitleView.textAlignment = NSTextAlignmentCenter;
            
            UILabel * rightTitleView = [[UILabel alloc]init];
            rightTitleView.text = @"单笔/每日";
            rightTitleView.font = [UIFont systemFontOfSize:15];
            rightTitleView.textColor = [UIColor blackColor];
            rightTitleView.textAlignment = NSTextAlignmentCenter;
            
            [headerView addSubview:leftTitleView];
            [headerView addSubview:rightTitleView];
            
            [leftTitleView makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headerView.mas_centerX);
                make.left.equalTo(headerView.mas_left).offset(20);
                make.centerY.equalTo(headerView.mas_centerY);
            }];
            
            
            [rightTitleView makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headerView.mas_right).offset(-20);
                make.left.equalTo(headerView.mas_centerX);
                make.centerY.equalTo(headerView.mas_centerY);
            }];
            
            
            
            
            UITableView * tableView = [[UITableView alloc]init];
            [tableView registerClass:[FMBankCardAndNumberTableViewCell class] forCellReuseIdentifier:flagBankCardTableViewCell];
            tableView.delegate = self;
            tableView.dataSource = self;
            [whiteViewContent addSubview:tableView];
            self.tableView = tableView;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(whiteViewContent.mas_left).offset(20);
                make.right.equalTo(whiteViewContent.mas_right).offset(-20);
                make.top.equalTo(headerView.mas_bottom).offset(5);
                make.bottom.equalTo(whiteViewContent.mas_bottom).offset(-10);
            }];

        }else
        {
            
            UILabel * middleNoDate = [[UILabel alloc]init];
            middleNoDate.text = @"暂无数据";
            middleNoDate.font = [UIFont systemFontOfSize:18];
            middleNoDate.textColor = [HXColor colorWithHexString:@"#999999"];
            middleNoDate.textAlignment = NSTextAlignmentCenter;
            [whiteViewContent addSubview:middleNoDate];
            [middleNoDate makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(whiteViewContent);
            }];
            
        }
        
        
        
        
        
        UIButton * bottomButtonClose = [[UIButton alloc]init];
        [bottomButtonClose setImage:[UIImage imageNamed:@"微商_注册:取现_关闭"] forState:UIControlStateNormal];
        [bottomButtonClose addTarget:self action:@selector(bottomButtonCloseOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:bottomButtonClose];
        
        [bottomButtonClose makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(whiteViewContent.mas_bottom).offset(45);
        }];
        
    }
    return self;
}
-(void)bottomButtonCloseOnClick:(UIButton *)bottom
{
    [self removeFromSuperview];
}


+(instancetype)getRegisterBankViewWithDataSource:(NSArray *)dataSource;
{
    FMRegisterBankView * bankView = [[FMRegisterBankView alloc]initWithArray:dataSource];
    
    
    return bankView;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FMBankCardAndNumberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:flagBankCardTableViewCell forIndexPath:indexPath];
    cell.cardModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@implementation RegisterBankViewModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        NSString * cardString = (NSString *)value;
        if ([cardString isMemberOfClass:[NSString class]]) {
            self.cardNO = cardString;
        }
    }
}

@end

