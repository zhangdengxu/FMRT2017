//
//  FMDuobaoSelectShopView.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KDefaultInitString @"请选择商品样式"
#define KDefaultScreenHeigh 0.7

#import "FMDuobaoSelectShopView.h"
#import "FMSelectDuobaoShopCollectionView.h"
#import "FMButtonStyleModel.h"
#import "FMShopSpecModel.h"
#import "FMDuobaoClass.h"
@interface FMDuobaoSelectShopView ()

//选择商品样式所需的控件
@property (nonatomic, strong) UIButton          *closeButton,*buttomButton;
@property (nonatomic, strong) UIImageView       *photoView,*moneyImageView;
@property (nonatomic, strong) UILabel           *priceLabel, *selectLabel;

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *lineView,*bottomView;
@property (nonatomic, strong) FMSelectDuobaoShopCollectionView * collectionView;



@property (nonatomic, strong) NSMutableArray * specDataSource;
@property (nonatomic, strong) NSMutableArray * productDataSource;
@property (nonatomic, strong) NSMutableArray * stringDataSource;
@property (nonatomic, strong) FMSelectShopModelNew * selectModel;
@property (nonatomic, strong) FMSelectShopInfoModel *presentModel;

@end

@implementation FMDuobaoSelectShopView


-(NSMutableArray *)specDataSource
{
    if (!_specDataSource) {
        _specDataSource = [NSMutableArray array];
        
    }
    return _specDataSource;
}

-(NSMutableArray *)productDataSource
{
    if (!_productDataSource) {
        _productDataSource = [NSMutableArray array];
    }
    return _productDataSource;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建view的背景以及创建view上的mbprogresshud
    [self createBackGroundViewWithImageView];
    
    
    [self getFirstDateSourceFromNetWork];
    
    //争议
}

