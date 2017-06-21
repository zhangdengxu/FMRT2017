//
//  CurrentUserInformation.m
//  F103CZFW
//
//  Created by 张利广 on 13-5-21.
//  Copyright (c) 2013年 zhang liguang. All rights reserved.
//
#import "LocalDataManagement.h"
#import "OpenUDID.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "JPUSHService.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "FMSettings.h"
#import "FMTabBarController.h"
#import "GestureViewController.h"
@interface CurrentUserInformation ()<UIAlertViewDelegate,NSCoding>

@end

@implementation CurrentUserInformation

//声明静态实例
static CurrentUserInformation       *userInfor = nil;

-(id)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.personName = [coder decodeObjectForKey:@"personName"];
        self.touxiangsde = [coder decodeObjectForKey:@"touxiangsde"];
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.vipbiaozhi = [coder decodeObjectForKey:@"vipbiaozhi"];
        self.vipzigefenxiang = [coder decodeObjectForKey:@"vipzigefenxiang"];
        self.usrcustid = [coder decodeObjectForKey:@"usrcustid"];
        self.vipzige = [coder decodeObjectForKey:@"vipzige"];
        self.shiming = [[coder decodeObjectForKey:@"shiming"] intValue];
        self.touxiang = [coder decodeObjectForKey:@"touxiang"];
        self.toubiaocishu = [coder decodeObjectForKey:@"toubiaocishu"];
        self.mobile = [coder decodeObjectForKey:@"mobile"];
        self.iszdtou = [coder decodeObjectForKey:@"iszdtou"];
        self.hfkai = [coder decodeObjectForKey:@"hfkai"];
        self.zhenshiname = [coder decodeObjectForKey:@"zhenshiname"];
        self.shenfenzhenghao = [coder decodeObjectForKey:@"shenfenzhenghao"];
        self.jymimafou = [coder decodeObjectForKey:@"jymimafou"];
        self.banbenhao = [coder decodeObjectForKey:@"banbenhao"];
        self.wenjuanxianshi = [coder decodeObjectForKey:@"wenjuanxianshi"];
        self.userLoginState = [[coder decodeObjectForKey:@"userLoginState"] integerValue];
        self.startTime = [coder decodeObjectForKey:@"startTime"];
        self.fengxianwenjuan = [coder decodeObjectForKey:@"fengxianwenjuan"];
        self.fengxianwenjuanwode = [coder decodeObjectForKey:@"fengxianwenjuanwode"];
        self.weishangbang = [coder decodeObjectForKey:@"weishangbang"];//1已绑定徽商0未绑定
        self.jiaoyimshezhi = [coder decodeObjectForKey:@"jiaoyimshezhi"];//1设置交易密码0未设置
        self.huishangshiming = [coder decodeObjectForKey:@"huishangshiming"];//徽商实名，开立徽商电子账户

        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.personName forKey:@"personName"];
    [aCoder encodeObject:self.touxiangsde forKey:@"touxiangsde"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.vipbiaozhi forKey:@"vipbiaozhi"];
    [aCoder encodeObject:self.vipzigefenxiang forKey:@"vipzigefenxiang"];
    [aCoder encodeObject:self.usrcustid forKey:@"usrcustid"];
    [aCoder encodeObject:self.vipzige forKey:@"vipzige"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.shiming] forKey:@"shiming"];
    [aCoder encodeObject:self.touxiang forKey:@"touxiang"];
    [aCoder encodeObject:self.toubiaocishu forKey:@"toubiaocishu"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.iszdtou forKey:@"iszdtou"];
    [aCoder encodeObject:self.hfkai forKey:@"hfkai"];
    [aCoder encodeObject:self.zhenshiname forKey:@"zhenshiname"];
    [aCoder encodeObject:self.shenfenzhenghao forKey:@"shenfenzhenghao"];
    [aCoder encodeObject:self.jymimafou forKey:@"jymimafou"];
    [aCoder encodeObject:self.banbenhao forKey:@"banbenhao"];
    [aCoder encodeObject:self.wenjuanxianshi forKey:@"wenjuanxianshi"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.userLoginState ]forKey:@"userLoginState"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.fengxianwenjuan forKey:@"fengxianwenjuan"];
    [aCoder encodeObject:self.fengxianwenjuanwode
                  forKey:@"fengxianwenjuanwode"];
    [aCoder encodeObject:self.weishangbang
                  forKey:@"weishangbang"];//1已绑定徽商0未绑定
    [aCoder encodeObject:self.jiaoyimshezhi
                  forKey:@"jiaoyimshezhi"];//1设置交易密码0未设置
    [aCoder encodeObject:self.huishangshiming
                  forKey:@"huishangshiming"];
    

    
    
}
/** 获取用户本地通用数据信息
 
 *
 *  @return paras 用户信息实体类，单例模式
 */
