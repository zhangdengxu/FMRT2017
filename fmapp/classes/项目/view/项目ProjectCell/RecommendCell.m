//
//  RecommendCell.m
//  fmapp
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "RecommendCell.h"
#import "ProgressCircleView.h"

#define KProjectDetailTag         10000
#define KCircleOuterRadius          55.0f

#define KCircleOuterImageColor      [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f]


@interface RecommendCell ()

@property (nonatomic, weak)   UILabel               *titleLabel;
@property (nonatomic, weak)   UIImageView           *logoImage;
@property (nonatomic, weak)   UILabel               *companyLabel;
@property (nonatomic, weak)   UIProgressView        *progressView;
@property (nonatomic, weak)   UILabel               *progressLabel;
@property (nonatomic, strong) ProjectModel          *model;
@property (nonatomic, strong) UILabel               *timeLabel;
@property (nonatomic, strong) UILabel               *timeGoesBy;
@property (nonatomic, strong) ProgressCircleView    *MyprogressView;
@property (nonatomic, strong) UIImageView           *littleImageV;
@end

@implementation RecommendCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.littleImageV.frame = CGRectMake(10, 20, 35, 13);
        [self.contentView addSubview:self.littleImageV];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KProjectScreenWidth, 7)];
        lineView.backgroundColor = KDefaultOrBackgroundColor;
        [self.contentView addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 200)];
        lineView1.backgroundColor = KDefaultOrBackgroundColor;
        [self.contentView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-5, 0, 5, 200)];
        lineView2.backgroundColor = KDefaultOrBackgroundColor;
        [self.contentView addSubview:lineView2];

        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, KProjectScreenWidth - 110 - 10, 14)];
        titleLabel.textColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.6];
        titleLabel.font=[UIFont systemFontOfSize:13.0f];
        self.titleLabel=titleLabel;
        titleLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:titleLabel];
        
        UILabel *theTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KProjectScreenWidth-75, 20, 75, 14)];
        theTimeLabel.font = [UIFont systemFontOfSize:12];
        theTimeLabel.textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.6];
        self.timeLabel = theTimeLabel;
        [self.contentView addSubview:theTimeLabel];
        
        ProgressCircleView *cir =[[ProgressCircleView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-KCircleOuterRadius-20, 50.0f, KCircleOuterRadius, KCircleOuterRadius)];
        cir.pregressValue = 1.0;
        cir.pregressColor = KCircleOuterImageColor;
        [self.contentView addSubview:cir];
        
        self.MyprogressView = [[ProgressCircleView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-KCircleOuterRadius-20, 50.0f, KCircleOuterRadius, KCircleOuterRadius)];
        self.MyprogressView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.MyprogressView];

        UILabel *circleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (KCircleOuterRadius-15)/2, KCircleOuterRadius, 15)];
        circleLabel.backgroundColor = [UIColor clearColor];
        circleLabel.textAlignment = NSTextAlignmentCenter;
        circleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.timeGoesBy = circleLabel;
        [self.MyprogressView addSubview:circleLabel];
        
       CGFloat width=KProjectScreenWidth/4.0f;
        for(int i=0;i<3;i++){
            UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 63, width, 20)];
            contentLabel.tag=KProjectDetailTag+i;
            contentLabel.textColor=KContentTextColor;
            if (i==0) {
                contentLabel.textColor=[UIColor colorWithRed:0.93 green:0.28 blue:0.08 alpha:1];
            }
            contentLabel.textAlignment=NSTextAlignmentCenter;
            contentLabel.font=[UIFont systemFontOfSize:14];
            [self.contentView addSubview:contentLabel];

            UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cellButton setBackgroundColor:[UIColor clearColor]];
            [cellButton setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 120)];
            [cellButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:cellButton];
        }
    }
    return self;
}

