//
//  ProjectModel.m
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel

+(id)modelWithUnserializedJSONDic:(NSDictionary *)dic
{
    ProjectModel *model=[[ProjectModel alloc]init];
    
    model.projectId=StringForKeyInUnserializedJSONDic(dic, @"jie_id");
    model.projectTitle=StringForKeyInUnserializedJSONDic(dic, @"title");
    model.projectCompany=StringForKeyInUnserializedJSONDic(dic, @"danbaocompany");
    model.projectYearEarn=StringForKeyInUnserializedJSONDic(dic, @"lilv");
    model.jiner=StringForKeyInUnserializedJSONDic(dic, @"jiner");
    
    int money=IntForKeyInUnserializedJSONDic(dic, @"jiner");
    
    model.projectMoney=[NSString stringWithFormat:@"%.1f",(CGFloat)money/10000];
    model.projectProgress=FloatForKeyInUnserializedJSONDic(dic, @"jindu");
    model.jindut=FloatForKeyInUnserializedJSONDic(dic, @"jindut");
    model.jindu=StringForKeyInUnserializedJSONDic(dic, @"jindu");

    model.projectStyle=IntForKeyInUnserializedJSONDic(dic, @"zhuangtai");
    
    model.projectDate=StringForKeyInUnserializedJSONDic(dic, @"qixian");
    model.tianshu=IntForKeyInUnserializedJSONDic(dic, @"tianshu");
    if (IsStringEmptyOrNull(model.projectDate)) {
        model.projectDate=@"0";
    }
    
    int type=IntForKeyInUnserializedJSONDic(dic, @"huankuanfangshi");
    if (type==1) {
        model.projectRepayType=@"等额本息";
    }
    else
    {
        model.projectRepayType=@"每月还息到期还本息";
    }
    model.kaishicha=IntForKeyInUnserializedJSONDic(dic, @"kaishicha");
    
    model.SurplusTime=IntForKeyInUnserializedJSONDic(dic, @"ended_time");
    
    model.rongzifangshi=StringForKeyInUnserializedJSONDic(dic, @"rongzifangshi");
    
    model.qixian = StringForKeyInUnserializedJSONDic(dic, @"qixian");
    model.zhuangtai  = StringForKeyInUnserializedJSONDic(dic,@"zhuangtai");
    
    
    return model;
}
+(id)modelMyClaimDetailWithUnserializedJSONDic:(NSDictionary *)dic
{
    ProjectModel *model=[[ProjectModel alloc]init];
    model.zhuangtai = StringForKeyInUnserializedJSONDic(dic, @"zhuangtai");
    model.projectId=StringForKeyInUnserializedJSONDic(dic, @"jie_id");
    model.projectTitle=StringForKeyInUnserializedJSONDic(dic, @"biaoti");
    model.projectCompany=StringForKeyInUnserializedJSONDic(dic, @"danbaocompany");
    model.projectYearEarn=StringForKeyInUnserializedJSONDic(dic, @"lilv");
    model.jiezhuangtai = StringForKeyInUnserializedJSONDic(dic, @"jiezhuangtai");
    
    model.projectMoney=StringForKeyInUnserializedJSONDic(dic, @"jiner");
    
    model.projectDate=StringForKeyInUnserializedJSONDic(dic, @"qixian");
    model.jiaxishuzhi = StringForKeyInUnserializedJSONDic(dic, @"jiaxishuzhi");
    if (IsStringEmptyOrNull(model.projectDate)) {
        model.projectDate=@"0";
    }
    
    int type=IntForKeyInUnserializedJSONDic(dic, @"huankuanfangshi");
    if (type==1) {
        model.projectRepayType=@"等额本息";
    }
    else
    {
        model.projectRepayType=@"每月还息到期还本息";
    }
    model.kaishicha=IntForKeyInUnserializedJSONDic(dic, @"kaishicha");
    
    model.SurplusTime=IntForKeyInUnserializedJSONDic(dic, @"ended_time");
    
    model.rongzifangshi=StringForKeyInUnserializedJSONDic(dic, @"rongzifangshi");
    
    model.daoqshijian=StringForKeyInUnserializedJSONDic(dic, @"daoqshijian");
    model.qitshijian=StringForKeyInUnserializedJSONDic(dic, @"qitshijian");
    
    model.xmshouyi=StringForKeyInUnserializedJSONDic(dic, @"xmshouyi");
    
    model.jilu_id=StringForKeyInUnserializedJSONDic(dic, @"jilu_id");
    model.qixian = StringForKeyInUnserializedJSONDic(dic, @"qixian");

    return model;
 
}