+(CurrentUserInformation *)sharedCurrentUserInfo{
    
    @synchronized(self){
        if (!userInfor) {
            userInfor = [[self alloc]init];
        }
    }
    return userInfor;
}
+(void)initializaionUserInformation:(NSDictionary *)userInfoDic
{
    
    Log(@"userData=%@",userInfoDic);
    CurrentUserInformation *currentUserInfo = [CurrentUserInformation sharedCurrentUserInfo];
    currentUserInfo.userName=StringForKeyInUnserializedJSONDic(userInfoDic, @"user_name");
    currentUserInfo.personName = StringForKeyInUnserializedJSONDic(userInfoDic, @"username");
    currentUserInfo.touxiangsde = StringForKeyInUnserializedJSONDic(userInfoDic, @"touxiangsde");
    currentUserInfo.userId=StringForKeyInUnserializedJSONDic(userInfoDic, @"user_id");
    currentUserInfo.vipzigefenxiang=StringForKeyInUnserializedJSONDic(userInfoDic, @"vipzigefenxiang");
    currentUserInfo.vipbiaozhi=StringForKeyInUnserializedJSONDic(userInfoDic, @"vipbiaozhi");
    currentUserInfo.usrcustid=StringForKeyInUnserializedJSONDic(userInfoDic, @"usrcustid");
    currentUserInfo.touxiang=StringForKeyInUnserializedJSONDic(userInfoDic, @"touxiang");
    currentUserInfo.shiming=IntForKeyInUnserializedJSONDic(userInfoDic, @"shiming");
    currentUserInfo.vipzige = StringForKeyInUnserializedJSONDic(userInfoDic, @"vipzige");
    currentUserInfo.toubiaocishu = StringForKeyInUnserializedJSONDic(userInfoDic, @"toubiaocishu");
    currentUserInfo.mobile = StringForKeyInUnserializedJSONDic(userInfoDic, @"mobile");
    currentUserInfo.iszdtou = StringForKeyInUnserializedJSONDic(userInfoDic, @"iszdtou");
    currentUserInfo.hfkai = StringForKeyInUnserializedJSONDic(userInfoDic, @"hfkai");
    currentUserInfo.jymimafou = StringForKeyInUnserializedJSONDic(userInfoDic, @"jymimafou");
    currentUserInfo.banbenhao = StringForKeyInUnserializedJSONDic(userInfoDic, @"banbenhao");
    currentUserInfo.startTime = StringForKeyInUnserializedJSONDic(userInfoDic, @"startTime");
    currentUserInfo.shenfenzhenghao = StringForKeyInUnserializedJSONDic(userInfoDic, @"shenfenzhenghao");
    currentUserInfo.wenjuanxianshi = StringForKeyInUnserializedJSONDic(userInfoDic, @"wenjuanxianshi");
    currentUserInfo.fengxianwenjuan = StringForKeyInUnserializedJSONDic(userInfoDic, @"fengxianwenjuan");
    currentUserInfo.fengxianwenjuanwode = StringForKeyInUnserializedJSONDic(userInfoDic, @"fengxianwenjuanwode");
    
    currentUserInfo.weishangbang = StringForKeyInUnserializedJSONDic(userInfoDic, @"weishangbang");
    currentUserInfo.jiaoyimshezhi = StringForKeyInUnserializedJSONDic(userInfoDic, @"jiaoyimshezhi");
    currentUserInfo.huishangshiming = StringForKeyInUnserializedJSONDic(userInfoDic, @"huishangshiming");
    
    
    if (userInfoDic[@"zhenshiname"]) {
        currentUserInfo.zhenshiname = StringForKeyInUnserializedJSONDic(userInfoDic, @"zhenshiname");
    }else
    {
        currentUserInfo.zhenshiname = @"融托金融";
    }
//#warning --记得改回
    
//    currentUserInfo.weishangbang = @"1";
//    currentUserInfo.huishangshiming = @"1";
//    currentUserInfo.jiaoyimshezhi = @"1";

    
    [[NSUserDefaults standardUserDefaults] setValue:StringForKeyInUnserializedJSONDic(userInfoDic, @"touxiang") forKey:@"userLogo"];
    [[NSUserDefaults standardUserDefaults] setValue:StringForKeyInUnserializedJSONDic(userInfoDic, @"user_name") forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:StringForKeyInUnserializedJSONDic(userInfoDic, @"username") forKey:@"personName"];
     [[NSUserDefaults standardUserDefaults] setValue:StringForKeyInUnserializedJSONDic(userInfoDic, @"touxiangsde") forKey:@"touxiangsde"];
    
    currentUserInfo.userLoginState=1;
    
    
    [self saveUserObjectWithUser:currentUserInfo];
    
    [currentUserInfo userFromArachiver];
    
    
    
}
-(void)cleanAllUserInfo
{
    self.userId = nil;
    
    self.userName = nil;
    self.personName = nil;
    self.touxiangsde = nil;
    self.vipbiaozhi = nil;;
    self.vipzigefenxiang = nil;
    self.usrcustid = nil;
    self.vipzige = nil;
    
    self.shiming = 0;
    self.touxiang = nil;
    self.toubiaocishu = nil;
    self.mobile = nil;
    self.iszdtou = nil;
    self.hfkai = nil;
    self.zhenshiname = nil;
    self.jymimafou = nil;
    self.banbenhao = nil;
    self.wenjuanxianshi = nil;
    self.fengxianwenjuan = nil;
    self.fengxianwenjuanwode = nil;
    self.weishangbang = nil;
    self.jiaoyimshezhi = nil;
    self.huishangshiming = nil;
    self.shenfenzhenghao = nil;
    
    
    //self.startTime = nil;
    self.userLoginState = 0;
    [self removUserInfoArachive];
}

