//
//  KRongTuoHeaderUrl.h
//  fmapp
//
//  Created by runzhiqiu on 16/6/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#ifndef KRongTuoHeaderUrl_h
#define KRongTuoHeaderUrl_h


#ifdef __OBJC__
#pragma -mark 融米俱乐部

/**
 *  融米俱乐部－我要记账
 */
#define KRongmiClub_JiZhang  @"https://www.rongtuojinrong.com/rongtuoxinsoc/Jizhangbill/index"
/**
 *  融米俱乐部－底部3个商品详情链接
 */
#define KRongmiClub_BottomShopSetail @"https://www.rongtuojinrong.com/rongtuoxinsoc/Rmjifenshop/shangpinshow"
/**
 *  融米俱乐部－中间广告轮播
 */
#define KRongmiClub_MiddleAdsCycle @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/jlbindexlunbojiuhao"
/**
 *  融米俱乐部－获取积分信息
 */
#define KRongmiClub_getInfoWithUserScore @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/jifenchaxun"
/**
 *  融米俱乐部－签到加积分
 */
#define KRongmiClub_signArriveAndAddScore @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/jiajifenjiekou"
/**
 *  融米俱乐部－聚一聚
 */
#define KRongmiClub_JuyijuInfo @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Juyijuparty"

/**
 *  融米俱乐部－财经新闻
 */
#define KRongmiClub_CaijingNews @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/5"

/**
 *  融米俱乐部－美读时光
 */
#define KRongmiClub_BeautifulTimes @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/6"


/**
 *  融米俱乐部－获取头像信息
 */
#define KRongmiClub_getUserInfoWithIcon @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/commoninfochangliu"
/**
 *  融米俱乐部－上传头像信息
 */
#define kRongmiClub_UploadImage @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/avatarUpload"


/**
 *  融米俱乐部－融米学堂
 */
#define kRongmiClub_RongmiSchoolClass @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/4"
/**
 *  融米俱乐部－签到记录
 */
#define kRongmiClub_RongmiSignOnNotes @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/qiandaolist"

/**
 *  融米俱乐部－签到记录－日历补签
 */
#define kRongmiClub_RongmiSignOnNotes_Buqian @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/buqian"



#pragma mark ---- 我的账户
/**
 *  充值信息确认界面 -- 账户姓名金额提取
 */
#define CZInformationURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/HengfengAccount/info"
/**
 *  快捷充值界面 -- 获取银行名字 和 尾号
 */
#define BankNameAndCardNoURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/binded"
/**
 *  快捷充值界面 --- 发送验证码
 */
#define QuickSendCodeURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Chongzhi/sendCode"
/**
 *  快捷充值界面 -- 确认按钮请求
 */
#define requestCZMoneyURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Chongzhi/charge"
/**
 *  恒丰 提现 -- 第一页请求可提现余额
 */
#define AvailableBalanceURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/HengfengAccount/info"
/** 新增银行卡 */
#define urlAddNewCard @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/getbankinfo"
/** 新增银行卡--发送验证码 */
#define urlSendCode @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/bind_sendCode"
/** 申请解绑--发送验证码 */
#define urlApplyUnwrapCode @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/unbind_sendCode"
/** 新增银行卡--确认 */
#define urlSureTiedCard @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/bind"
/** 申请解绑--解绑 */
#define urlApplyUnwrap @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/unbind"
/** 新增银行卡--选择银行 */
#define urlBankList @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/getbankinfo"
/** 新增银行卡--开户行所属地 */
#define bankAddressURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/regions"
/** 我的账户 */
#define NavURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/hfmyindex"
/** 我的账户--找回交易密码 */
#define FindKeyURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/pdjiaoyimima"
/** 我的账户--预期收益 */
#define expectedCashMoneyUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/huikuanjhua"
/** 我的账户--我的奖励 */
#define myRewardUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/myjiangli"
/** 我的账户--自动投标 */
#define autoBidUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zdtzsm"
/** 我的账户--汇付帐户 */
#define remittanceAccountUrl @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/myyujin"
/** 我的账户--在途资金 */
#define onRoadCashNavURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Chongzhi/inprocessing"
/** 交易记录 */
#define tradeNoteURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/AccountFlowRecords/cates"
/** 交易记录--选择日期之后 */
#define tradeNoteSelectDateURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/AccountFlowRecords/lists"
/** 登录注册与密码找回--用户服务协议 */
#define loginAndRegisterAndFindPasswordURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/user/xieyi"
/** 登录注册与密码找回--融托金融用户服务协议 */
#define userServiceAgreementURL @"http://ww.rongtuojinrong.com/login/xieyi"
/** 登录注册与密码找回--实名认证 */
#define realNameAuthenKaihuURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/kaihuyuansheng"
/** 提现 */
#define withDrawalURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chaxun"


