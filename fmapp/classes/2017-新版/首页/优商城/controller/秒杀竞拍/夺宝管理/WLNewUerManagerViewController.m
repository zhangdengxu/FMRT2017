//
//  WLNewUerManagerViewController.m
//  fmapp
//
//  Created by 秦秦文龙 on 16/10/31.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "WLNewUerManagerViewController.h"

@interface WLNewUerManagerViewController ()

@end
/**
 *规则二
 */
@implementation WLNewUerManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavTitle:@"用户管理"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createContentView];
}

-(void)createContentView{
    
    UIScrollView *backView = [[UIScrollView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.showsVerticalScrollIndicator = NO;
    backView.showsHorizontalScrollIndicator = NO;
    if (KProjectScreenWidth>380) {
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,1350);
        
    }else if (KProjectScreenWidth<330){
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,1580);
        
    }else{
        
        backView.contentSize = CGSizeMake(KProjectScreenWidth-50,1420);
        
    }
    [self.view addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    NSString *content = @"\n1.用户ID\n\n用户首次登陆全民夺宝时，全民夺宝自动绑定融托金融账户ID，并会为每位用户生成一个专属数字ID，作为其使用全民夺宝服务的唯一身份标识，用户需要对其账户项下发生的所有行为负责。\n\n2.用户应当在使用全民夺宝时完善个人资料，包括但不限于个人手机号码或收货地址等，并保证个人资料的真实、完整、合法有效并及时更新，如注册资料有变动，应及时更新其注册资料。如果用户提供的个人资料不合法、不真实、不准确、不详尽的，用户需承担因此引起的相应责任及后果。\n\n3.夺宝币\n\n（1）夺宝币的获得，如下--\n ①注册成功即可获得5枚夺宝币；\n ②融米积分兑换100：1，即原有100积分，可兑换1枚夺宝币；\n ③注资活动专标，每充值1000元，送一枚夺宝币，单次存入上线10币；\n ④转发活动页或邀请好友注册成功，并开通汇付，均可抽取5-10积分，最高获得夺宝币1枚，转发每天限领3次，邀请好友次数不限；\n ⑤除此之外可以通过购买的方式获得夺宝币，1元兑换1枚，微信支付宝均可支付。夺宝币的有效期自获赠之日起算90天。前述有效期不可中断或延期，有效期届满后，用户账户中有效期届满的夺宝币将被清空，且不可恢复。\n\n（2）夺宝币必须通过融托金融提供或认可的平台获得，从非融托金融提供或认可的平台所获得的夺宝币将被认定为来源不符合本服务协议，融托金融有权拒绝从非融托金融提供或认可的平台所获得的夺宝币在全民夺宝中使用。\n\n（3）夺宝币不能用于理财产品或兑换其它收费服务或者转移给其他用户。\n\n4、用户应当保证在使用全民夺宝的过程中遵守诚实信用原则，不扰乱全民夺宝的正常秩序，不得通过使用他人账户、一人注册多个账户、使用程序自动处理等非法方式损害他人或融托金融的利益。\n\n5、若用户存在任何违法或违反本服务协议约定的行为，融托金融有权视用户的违法或违规情况适用以下一项或多项处罚措施：\n\n （1）责令用户改正违法或违规行为；\n （2）中止、终止部分或全部服务；\n （3）取消用户夺宝订单并取消奖品发放（若用户已获得奖品），且用户已获得的夺宝币不予退回；\n （4）冻结或注销用户账号及其账号中的夺宝币（如有）；\n （5）其他融托金融认为合适在符合法律法规规定的情况下的处罚措施。若用户的行为造成融托公司及其关联公司损失的，用户还应承担赔偿责任。\n\n\n6、若用户发表侵犯他人权利或违反法律规定的言论，融托金融有权停止传输并删除其言论、禁止该用户发言、注销用户帐号及其帐号中的夺宝币（如有），同时，融托金融保留根据国家法律法规、相关政策向有关机关报告的权利。";
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