#pragma -mark 第一次获取网络请求
-(void)getFirstDateSourceFromNetWork
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token = EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    NSString *tokenlow=[token lowercaseString];
    NSDictionary * parameter = @{@"user_id":[CurrentUserInformation                         sharedCurrentUserInfo].userId,
                                 @"appid":@"huiyuan",
                                 @"shijian":[NSNumber numberWithInt:timestamp],
                                 @"token":tokenlow,
                                 @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile};
    
    
    NSString * htmlUrl = [NSString stringWithFormat:@"https://www.rongtuojinrong.com/qdy/wap/product/index_client/%@.html",self.product_id];
    
    
    [FMHTTPClient postPath:htmlUrl parameters:parameter completion:^(WebAPIResponse *response) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (response.code == WebAPIResponseCodeSuccess) {
            
            
            FMSelectShopModelNew * selectModel = [[FMSelectShopModelNew
                                                   alloc]init];
            self.selectModel = selectModel;
            NSDictionary * data = response.responseObject[@"data"];
            
            NSDictionary * product_price = data[@"product_price"];
            
            selectModel.store = data[@"store"];
            
            selectModel.product_id = data[@"product_id"];
            
            selectModel.gid = data[@"gid"];
            selectModel.price = product_price[@"price"];
            selectModel.mktPrice = product_price[@"mktprice"];
            selectModel.unselectInfo = KDefaultInitString;
            selectModel.jifen = data[@"jifen"];
            selectModel.brief = data[@"brief"];
            
            
            
            selectModel.title = data[@"title"];
            
            [self createSelectView];
            
            [self setUpUIDataWithModel:selectModel];
            
            
            /**********************************
             **********************************
             *以上初始化头部信息，以下初始化样式信息 *
             **********************************
             **********************************/
            
            NSDictionary * spec = data[@"spec"];
            NSArray *goods = spec[@"goods"];
            NSDictionary * specification = spec[@"specification"];
            NSArray * spec_name = specification[@"spec_name"];
            
            
            NSMutableArray * stringDataSource = [NSMutableArray array];
            
            self.stringDataSource = stringDataSource;
            
            for (NSInteger index = 0;index < goods.count;index ++) {
                NSArray * shopSpecList = goods[index];
                
                //商品属性与商品属性名绑定，里边存有商品的样式名称,数组以String形式存储
                FMShopSpecStringModel * modelString = [[FMShopSpecStringModel alloc]init];
                NSMutableArray * styleStrings = [NSMutableArray array];
                for (NSInteger i = 0; i < shopSpecList.count; i ++) {
                    
                    FMSpecProductModel * model = [[FMSpecProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:shopSpecList[i]];
                    
                    NSString * styleString = [NSString stringWithFormat:@"%@",model.spec_value];
                    
                    FMSpecStringModel * stringModel = [[FMSpecStringModel alloc]init];
                    stringModel.spec_name_value = styleString;
                    stringModel.spec_name = spec_name[index];
                    [styleStrings addObject:stringModel];
                    
                }
                
                
                modelString.styleStrings = styleStrings;
                modelString.spec_name = spec_name[index];
                
                [stringDataSource addObject:modelString];
            }
            
            //默认product_id的商品属性数组
            NSMutableArray * shopStyleArray = [NSMutableArray array];
            //创建商品样式对应product_id的数组；
            NSArray * spec_desc = spec[@"spec_desc"];
            for (NSInteger index = 0; index < spec_desc.count; index ++) {
                
                NSDictionary * dict_spec_one = spec_desc[index];
                
                FMALLSpecDescInfo * specDesc = [[FMALLSpecDescInfo alloc]init];
                specDesc.kStyle = dict_spec_one[@"k"];
                NSArray * vProArray = dict_spec_one[@"v"];
                NSMutableArray * arrayMu = [NSMutableArray array];
                [arrayMu addObjectsFromArray: vProArray];
                specDesc.vProductId = arrayMu;
                [self.specDataSource addObject:specDesc];
                for (NSString * product_id in vProArray) {
                    if ([product_id integerValue] == [self.product_id integerValue]) {
                        [shopStyleArray addObject:specDesc.kStyle];
                    }
                }
                
            }
        
      
            if (self.lastLocationArray.count > 0) {
                selectModel.locationArray = self.lastLocationArray;
            }else
            {
                if (shopStyleArray.count > 0) {
                    NSMutableArray * locationArrayInproduct = [NSMutableArray array];
                    
                    for (NSString * spec_name_value in shopStyleArray) {
                        for (FMShopSpecStringModel * specModel in self.stringDataSource) {
                            
                            for (FMSpecStringModel * stringContent in specModel.styleStrings) {
                                if ([stringContent.spec_name_value isEqualToString:spec_name_value]) {
                                    
                                    FMShopCollectionInfoModel * infoModel = [[FMShopCollectionInfoModel alloc]init];
                                    infoModel.spec_name = specModel.spec_name;
                                    infoModel.contentString = stringContent.spec_name_value;
                                    
                                    [locationArrayInproduct addObject:infoModel];
                                }
                            }
                        }
                        
                    }
                    
                    selectModel.locationArray = locationArrayInproduct;
                }
            }
            
           
            
        
            
            
            //创建商品product的全排列
            
            NSArray * storeArray = spec[@"store"];
            NSInteger allStoreShop = 0;
            for (NSInteger index = 0; index < storeArray.count; index ++) {
                NSDictionary * storeDict = storeArray[index];
                FMALLShopModelInfo * productModel = [[FMALLShopModelInfo alloc]init];
                [productModel setValuesForKeysWithDictionary:storeDict];
                allStoreShop += [productModel.store integerValue];
                [self.productDataSource addObject:productModel];
                
                if ([self.product_id integerValue] ==  [productModel.product_id integerValue]) {
                    selectModel.image = productModel.image;
                }
            }
            
            
            
            if (stringDataSource.count == 0) {
                selectModel.isAllShopInfo = YES;
                
            }else
            {
                if (self.selectModel.locationArray.count < stringDataSource.count){
                    selectModel.isAllShopInfo = NO;
                }else
                {
                    selectModel.isAllShopInfo = YES;
                }
                
            }
            
            if (self.lastSelectCount) {
                selectModel.selectCount = self.lastSelectCount;
            }else
            {
                selectModel.selectCount = 1;
            }
            
            
            
            self.collectionView.currentStore = allStoreShop;
            self.collectionView.selectStore = selectModel.selectCount;
            
            
            selectModel.store = [NSNumber numberWithInteger:allStoreShop];
            
            [self showSelectViewWithDataSource:stringDataSource WithLocationModel:self.selectModel.locationArray];
            
            if (self.selectModel.locationArray) {
                [self changeButtonOnClick:self.selectModel.locationArray];
            }
            
        }else
        {
            ShowAutoHideMBProgressHUD(self.view, @"加载失败！");
            [self performSelector:@selector(closeViewController:) withObject:nil afterDelay:1.0];
        }
        
    }];
}