-(void)checkUserInfoWithNetWork;
{
    
    LocalDataManagement *dataManagement = [[LocalDataManagement alloc] init];
    if ([dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]) {

        NSDictionary *userLoginDic = [[NSDictionary alloc] initWithDictionary:[dataManagement getUserFileWithUserFileType:CYHUserLoginInfoFile]];
        NSString *userName = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"UserName"]];//用户名
        NSString *password = [NSString stringWithFormat:@"%@",[userLoginDic objectForKey:@"Password"]];//密码
        NSString    *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];

        [FMHTTPClient getUserLoginInforWithUser:userName withUserPassword:password completion:^(WebAPIResponse *response) {
            
            
            if (response.responseObject) {

                if(response.code == WebAPIResponseCodeSuccess){
                    //初始化登录信息
                    [CurrentUserInformation initializaionUserInformation:[response.responseObject objectForKey:@"data"]];
                    // 调用block
                    if (self.blockChangeUserIcon) {
                        self.blockChangeUserIcon([CurrentUserInformation sharedCurrentUserInfo]);
                    }
                    [JPUSHService setAlias:openUDIDString callbackSelector:nil object:nil];
                    
                }
                if (response.code == WebAPIResponseCodeFailed) {
                    
                    if (response.responseObject[@"msg"]) {
                        NSString *msg = response.responseObject[@"msg"];
                        if ([msg isEqualToString:@"密码错误！"]) {
                            [self passwordChange];
                        }
                    }else
                    {
                        
                    }
                    
                    
                }

            }else{
                
            }
            
        }];
    }
    
}
-(void)passwordChange
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户密码已更改，请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 87654;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[CurrentUserInformation sharedCurrentUserInfo] userQuiteWithApp];
    [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultShowLoginControler object:nil];
    
}

-(void)userQuiteWithApp;
{
    //        退出登录前请求数据
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSString *openUDIDString = [[NSString alloc]initWithFormat:@"%@",[OpenUDID value]];
    
    NSString *url=[NSString stringWithFormat:@"%@?user_id=%@&appid=huiyuan&shijian=%d&token=%@&imei=%@",explorerIsLoginURL,[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp,tokenlow,openUDIDString];
    
    [FMHTTPClient getPath:url parameters:nil completion:^(WebAPIResponse *response) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //移除本地文件
            LocalDataManagement *dataManagement=[[LocalDataManagement alloc] init];
            ////移除用户登录文件
            [self cleanAllUserInfo];
            NSString *userLoginInfoPathString=[dataManagement getUserFilePathWithUserFileType:CYHUserLoginInfoFile];;
            [[NSFileManager defaultManager] removeItemAtPath:userLoginInfoPathString error:nil];
            ////移除用户详情文件
            NSString *userDetailInfoPathString = [dataManagement getUserFilePathWithUserFileType:CYHUserDetailInfoFile];
            [[NSFileManager defaultManager] removeItemAtPath:userDetailInfoPathString error:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:FMUserLogoutNotification object:nil];//触发退出登录通知
            FMShareSetting.agreeGestures = NO;
            
            
            
        });
    }];
    
    
    
    
}