/** 提现--点击提现按钮 */
#define didClickWithDrawalBtnURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/quxiantijiaoapp"
/** 宝贝计划--BabyPlanAccountVC */
//#define babyPlanURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Lend/baobeijihua"
/** 宝贝计划--判断是否注册汇付 */
#define babyPlanRegisterHuiFuURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chaxun"


/** 宝贝计划--自动投标 */
#define babyPlanAutoTenderURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zdtzsm"
/** 宝贝计划--自动投标 */
#define babyNewPlanAutoTenderURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zdtzsmershiyi"
/** 宝贝计划--充值 */
#define babyPlanPayURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chongzhiweb"
/** 宝贝计划--宝贝计划 */
#define babyPlanBPURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/toubiaobbjhapp"
/** 宝贝计划--宝贝计划投资协议---BPVC*/
#define babyPlanInvestmentAgreementURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/bbxieyi.html"
/** 宝贝计划--立即加入或者立即预约 */
//#define babyPlanControllerURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Lend/baobeijihua"
/** 宝贝计划--进入页面请求数据 */
#define babyPlanVCURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/toubiaozhongbbshuzhi"
/** 宝贝计划--分享 */
#define babyPlanShareURL @"http://ww.rongtuojinrong.com/lend/toubiaozhongbb"
/** 宝贝计划--AddScore */
#define babyPlanAddScoreURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/jiajifenjiekou"
/** 宝贝计划--查看合同 */
#define babyPlanLookContractURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chakanhetongbb"
/** 宝贝计划--加入列表 */
#define babyPlanListURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/baobeijiarujl"
/** 宝贝计划--计划详情 */
#define babyPlanDetailURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/baobeijihuagrone"
/** 宝贝计划--确认申购 */
#define babyPlanConfirmPurchaseURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/toubiaobbjhapp"
/** 宝贝计划--详细列表 */
#define babyPlanDetailListURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/dangebaobeijihua"
#pragma mark ---- 发现
/** 发现--判断用户是否登录 */
#define explorerIsLoginURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/login_out"
/** 发现--安全保障 */
#define explorerSecurityURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Gengdfwu/anquanbaozhang"
/** 发现--新手指引 */
#define WLExplorerMyRecommendURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Gengdfwu/xinshouzhiyin?laiyuan=2"
/** 发现--AddScore */
#define explorerAddScoreURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/jiajifenjiekou"
/** 发现--企业介绍 */
#define explorerCompanyIntroduceURL @"https://www.rongtuojinrong.com/rongtuojieshao/index.html"
/** 发现--业务领域 */
#define explorerBusinessAreasURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Helpzhongxin/yewulingyu"
/** 发现--合作机构 */
#define explorerCooperationAgencyURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/hezuojigouweb"
/** 发现--企业宣传视频 */
#define explorerBusinessVideoURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Helpzhongxin/qyxuanchuanweb.html"
/** 发现--公司简介 */
#define explorerCompanyProfileURL @"http://www.rongtuojinorng.com/login/shipinjieshaoapp"
/** 站内信--点击每一行 */
#define explorerZhanNeiXinURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zhanneixinshow"
/** 项目--投标 */
#define projectBiddingURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Lend/natbdiyibu"
/** 融米学堂--搜索 */
#define rongMiSearchURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/api/newsList/cateid/4/kw/"
/** 融米俱乐部--GoodAddress */
#define rongMiUsercenterAddressRL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/houqudizhi"
/** 融米俱乐部--DidOnClickOperateButton */
#define rongMiClickOperateButtonRL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/tjshouhuodizhi"
/** 融米俱乐部--附近--俱乐部展示 */
#define rongMiClubDisplayRL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/rongmizhijiashow"
/** 融米俱乐部--我的积分 */
#define rongMiMyScoreURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/wodepointsjilu"
/** 融米俱乐部--积分攻略 */
#define rongMiScoreStrategyURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/huoqujifenfangshiweb"
/** 融米俱乐部--会员特权--我要升级 */
#define rongMiPromoteURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/yuqifinacexinde"
/** 融米俱乐部--兑换记录--删除cell */
#define rongMiDeleteCellURL @"https://www.rongtuojinrong.com/qdy/wap/member-jifen_ex_list_client.html"//https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/shchduihuanjilu
/** 融米俱乐部--兑换记录--点击每一行cell */
#define rongMididSelectRowURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Rmjifenshop/shangpinshow"
/** 融米俱乐部--兑换记录--headerView */
#define rongMiHeaderViewURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/jifenchaxun"
/** 融米俱乐部--兑换记录*/
#define rongMiExchangeRecordURL @"https://www.rongtuojinrong.com/qdy/wap/member-jifen_ex_list_client.html"  //https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/wodeduihuanjilu