#pragma -mark 创建UI界面
-(void)createSelectView
{
    UIView *whiteView = [[UIView alloc]init];
    self.whiteView = whiteView;
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = CGRectMake(0, KProjectScreenHeight + 20, KProjectScreenWidth, KProjectScreenHeight * KDefaultScreenHeigh);
    [self.view addSubview:whiteView];
    
    
    [whiteView addSubview:self.closeButton];
    [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(10);
        make.right.equalTo(whiteView.mas_right).offset(-10);
    }];
    
    
    [whiteView addSubview:self.photoView];
    [self.photoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left).offset(10);
        make.width.equalTo(@88);
        make.top.equalTo(whiteView.mas_top).offset(-20);
        make.height.equalTo(@88);
    }];
    
    [whiteView addSubview:self.priceLabel];
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.top.equalTo(whiteView.mas_top).offset(10);
        
    }];
    
    [whiteView addSubview:self.moneyImageView];
    [self.moneyImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.top.equalTo(whiteView.mas_top).offset(10);
    }];
    
    
    if ([self.buttonStyle.type integerValue] == 1) {
        self.moneyImageView.hidden = NO;
        self.priceLabel.hidden = YES;
    }else
    {
        self.moneyImageView.hidden = YES;
        self.priceLabel.hidden = NO;
    }
        
  
    
    [whiteView addSubview:self.selectLabel];
    [self.selectLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_right).offset(10);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(15);
    }];
    
    [whiteView addSubview:self.lineView];
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_left);
        make.right.equalTo(whiteView.mas_right).offset(-10);
        make.top.equalTo(self.selectLabel.mas_bottom).offset(13);
        make.height.equalTo(@0.6);
    }];
    
    
    
    
    
    [whiteView addSubview:self.bottomView];
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left);
        make.right.equalTo(whiteView.mas_right);
        make.bottom.equalTo(whiteView.mas_bottom);
        make.height.equalTo(@49);
    }];
    
    [whiteView addSubview:self.collectionView];
    __weak __typeof(&*self)weakSelf = self;
    
    self.collectionView.shopSpecPro = ^(NSArray * locationArray){
        
        [weakSelf changeButtonOnClick:locationArray];
        
    };
    self.collectionView.selectCountBlock = ^(NSInteger  selecCount){
        
        [weakSelf changeShopCountButtonOnClick:selecCount];
    };
    
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView.mas_left);
        make.right.equalTo(whiteView.mas_right).offset(-10);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    
    
    if (self.buttonArray) {
        CGFloat width = self.view.bounds.size.width / self.buttonArray.count;
        for (NSInteger i = 0; i < self.buttonArray.count; i++) {
            FMButtonStyleModel * model = self.buttonArray[i];
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, 49)];
            [self.bottomView addSubview:button];
            [button setTitle:model.title forState:UIControlStateNormal];
            if (model.titleColor) {
                [button setTitleColor:model.titleColor forState:UIControlStateNormal];
            }
            if (model.selectTitleColor) {
                [button setTitleColor:model.selectTitleColor forState:UIControlStateSelected];
            }
            if (model.backGroundColor) {
                [button setBackgroundColor:model.backGroundColor];
            }
            if (model.selectBackGroundColor) {
                //什么用？
            }
            if (model.textFont != 0) {
                button.titleLabel.font = [UIFont systemFontOfSize:model.textFont];
            }
            button.tag = model.tag;
            [button addTarget:self action:@selector(buyShopButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }else
    {
        [self.bottomView addSubview:self.buttomButton];
        [self.buttomButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.bottomView);
            
        }];
        
    }
    
    
}

-(void)changeShopCountButtonOnClick:(NSInteger)count
{
    if ([self.selectModel.store integerValue] < count) {
        ShowAutoHideMBProgressHUD(self.view, @"超过库存最大数！");
        return;
    }
    self.selectModel.selectCount = count;
}