+(id)modelForProjectDetailWithUnserializedJSONDic:(NSDictionary *)dic
{
    ProjectModel *model=[[ProjectModel alloc]init];
    model.dizenge=StringForKeyInUnserializedJSONDic(dic, @"dizenge");
    model.end_time=StringForKeyInUnserializedJSONDic(dic, @"end_time");
    model.jiexi_time=StringForKeyInUnserializedJSONDic(dic, @"jiexi_time");
    model.rongzifangshi=StringForKeyInUnserializedJSONDic(dic, @"rongzifangshi");
    model.title=StringForKeyInUnserializedJSONDic(dic, @"title");
    model.lilv=StringForKeyInUnserializedJSONDic(dic, @"lilv");
    model.projectMoney=StringForKeyInUnserializedJSONDic(dic, @"jiner");
//    int money=IntForKeyInUnserializedJSONDic(dic, @"jiner");
    
    model.jiner=StringForKeyInUnserializedJSONDic(dic, @"jiner");
    
    model.shengyu=StringForKeyInUnserializedJSONDic(dic, @"shengyu");
    model.jindu=StringForKeyInUnserializedJSONDic(dic, @"jindu");
    model.jindut=FloatForKeyInUnserializedJSONDic(dic, @"jindut");
    model.zhuangtai=StringForKeyInUnserializedJSONDic(dic, @"zhuangtai");
    int type=IntForKeyInUnserializedJSONDic(dic, @"huankuanfangshi");
    if (type==1) {
        model.huankuanfangshi=@"等额本息";
    }
    else
    {
        model.huankuanfangshi=@"每月还息到期还本息";
    }    
    
    model.leixing=StringForKeyInUnserializedJSONDic(dic, @"leixing");
    model.qixian=StringForKeyInUnserializedJSONDic(dic, @"qixian");
    model.qi_id=StringForKeyInUnserializedJSONDic(dic, @"qi_id");
    model.danbao_id=StringForKeyInUnserializedJSONDic(dic, @"danbao_id");
    model.fdanbao_id=StringForKeyInUnserializedJSONDic(dic, @"fdanbao_id");
    model.baoxian_id=StringForKeyInUnserializedJSONDic(dic, @"baoxian_id");
    model.danbaocompany=StringForKeyInUnserializedJSONDic(dic, @"danbaocompany");
    model.start_time=StringForKeyInUnserializedJSONDic(dic, @"start_time");
    model.manbiaoshijian=StringForKeyInUnserializedJSONDic(dic, @"manbiaoshijian");
    model.yongtu=StringForKeyInUnserializedJSONDic(dic, @"yongtu");
    model.miaoshu=StringForKeyInUnserializedJSONDic(dic, @"miaoshu");
    model.fengkong=StringForKeyInUnserializedJSONDic(dic, @"fengkong");
    model.bianhao=StringForKeyInUnserializedJSONDic(dic, @"bianhao");
    model.projectId=StringForKeyInUnserializedJSONDic(dic, @"jie_id");
    model.baoxianjigou=StringForKeyInUnserializedJSONDic(dic, @"baoxianjigou");
    model.touzirenshu=StringForKeyInUnserializedJSONDic(dic, @"touzirenshu");
    model.touzidengijmingcheng=StringForKeyInUnserializedJSONDic(dic, @"touzidengijmingcheng");
    model.xingji=StringForKeyInUnserializedJSONDic(dic, @"xingji");
    model.yuqizongsy=StringForKeyInUnserializedJSONDic(dic, @"yuqizongsy");
    model.zddengji=StringForKeyInUnserializedJSONDic(dic, @"zddengji");
    model.projectStyle=IntForKeyInUnserializedJSONDic(dic, @"zhuangtai");
    model.kaishicha=IntForKeyInUnserializedJSONDic(dic, @"kaishicha");
    model.tianshu = IntForKeyInUnserializedJSONDic(dic, @"tianshu");
    
    model.daoqi_time=StringForKeyInUnserializedJSONDic(dic, @"daoqi_time");
    model.jinduz=StringForKeyInUnserializedJSONDic(dic, @"jinduz");
    model.lilvyou = StringForKeyInUnserializedJSONDic(dic, @"lilvyou");
    model.product_id=StringForKeyInUnserializedJSONDic(dic, @"product_id");
    model.xianyou=StringForKeyInUnserializedJSONDic(dic, @"xianyou");
    model.jiaxi=StringForKeyInUnserializedJSONDic(dic, @"jiaxi");
    model.jiaxiyuanyin=StringForKeyInUnserializedJSONDic(dic, @"jiaxiyuanyin");
    model.fengxianwenjuan = StringForKeyInUnserializedJSONDic(dic, @"fengxianwenjuan");
    
    return model;

}
+(id)modelForClaimDetailWithUnserializedJSONDic:(NSDictionary *)dic
{
    
    ProjectModel *model=[[ProjectModel alloc]init];
    
    model.projectId=StringForKeyInUnserializedJSONDic(dic, @"jie_id");
    model.rongzifangshi=StringForKeyInUnserializedJSONDic(dic, @"rongzifangshi");
    model.title=StringForKeyInUnserializedJSONDic(dic, @"title");
    model.lilv=StringForKeyInUnserializedJSONDic(dic, @"lilv");
    
//    int money=IntForKeyInUnserializedJSONDic(dic, @"jiner");
    
    model.jiner=StringForKeyInUnserializedJSONDic(dic, @"jiner");
    
    model.zhuangtai=StringForKeyInUnserializedJSONDic(dic, @"zhuangtai");
    int type=IntForKeyInUnserializedJSONDic(dic, @"huankuanfangshi");
    if (type==1) {
        model.huankuanfangshi=@"等额本息";
    }
    else
    {
        model.huankuanfangshi=@"每月还息到期还本息";
    }
    model.qixian=StringForKeyInUnserializedJSONDic(dic, @"qixian");
    model.danbaocompany=StringForKeyInUnserializedJSONDic(dic, @"danbaocompany");
    model.start_time=StringForKeyInUnserializedJSONDic(dic, @"start_time");
    model.manbiaoshijian=StringForKeyInUnserializedJSONDic(dic, @"manbiaoshijian");
    model.kegoujine=StringForKeyInUnserializedJSONDic(dic, @"kegoujine");
    
    model.xiacriqi=StringForKeyInUnserializedJSONDic(dic, @"xiacriqi");
    model.yuanshouyi=StringForKeyInUnserializedJSONDic(dic, @"yuanshouyi");
    model.huankuanrq=StringForKeyInUnserializedJSONDic(dic, @"huankuanrq");
    model.yuanzhaiid=StringForKeyInUnserializedJSONDic(dic, @"yuanzhaiid");
    
    model.projectMoney=StringForKeyInUnserializedJSONDic(dic, @"jiner");
    model.guoqi_time=IntForKeyInUnserializedJSONDic(dic, @"guoqi_time");
    model.projectStyle=IntForKeyInUnserializedJSONDic(dic, @"zhuangtai");

    return model;

  
}

@end