/**
 *   发现 -- 帮助中心 -- 注册登陆篇
 */
#define  RegisterLoginURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/showeb1"
/**
 *  发现 -- 帮助中心 -- 充值篇
 */
#define  RechargeArticlesURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/showeb2"
/**
 *  发现 -- 帮助中心 -- 投资篇
 */
#define  InvestmentArticlesURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/showeb3"
/**
 *  发现 -- 帮助中心 -- 资产篇
 */
#define  AssetArticleURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/showeb4"
/**
 *  发现 -- 帮助中心 -- 提现篇
 */
#define WithdrawalsURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Helpzhongxin/showeb5"



/**
 *  首页接口
 */
#define  KMainAllURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/appindexallyijiu"

/**
 *  新手专享标－列表接口
 */
#define  KNewHandMainURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/Lend/redbaobiao"

/**
 *  新手专享标－列表数据为空时候接口
 */
#define  KNewHandNullURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/toubiaohbzx"

/**
 *  新手专享标－viewWillAppear请求
 */
#define  KNewHandViewWillAppearURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chaxun"




/**
 *  新手专享标－刷新接口
 */
#define  KNewHandrRefreshURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/getuserquaninfo"

/**
 *  新手专享标－充值接口
 */
#define  KNewHandrRechargeURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chongzhiweb"

/**
 *  项目 -- 项目信息 -- 分享
 */
#define shareWeiManURL @"http://ww.rongtuojinrong.com/lend/borrage/jie_id/"
/**
 *  项目 -- 项目信息 -- babyPlanAddScore
 */
#define babyPlanAddScoreURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/jiajifenjiekou"

/**
 *  零钱贯－交易规则和常见问题
 */
#define  KLingqianguanTradeAndeProblemURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/user/lqliaojie"

/**
 *  零钱贯－分享接口
 */
#define  KLingqianguanShareURL @"http://ww.rongtuojinrong.com/lend/toubiaolqshare"

/**
 *  零钱贯－分享积分接口
 */
#define  KLingqianguanShareScoreURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Rmjifenshop/jiajifenjiekou"

/**
 *  零钱贯－取出界面接口
 */
#define  KLingqianguanRollOutURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/lqkequjiner"

/**
 *  零钱贯－取出界面-立即取出接口
 */
#define  KLingqianguanNowRollOutURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/lqkequjinertijiaoyisan"

/**
 *  零钱贯－取出结果接口
 */
#define  KLingqianguanRollResultURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/lqkequjinertijiaoyisan"

/**
 *  零钱贯介绍详情
 */
#define  KLingqianguanDetailURL @"https://www.rongtuojinrong.com/rongtuoxinsoc/user/lqliaojie"

/**
 *  取出
 */
#define  KLingqianguanQuchuURL  @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/lqquxianyue_client"

/**
 *  确认取出
 */