-(void)changeButtonOnClick:(NSArray *)locationArray
{
    
    
#pragma -mark 该操作主要为置空操作
    //未选择的属性
    NSMutableArray * selectSpecMuArray = [NSMutableArray array];
    
    if (locationArray.count == 0) {
        //当一个都没有选择的时候进行置空操作
        for (FMShopSpecStringModel * modelString in self.stringDataSource) {
            for (FMSpecStringModel * strModel in modelString.styleStrings) {
                
                strModel.product_id = nil;
                strModel.store = 0;
                
            }
        }
    }else//置空
    {
        
        for (FMShopSpecStringModel * modelString in self.stringDataSource) {
            for (FMShopCollectionInfoModel * oldCollectionInfoModel in locationArray) {
                //如果属性相等，就讲除选中的属性值之外的所有属性进行置空操作
                if ([modelString.spec_name isEqualToString:oldCollectionInfoModel.spec_name]) {
                    
                    for (FMSpecStringModel * strModel in modelString.styleStrings) {
                        
                        //没有选中的属性
                        strModel.product_id = nil;
                        strModel.store = 0;
                        
                        if (![oldCollectionInfoModel.contentString isEqualToString:strModel.spec_name_value]) {
                            
                            
                        }else
                        {
                            //选中了一个属性。
                            [selectSpecMuArray addObject:strModel];
                            
                        }
                        
                    }
                }else
                {
                    //如果属性值不相等，就将内容全部置空
                    for (FMSpecStringModel * strModel in modelString.styleStrings) {
                        
                        strModel.product_id = nil;
                        strModel.store = 0;
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    NSMutableArray * selectSpec_product_id_muArray = [NSMutableArray array];
    //选中的样式的所有product组成的集合
    for (FMSpecStringModel * strModel in selectSpecMuArray) {
        
        //获取选中样式的所有product_ID
        for (FMALLSpecDescInfo * specDesc in self.specDataSource) {
            if ([specDesc.kStyle isEqualToString:strModel.spec_name_value]) {
                
                for (NSString * product_id in specDesc.vProductId) {
                    [selectSpec_product_id_muArray addObject:product_id];
                }
            }
        }
        
    }
    NSSet *selectSet = [NSSet setWithArray:selectSpec_product_id_muArray];
    NSArray *resultArraySelectSet = [selectSet allObjects];
    
    for (FMShopSpecStringModel * modelString in self.stringDataSource) {
        for (FMShopCollectionInfoModel * oldCollectionInfoModel in locationArray) {
            if (![modelString.spec_name isEqualToString:oldCollectionInfoModel.spec_name]) {
                
                for (FMSpecStringModel * model in modelString.styleStrings) {
                    [self changeModel:model WithSelectArray:resultArraySelectSet];
                }
                
                
            }
            
            
        }
    }
    
    self.selectModel.locationArray = locationArray;
    
#pragma -mark 该操作为头部UI赋值
    NSMutableString * selectString = [NSMutableString string];//选中的样式
    NSArray * productStringMuArray;
    
    for (FMShopCollectionInfoModel * oldCollectionInfoModel in locationArray) {
        NSMutableArray * linshiArray = [NSMutableArray array];
        
        [selectString appendString:oldCollectionInfoModel.spec_name];
        [selectString appendString:@":"];
        [selectString appendString:oldCollectionInfoModel.contentString];
        [selectString appendString:@"   "];
        
        //获取选中样式的所有product_ID
        for (FMALLSpecDescInfo * specDesc in self.specDataSource) {
            if ([specDesc.kStyle isEqualToString:oldCollectionInfoModel.contentString]) {
                
                for (NSString * product_id in specDesc.vProductId) {
                    [linshiArray addObject:product_id];
                }
            }
        }
        
        if (!productStringMuArray) {
            productStringMuArray = linshiArray;
        }else
        {
            productStringMuArray = [self getReplaceModelWith:productStringMuArray withArray:linshiArray];
            
        }
    }
    
    
    
    
    //判断哪个没有选择
    if (locationArray.count == 0) {
        self.selectModel.unselectInfo = KDefaultInitString;
        self.selectModel.isAllShopInfo = NO;
    }else if (locationArray.count < self.stringDataSource.count)
    {
        self.selectModel.isAllShopInfo = NO;
        NSString * unSelectString;
        for ( FMShopSpecStringModel * modelString in self.stringDataSource) {
            
            for (FMShopCollectionInfoModel * oldCollectionInfoModel in locationArray) {
                
                if (![modelString.spec_name isEqualToString:oldCollectionInfoModel.spec_name]) {
                    unSelectString = [NSString stringWithFormat:@"请选择：%@",modelString.spec_name];
                    break;
                }
            }
        }
        
        self.selectModel.unselectInfo = unSelectString;
    }else
    {
        self.selectModel.isAllShopInfo = YES;
        self.selectModel.unselectInfo = selectString;
    }
    
    
    
    NSArray *resultArray = productStringMuArray;
    
    if (resultArray.count == 0) {
        
        //ShowAutoHideMBProgressHUD(self.view, @"获取库存出错！");
        
    }else if (resultArray.count == 1)
    {
        FMALLShopModelInfo * selectProductModel;
        NSString * selectString_product_id = resultArray[0];
        for (FMALLShopModelInfo * productModel in self.productDataSource) {
            if ([productModel.product_id integerValue] == [ selectString_product_id integerValue]) {
                selectProductModel = productModel;
            }
        }
        
        if (selectProductModel) {
            self.selectModel.product_id = selectProductModel.product_id;
            self.selectModel.price = selectProductModel.price;
            self.selectModel.priceDetail = selectProductModel.price_desc;
            self.selectModel.currentStyle = selectString;
            self.selectModel.image = selectProductModel.image;
            self.selectModel.store = [NSNumber numberWithInteger:100] ;
            [self setUpUIDataWithModel:self.selectModel];
        }
        
    }else
    {

        NSString * currentImage;
        
        for (FMALLShopModelInfo * productModel in self.productDataSource) {
            
            for (NSString *  product_id in resultArray) {
                if ([productModel.product_id integerValue] == [product_id integerValue]) {
                    if (!currentImage) {
                        currentImage = productModel.image;
                    }
                  
                }
            }
        }
        
        
        self.selectModel.currentStyle = selectString;
        self.selectModel.store = [NSNumber numberWithInteger:100];
        self.selectModel.image = currentImage;
        [self setUpUIDataWithModel:self.selectModel];
        
    }
    
    //#warning 刷新
    [self.collectionView changeModelDataSource:self.stringDataSource];
    
    
}

-(NSArray *)getReplaceModelWith:(NSArray *)array1 withArray:(NSArray *)array2
{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF IN %@",array1];
    
    NSArray * filter = [array2 filteredArrayUsingPredicate:filterPredicate];
    return filter;
}

-(void)changeModel:(FMSpecStringModel * )model WithSelectArray:(NSArray *)selectArray
{
    //获取选中样式的所有product_ID
    NSMutableArray * productStringMuArray = [NSMutableArray array];
    
    for (FMALLSpecDescInfo * specDesc in self.specDataSource) {
        if ([specDesc.kStyle isEqualToString:model.spec_name_value]) {
            
            for (NSString * product_id in specDesc.vProductId) {
                [productStringMuArray addObject:product_id];
            }
        }
    }
    
    if (selectArray.count == 0) {
        
        model.product_id = @"-1101";
        model.store = [NSNumber numberWithInteger:100];
        
        
    }else
    {
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF IN %@",selectArray];
        
        NSArray * filter = [productStringMuArray filteredArrayUsingPredicate:filterPredicate];
        
        
        NSInteger storeCount = 100;
        
        for (FMALLShopModelInfo * productModel in self.productDataSource) {
            
            for (NSString *  product_id in filter) {
                NSString * string_product = [NSString stringWithFormat:@"%@",product_id];
                if ([productModel.product_id integerValue]== [string_product integerValue]) {
                    storeCount += [productModel.store integerValue];
                    
                }
            }
        }
        
        model.product_id = @"-1100";
        model.store = [NSNumber numberWithInteger:storeCount];
        
        
    }
    
}



#pragma -mark 设置除collectionView之外的所有UI控件
//设置除collectionView之外的所有UI控件
-(void)setUpUIDataWithModel:(FMSelectShopModelNew *)model
{
    if (model.isAllShopInfo) {
        if (model.currentStyle.length > 0) {
            self.selectLabel.text = [NSString stringWithFormat:@"已选： %@",model.currentStyle];
        }
    }else
    {
        if (model.unselectInfo.length > 0) {
            self.selectLabel.text = model.unselectInfo;
        }
    }
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"优商城首页-活动区-加载中-264x268"]];
   
    
    
    if ([self.buttonStyle.type integerValue] == 1) {
        self.moneyImageView.hidden = NO;
        self.priceLabel.hidden = YES;
         
        if ([self.buttonStyle.unit_cost integerValue] == 1) {
            [self.moneyImageView setImage:[UIImage imageNamed:@"全新1币得"]];
        }else if([self.buttonStyle.unit_cost integerValue] == 5)
        {
            [self.moneyImageView setImage:[UIImage imageNamed:@"全新5币得"]];
        }
        
    }else
    {
        self.moneyImageView.hidden = YES;
        self.priceLabel.hidden = NO;
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",   [NSString stringWithFormat:@"%.2f",[self.buttonStyle.won_cost floatValue]]];
        
    }
    [self getProductStore:model.product_id];
    
}

-(void)getProductStore:(NSString *)product_id
{
    
    int timestamp = [[NSDate date]timeIntervalSince1970];
    NSString *token=EncryptPassword([NSString stringWithFormat:@"appid=huiyuan&user_id=%@&shijian=%d",[CurrentUserInformation sharedCurrentUserInfo].userId,timestamp]);
    
    NSDictionary * paras = @{@"appid":@"huiyuan",
                             @"user_id":[CurrentUserInformation sharedCurrentUserInfo].userId,
                             @"shijian":[NSNumber numberWithInt:timestamp],
                             @"token":[token lowercaseString],
                             @"tel":[CurrentUserInformation sharedCurrentUserInfo].mobile,
                             @"product_id":product_id};
    
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/public/order/getProductInventory",kXZTestEnvironment];
    
    
    /**
     *  在获取商品属性的时候查询商品库存
     */
    //@"https://www.rongtuojinrong.com/java/public/order/getProductInventory"
    
    [FMHTTPClient postPath:urlStr parameters:paras completion:^(WebAPIResponse *response) {
        
        
        
        if (response.code == WebAPIResponseCodeSuccess) {
            NSDictionary * data = response.responseObject[@"data"];
            if (data[@"inventory"]) {
                
                self.selectModel.store = data[@"inventory"];
                
                if ([self.selectModel.store isMemberOfClass:[NSNull class]]) {
                    self.selectModel.store = [NSNumber numberWithInteger:0];
                    
                    [self changeButtonColor];
                }else
                {
                    [self changeButtonColor];
                }
            }
        }
    }];

}

-(void)changeButtonColor
{
    if ([self.selectModel.store integerValue] > 0) {
        [self.buttomButton setBackgroundColor:[HXColor colorWithHexString:@"003d90"]];
    }else
    {
         [self.buttomButton setBackgroundColor:[HXColor colorWithHexString:@"cccccc"]];
    }
}


-(void)showSelectViewWithDataSource:(NSArray *)dataSource WithLocationModel:(NSArray *)locationArray;
{
    
    if (self.isShowCount) {
        self.collectionView.showCountType = FMSelectShopCollectionViewTypeShowCount;
    }
    
    [self.collectionView setcollectionViewDataSource:dataSource WithSelectModel:locationArray];
    
    [self showView];
}
-(void)showView
{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    CGPoint origin_point = [self.view convertPoint:self.view.frame.origin toView:window];
    
    if (origin_point.y > 0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.whiteView.frame = CGRectMake(0, KProjectScreenHeight * (1 - KDefaultScreenHeigh) - (origin_point.y * 0.5), KProjectScreenWidth, KProjectScreenHeight * KDefaultScreenHeigh);
        }];
        
    }else
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.whiteView.frame = CGRectMake(0, KProjectScreenHeight * (1 - KDefaultScreenHeigh), KProjectScreenWidth, KProjectScreenHeight * KDefaultScreenHeigh);
        }];
        
    }
    
    
}

