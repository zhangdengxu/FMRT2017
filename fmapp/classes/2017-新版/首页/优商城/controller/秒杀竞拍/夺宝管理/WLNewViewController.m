//
//  WLNewViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLNewViewController.h"

@interface WLNewViewController ()

@end
/**
 *规则三
 */
@implementation WLNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"全民夺宝的使用规则"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createContentView];
}

-(void)createContentView{
    
    UIScrollView *backView = [[UIScrollView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.showsVerticalScrollIndicator = NO;
    backView.showsHorizontalScrollIndicator = NO;
    if (KProjectScreenWidth>380) {
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,930);
        
    }else if (KProjectScreenWidth<330){
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,1100);
        
    }else{
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,950);
        
    }
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    NSString *content = @"\n1、释义\n\n （1）夺宝号码：指用户使用夺宝币参与全民夺宝服务时所获取的随机分配号码。\n\n （2）幸运号码：指与某件奖品的全部夺宝号码分配完毕后，全民夺宝根据夺宝规则（详见全民夺宝规则页）计算出的一个号码。持有该幸运号码的用户可直接获得该奖品。\n\n2、融托金融承诺遵循公开、公平、公正的原则运营全民夺宝，确保所有用户在全民夺宝中享受同等的权利与义务，中奖结果向所有用户公示。\n\n3、用户知悉，除本协议另有约定外，商品开奖后无论是否获得奖品，用户用于参与全民夺宝的夺宝币不能退回；其完全了解参与全民夺宝活动的存在的风险，融托金融不保证用户参与全民夺宝一定会获得奖品。\n\n4、用户需保证填写并提交收货地址准确无误，如因收货地址填写错误，用户因此行为造成的损失，融托金融不承担任何责任。\n\n5、用户通过参与全民夺宝获得的奖品，享受该奖品生产厂家提供的三包服务，具体三包规定以该奖品生产厂家公布的为准。\n\n6、如果下列情形发生，融托金融有权取消用户夺宝订单：\n\n （1）因不可抗力、全民夺宝系统发生故障或遭受第三方攻击，或发生其他融托金融无法控制的情形；\n\n （2）根据融托金融已经发布的或将来可能发布或更新的各类规则、公告的规定，融托金融有权取消用户订单的情形。\n融托金融有权取消用户订单后，用户可申请退还夺宝币，所退夺宝币将在3个工作日内退还至用户账户中。";
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, KProjectScreenWidth-40, [self heitForLabel:content])];
    firstLabel.font = [UIFont systemFontOfSize:15];
    [firstLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]];
    firstLabel.numberOfLines = 0;
    firstLabel.text = content;
    [backView addSubview:firstLabel];
    
}

-(CGFloat)heitForLabel:(NSString *)content{
    
    CGFloat chengweiW = KProjectScreenWidth - 40;
    CGSize chengweiMaxSize = CGSizeMake(chengweiW, MAXFLOAT);
    NSDictionary *chengweiAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGFloat chengweiH = [content boundingRectWithSize:chengweiMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:chengweiAttrs context:nil].size.height;
    return chengweiH;
}

@end