#define  KLingqianguanQueRenQuchuURL  @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/zhaiquanzhuanhjqx_client"

/**
 *  存入详情
 */
#define  KLingqianguanCunRuDetailURL  @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/lqquchuxindesanshi"

/**
 *  零钱贯协议
 */
#define  KLingqianguanDelegateURL  @"http://ww.rongtuojinrong.com/login/lqxieyi.html"

/**
 *  零钱贯保存接口
 */
#define  KLingqianguanSaveURL  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/toubiaolqappyuansheng"

/**
 *  零钱贯详情接口
 */
#define  KLingqianguanAboutDetailURL  @"https://www.rongtuojinrong.com/rongtuoxinsoc/user/lqliaojie"

/**
 *  零钱贯存入界面数据接口－零钱罐余额查询－恒丰版本
 */
#define  KLingqianguanListDataURL  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chaxunhhuifu"
/**
 *  零钱贯存入界面数据接口－零钱罐余额查询－老版本
 */
#define  KLingqianguanListDataOldURL  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/chaxun"

/**
 *  零钱贯自动投标
 */
#define  KLingqianguanAutoTouBiaoURL  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zdtzsm"

/**
 *  零钱贯自动承接转让协议
 */
#define  KLingqianguanAutoTouBiaoNewURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Usercenter/zdzhaiquanzhuanershiqi"

/**
 *  零钱贯-label数据
 */
#define  KLingqianguanLabelURL  @"https://www.rongtuojinrong.com/Rongtuoxinsoc/lend/lingqianguanyue"

/**
 *  零钱贯-投资数据
 */
#define  KLingqianguanInvestMoneyURL  @"https://www.rongtuojinrong.com/rongtuoxinsoc/lend/lingqianguanyiba"

/**
 *  我的零钱贯列表数据
 */
#define  KMyLingqianguanURL  @"https://www.rongtuojinrong.com/rongtuoxinsoc/usercenter/lq_jiaoyi_list"



#pragma mark ----- 恒丰银行实名认证
/***
 实名认证获取验证码接口
 */
#define GetingCodeURL @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/huoquduanxin"

/***
 实名认证设置六位交易密码接口
 */
#define SixScreatPassWord @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/do_jiaoyimima"

/***
 实名认证提交注册接口码接口
 */
#define KaiXinHu @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/kaixunihu"

/***
 实名认证获取姓名和身份证号接口
 */
#define GetUserInfo @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/getuserinfo"

/***
 判断是否可解绑
 */
#define IsCanBeRelease @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/unbindable"

#pragma mark ----- 我的银行卡
/***
 银行卡数据请求
 */
#define RequestBankListData @"https://www.rongtuojinrong.com/Rongtuoxinsoc/Card/binded"

/***
 银行卡选择
 */
#define urlBankList @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/getbankinfo"

/***
 修改六位交易密码
 */
#define ChengeTheTraderPassWord @"https://www.rongtuojinrong.com/Rongtuoxinsoc/User/zhhjymima"


/***
 分享获取接口的链接
 */
#define kDefaultShareUrlBase  @"https://www.rongtuojinrong.com/rongtuoxinsoc/helpzhongxin/shareallcontentyuandan"


#define KDefaultSecondReduceOnce  @"SecondReduceOnceWithKillTime"

/**
 *  手势解锁或指纹解锁失败，弹出登陆控制器
 */
#define KdefaultShowLoginControler @"DefaultShowLoginControler"

#define KdefaultMyViewControllerRefresh @"DefaultMyViewControllerRefresh"
/**
 *  手势解锁或指纹解锁成功，发出通知
 */
#define KdefaultSuccessInGestureViewController @"DefaultSuccessInGestureViewController"
/**
 *  设置手势解锁成功，发出通知
 */
#define KdefaultSetGestureViewController @"DefaultSetInGestureViewController"

/**
 *  优商城从支付宝或者微信返回
 */
#define KBackFromAlipayOrWechat @"BackFromAlipayOrWechat"

/**
 *  积分兑换从支付宝或者微信返回
 */
#define KBackFromAlipayOrWechatCoinPay @"KBackFromAlipayOrWechatCoinPay"


#endif
#endif /* KRongTuoHeaderUrl_h */