-(void)hiddenSelectView;
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.whiteView.frame = CGRectMake(0, self.view.bounds.size.height + 20, KProjectScreenWidth, KProjectScreenHeight * KDefaultScreenHeigh);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)buyShopButtonOnClick:(UIButton *)button
{
    if (!self.selectModel.isAllShopInfo) {
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"购买信息提示" message:self.selectModel.unselectInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    if (!([self.selectModel.store integerValue] > 0)) {
        
        ShowAutoHideMBProgressHUD(self.view,@"该样式库存为0,请重新选择！");
        return;
    }
    
    
    [self closeViewController:101];
    
    
}

-(void)createPresentModel:(FMSelectShopInfoModel *)presentModel;
{
    
    self.product_id = presentModel.product_id;
    
   
    self.lastSelectCount = presentModel.selectCount;
    self.presentModel = presentModel;
}

-(FMSelectShopInfoModel *)retSelectModel:(FMSelectShopModelNew *)model
{
    
    FMSelectShopInfoModel * selectModel = [[FMSelectShopInfoModel alloc]init];
    selectModel.gid = self.selectModel.gid;
    selectModel.title = self.presentModel.title;
    selectModel.product_id = [NSString stringWithFormat:@"%@",model.product_id];
    selectModel.image = model.image;
    selectModel.locationArray = self.selectModel.locationArray;
    selectModel.mktPrice = self.presentModel.mktPrice;
    selectModel.brief = self.presentModel.brief;
    selectModel.isLoadActivity = self.presentModel.isLoadActivity;
    selectModel.fav = self.presentModel.fav;
    selectModel.locationArray = model.locationArray;
    selectModel.currentStyle = model.currentStyle;
    selectModel.store = model.store;
    selectModel.selectCount = model.selectCount;
    selectModel.jifen = self.presentModel.jifen;
    selectModel.isAllShopInfo = model.isAllShopInfo;
    selectModel.unselectInfo = model.unselectInfo;
    selectModel.shopListIndexPath = self.presentModel.shopListIndexPath;
    return selectModel;
    
}

#pragma -mark 有关懒加载的相关东西

-(UIButton *)closeButton {
    
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeButton addTarget:self action:@selector(grayButtonOnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_closeButton setImage:[UIImage imageNamed:@"t4"] forState:(UIControlStateNormal)];
    }
    return _closeButton;
}