- (void) displayQuestion:(ProjectModel* )model{
    
    self.model=model;
    if ([model.zhuangtai integerValue] == 10 ||[model.zhuangtai integerValue] == 4) {
        if ([model.rongzifangshi isEqualToString:@"3"]) {
            
            if ([model.qixian integerValue] <= 4) {
                [_littleImageV setImage:[UIImage imageNamed:@"融益盈_03"]];
            }else
            {
                [_littleImageV setImage:[UIImage imageNamed:@"融稳盈_03"]];
            }
            
        }else if ([model.rongzifangshi isEqualToString:@"2"]){
            
            
        }else if ([model.rongzifangshi isEqualToString:@"1"]){
            
            [_littleImageV setImage:[UIImage imageNamed:@"融抵押_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"4"]){
            
            [_littleImageV setImage:[UIImage imageNamed:@"融保理_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"5"])
        {
            [_littleImageV setImage:[UIImage imageNamed:@"经营贷_03"]];
        }
    }else{
        if ([model.rongzifangshi isEqualToString:@"3"]) {
            
            if ([model.qixian integerValue] <= 4) {
                [_littleImageV setImage:[UIImage imageNamed:@"融益盈-灰_03"]];
            }else
            {
                [_littleImageV setImage:[UIImage imageNamed:@"融稳盈-灰_03"]];
            }
            
        }else if ([model.rongzifangshi isEqualToString:@"2"]){
            
            
        }else if ([model.rongzifangshi isEqualToString:@"1"]){
            
            [_littleImageV setImage:[UIImage imageNamed:@"融抵押-灰_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"4"]){
            
            [_littleImageV setImage:[UIImage imageNamed:@"融保理-灰_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"5"])
        {
            [_littleImageV setImage:[UIImage imageNamed:@"经营贷-灰_03"]];
        }
    }
    
  
    
    NSString *subStr = [model.start_time substringWithRange:NSMakeRange(0, 10)];
    self.timeLabel.text = subStr;
    
    self.titleLabel.text=model.title;
    
    self.MyprogressView.pregressColor = [FMThemeManager skin].navigationBarNewTintColor;
    self.MyprogressView.pregressValue = model.jindut;
    
    int style=[model.rongzifangshi intValue];
    if (style==1){
        self.logoImage.image=[UIImage imageNamed:@"diya.png"];
    }
    else if (style==2){
        self.logoImage.image=[UIImage imageNamed:@"piaoju.png"];
    }else{
        self.logoImage.image=[UIImage imageNamed:@"firsr_2.png"];
    }
    
    self.companyLabel.text=model.danbaocompany;

    [self.progressView setProgress:model.jindut animated:NO];

    self.progressLabel.text=[NSString stringWithFormat:@"%@%%",model.jindu];
    
    
    NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",model.lilv],[NSString stringWithFormat:@"%@",model.projectMoney],[self judgeCurrentType:model], nil];
    NSArray *attrContentArr=[[NSArray alloc]initWithObjects:model.lilv,@"万",model.qixian, nil];

    for(int i=0;i<3;i++){
        
        UILabel *contentLabel=(UILabel *)[self.contentView viewWithTag:KProjectDetailTag+i];
        
        NSString *content=contentArr[i];
        NSRange range=[content rangeOfString:attrContentArr[i]];//长的content
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        if (i==1) {
            
            contentLabel.font=[UIFont systemFontOfSize:22];
            [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0f] range:range];
            [attriContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.6] range:range];
            contentLabel.attributedText=attriContent;
            
        }else if(i == 2) {
            contentLabel.font=[UIFont systemFontOfSize:22];
            NSString * qixian = model.qixian == nil ? @"1" : model.qixian;
            if ([qixian floatValue] < 1) {
                NSRange range=[content rangeOfString:@"天"];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0f] range:range];
                [attriContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.6] range:range];
                contentLabel.attributedText=attriContent;
                
            }else{
                
                NSRange range=[content rangeOfString:@"个月"];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0f] range:range];
                [attriContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:.6] range:range];
                contentLabel.attributedText=attriContent;
            }
        }else{
            [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22.0f] range:range];
            contentLabel.attributedText=attriContent;
            
        }
    }
    
    if (self.model.kaishicha>0) {
        
        [self.finishButton setTitle:[NSString stringWithFormat:@"开抢时间:%@",model.start_time]
                      forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *subStr1 = [model.start_time substringWithRange:NSMakeRange(10, 6)];
        self.timeGoesBy.textColor = [UIColor colorWithRed:137/155.0f green:79/255.0f blue:46/255.0f alpha:1];
        self.timeGoesBy.text = subStr1;
    }else if(self.model.projectStyle==10){
        [self.finishButton setTitle:@"立即投资"
                      forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeGoesBy.textColor = [UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1];
        if ([model.jindu isEqualToString:@"100"]) {
            
            if (self.model.projectStyle==4) {
                self.timeGoesBy.text = @"满标";
            }else
            {
                self.timeGoesBy.text = @"售罄";
            }
            
            
        }else{
        
            self.timeGoesBy.text = [NSString stringWithFormat:@"%@%%",model.jindu];
            self.timeGoesBy.textColor = [UIColor colorWithRed:137/155.0f green:79/255.0 blue:46/255.0f alpha:1];
        }
    }else{
        [self.finishButton setTitle:@"查看详情"
                      forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(bottombtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeGoesBy.textColor = [UIColor colorWithRed:14/255.0f green:93/255.0f blue:210/255.0f alpha:1];
        if ([model.jindu isEqualToString:@"100"]) {
            
            if (self.model.projectStyle==4) {
                self.timeGoesBy.text = @"满标";
            }else
            {
                self.timeGoesBy.text = @"售罄";
            }

        }else{
            
            self.timeGoesBy.text = [NSString stringWithFormat:@"%@%%",model.jindu];
        }
    }
}

-(NSString *)judgeCurrentType:(ProjectModel *)model{
    
    NSString * qixian = model.qixian == nil ? @"1" : model.qixian;
    NSString * retTianshu ;
    if ([qixian floatValue] < 1) {
        retTianshu = [NSString stringWithFormat:@"%d天",model.tianshu];
    }else{
        retTianshu = [NSString stringWithFormat:@"%@个月",model.qixian];
    }
    return retTianshu;
}

- (void)bottombtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(CellBtnClickDelegate:)]) {
        [self.delegate CellBtnClickDelegate:self.model];
    }
}

- (UIImageView *)littleImageV{
    if (!_littleImageV) {
        _littleImageV = [[UIImageView alloc]init];
        _littleImageV.backgroundColor = KDefaultOrNightBackGroundColor;
    }
    return _littleImageV;
}

@end