-(void)checkFigureJudge;
{
    LAContext *lac = [[LAContext alloc]init];
    BOOL isSupport = [lac canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    if(!isSupport)
    {
        
    }else{
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        
        if (userDef) {
            NSNumber *user = [userDef objectForKey:@"userSetShowSheJieSuo"];
            if (user) {
                if ([user intValue] == 1) {
                    
                }else
                {
                    [userDef setObject:[NSNumber numberWithInt:1] forKey:@"userSetShowSheJieSuo"];
                }
            }else
            {
            }
        }
        
        
        [lac evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键来验证已有手机指纹" reply:^(BOOL success, NSError *error) {
            if(success)
            {
                //指纹识别成功
                
                [self checkUserInfoWithNetWork];
            }else{
                NSString *errorStr = [error localizedDescription];
                
                if ([errorStr isEqualToString: @"Canceled by user."]) {
                    
                    [self showAlert:@"指纹密码未识别,请重新登录！"];
                }
                if ([errorStr isEqualToString:@"Application retry limit exceeded."]) {
                    [self showAlert:@"指纹密码未识别,请重新登录！"];
                }
                if ([errorStr isEqualToString:@"Fallback authentication mechanism selected."]) {
                    [self showAlert:@"指纹密码未识别,请重新登录！"];
                }
                
            }
        }];
    }
    
}
#pragma mark - 提示信息
- (void)showAlert:(NSString*)string
{
    
    
    [[CurrentUserInformation sharedCurrentUserInfo] userQuiteWithApp];
    NSDictionary * dict = @{@"content":string};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KdefaultShowLoginControler object:dict];
    
}






/**
 *  归档
 *
 *  @param user <#user description#>
 */
+ (void)saveUserObjectWithUser:(CurrentUserInformation *)user
{
    //我们要将自定义对象转化为二进制流 并写入沙盒 我们要进行以下操作
    //1.先创建一个NSMutableData对象
    NSMutableData *data = [NSMutableData data];
    //2.创建一个归档对象
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    //3.归档
    [archive encodeObject:user forKey:@"userInfo"];
    
    //4.完成归档
    [archive finishEncoding];
    
    //5.写入文件
    [data writeToFile: [[self class] path] atomically:YES];
}

-(void)removUserInfoArachive
{
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:[[self class]path]];
    
    if (bRet) {
        //
        NSError *err;
        
        [[NSFileManager defaultManager] removeItemAtPath:[[self class]path] error:&err];
        
        
    }
    //删除手势解锁相关文件
    LocalDataManagement *dataManagement=[[LocalDataManagement alloc] init];
    NSString *userLoginInfoPathString=[dataManagement getUserFilePathWithUserFileType:CYHUserLoginInfoFile];;
    [[NSFileManager defaultManager] removeItemAtPath:userLoginInfoPathString error:nil];
    ////移除用户详情文件
    NSString *userDetailInfoPathString = [dataManagement getUserFilePathWithUserFileType:CYHUserDetailInfoFile];
    [[NSFileManager defaultManager] removeItemAtPath:userDetailInfoPathString error:nil];
    
    [GestureViewController cleanFigureGesture];

}

- (void)userFromArachiver
{
    //1.首先判断文件是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:[[self class]path]])
    {
        [self cleanAllUserInfo];
        return;
    }
    
    
    
    //2.读取data对象
    NSData *data = [NSData dataWithContentsOfFile:[[self class]path]];
    
    //3.创建解归档对象
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    
    //4.解档 创建接受对象
    CurrentUserInformation * user =  [unarchive decodeObjectForKey:@"userInfo"];
    //5.完成解档
    [unarchive finishDecoding];
    
    CurrentUserInformation *currentUserInfo = [CurrentUserInformation sharedCurrentUserInfo];
    currentUserInfo.userName = user.userName;
    currentUserInfo.personName = user.personName;
    currentUserInfo.touxiangsde = user.touxiangsde;
    currentUserInfo.userId = user.userId;
    currentUserInfo.vipbiaozhi = user.vipbiaozhi;
    currentUserInfo.vipzigefenxiang = user.vipzigefenxiang;
    currentUserInfo.usrcustid = user.usrcustid;
    currentUserInfo.vipzige = user.vipzige;
    currentUserInfo.shiming = user.shiming;
    currentUserInfo.touxiang = user.touxiang;
    currentUserInfo.toubiaocishu = user.toubiaocishu;
    currentUserInfo.mobile = user.mobile;
    currentUserInfo.iszdtou = user.iszdtou;
    currentUserInfo.hfkai = user.hfkai;
    currentUserInfo.zhenshiname = user.zhenshiname;
    currentUserInfo.shenfenzhenghao = user.shenfenzhenghao;
    currentUserInfo.jymimafou = user.jymimafou;
    currentUserInfo.banbenhao = user.banbenhao;
    currentUserInfo.userLoginState = user.userLoginState;
    currentUserInfo.startTime = user.startTime;
    currentUserInfo.wenjuanxianshi = user.wenjuanxianshi;
    currentUserInfo.fengxianwenjuan = user.fengxianwenjuan;
    currentUserInfo.fengxianwenjuanwode = user.fengxianwenjuanwode;
    currentUserInfo.huishangshiming = user.huishangshiming;
    
    currentUserInfo.weishangbang = user.weishangbang;
    currentUserInfo.jiaoyimshezhi = user.jiaoyimshezhi;

}

+ (NSString *)path
{
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES)lastObject];
    
    return [chachePath stringByAppendingPathComponent:@"userInfo"];
}
@end