-(UIButton *)buttomButton {
    
    if (!_buttomButton) {
        _buttomButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_buttomButton addTarget:self action:@selector(buyShopButtonOnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_buttomButton setBackgroundColor:[HXColor colorWithHexString:@"003d90"]];
        [_buttomButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buttomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _buttomButton;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
        _photoView.layer.masksToBounds=YES;
        _photoView.layer.cornerRadius = 3;
        _photoView.layer.borderColor = [UIColor whiteColor].CGColor;
        _photoView.layer.borderWidth = 2;
        _photoView.backgroundColor = [UIColor purpleColor];
    }
    return _photoView;
}


- (UIImageView *)moneyImageView {
    if (!_moneyImageView) {
        _moneyImageView = [[UIImageView alloc]init];
    }
    return _moneyImageView;
}


-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.text = @"2480.00";
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor =[HXColor colorWithHexString:@"#ff6633"];
    }
    return _priceLabel;
}

-(UILabel *)selectLabel
{
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc]init];
        _selectLabel.text = @"已选: ";
        _selectLabel.numberOfLines = 0;
        _selectLabel.font = [UIFont systemFontOfSize:12];
        _selectLabel.textColor = [HXColor colorWithHexString:@"#333333"];
    }
    return _selectLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        //        _lineView.backgroundColor = [HXColor colorWithHexString:@"#cccccc"];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        
    }
    return _bottomView;
}
-(FMSelectDuobaoShopCollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView =  [[FMSelectDuobaoShopCollectionView alloc]init];
    }
    return _collectionView;
}


/*
 #pragma mark - Navigation
 
 In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 Get the new view controller using [segue destinationViewController].
 Pass the selected object to the new view controller.
 }
 
 
 
 
 */


#pragma -mark 有关北京的相关东西
-(void)grayButtonOnClick:(UIButton *)button
{
    [self closeViewController:401];
}


-(void)closeViewController:(NSInteger)isReturn
{
    [self hiddenSelectView];
    __weak __typeof(&*self)weakSelf = self;
    if (isReturn == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if(isReturn == 401)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf retCloseBlock];
        }];
        
    }else if(isReturn == 101)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf retSuccessBlock];
        }];
        
    }
    
}
-(void)retCloseBlock
{
    if (self.closeBlock) {
        self.closeBlock(self.selectModel);
    }
}
-(void)retSuccessBlock
{
    if (self.successBlock) {
        self.successBlock(self.selectModel,self.buttonStyle);
    }
    
}

-(void)createBackGroundViewWithImageView
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIButton * grayButton = [[UIButton alloc]init];
    [grayButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.15]];
    [grayButton addTarget:self action:@selector(grayButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayButton];
    [grayButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(self.view.mas_height);//.multipliedBy(1 - KDefaultScreenHeigh);
    }];
    [self.view bringSubviewToFront:grayButton];
    
}

@end
