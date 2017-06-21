//
//  ProjectCell.m
//  fmapp
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ProjectCell.h"
#define KCircleOuterRadius          55.0f
#define KCircleBorderWidth          2.5f
#define KCircleInsideRadius         (55.0f - KCircleBorderWidth*2)

#define KCircleOuterImageColor      [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f]
#define KCornerRadiusBorderColor    [UIColor colorWithRed:20.0f/255.0f green:153.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

#define KContentLabelTag           10001
#define KTitleLabelTag             20001

@interface ProjectCell()

@property (nonatomic,weak) UILabel  *titleLabl;
@property (nonatomic,weak) UILabel  *companyLabl;
@property (nonatomic,weak) UIImageView *corImageView;
@property (nonatomic,weak) UILabel  *progressLabel;
@property (nonatomic,weak) UILabel  *repayLabel;
@property (nonatomic,weak) UIView   *bottomLineView;
@property (nonatomic,weak) UIView   *dateView;
@property (nonatomic,weak) UIImageView *danImageView;
@property (nonatomic,weak) UILabel  *dateContentLabel;

@end

@implementation ProjectCell

/*
 if ([model.rongzifangshi isEqualToString:@"3"]) {
 UIImageView *littleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 13, 13)];
 [littleImageV setImage:[UIImage imageNamed:@"担icon"]];
 [self.contentView addSubview:littleImageV];
 }else
 {
 //dang_small_icon
 UIImageView *littleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 13, 13)];
 [littleImageV setImage:[UIImage imageNamed:@"dang_small_icon.png"]];
 [self.contentView addSubview:littleImageV];
 }

 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        图片“担”
        UIImageView *danImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 35, 13)];
        [danImage setImage:[UIImage imageNamed:@"担icon"]];
        danImage.backgroundColor = [UIColor redColor];
        self.danImageView = danImage;
        [self.contentView addSubview:danImage];

        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, KProjectScreenWidth-50-16-100, 16)];
    
        titleLable.font = [UIFont systemFontOfSize:15.0f];
        [titleLable setTextColor:KContentTextColor];
        [titleLable setBackgroundColor:[UIColor clearColor]];
   
        self.titleLabl = titleLable;
        [self addSubview:titleLable];
        
        UILabel *companyLable = [[UILabel alloc]init];
        companyLable.font = [UIFont systemFontOfSize:11.0f];
        [companyLable setTextColor:[UIColor whiteColor]];
        [companyLable setBackgroundColor:[UIColor colorWithRed:96.0/255.0 green:201.0/255.0 blue:255.0/255.0 alpha:1]];
        self.companyLabl = companyLable;
        [self addSubview:companyLable];

        UIImageView *outerCircleImage = [[UIImageView alloc]initWithFrame:CGRectMake(KProjectScreenWidth-10-65, 60.0f, KCircleOuterRadius, KCircleOuterRadius)];
        [outerCircleImage setBackgroundColor:KCircleOuterImageColor];
        
        [outerCircleImage.layer setMasksToBounds:YES];
        [outerCircleImage.layer setCornerRadius:KCircleOuterRadius/2];
        self.corImageView=outerCircleImage;
        [self addSubview:outerCircleImage];
        
        UIImageView *coverImage = [[UIImageView alloc]init];
        [coverImage setBackgroundColor:KDefaultOrNightBackGroundColor];
        [coverImage setFrame:CGRectMake(KCircleBorderWidth, KCircleBorderWidth,
                                        KCircleInsideRadius,
                                        KCircleInsideRadius)];
        [coverImage.layer setMasksToBounds:YES];
        [coverImage.layer setCornerRadius:KCircleInsideRadius/2];
        [outerCircleImage addSubview:coverImage];
        
        UILabel *progressLabel=[[UILabel alloc]initWithFrame:coverImage.bounds];
        progressLabel.textAlignment=NSTextAlignmentCenter;
        progressLabel.backgroundColor=[UIColor clearColor];
        self.progressLabel=progressLabel;
        [coverImage addSubview:progressLabel];
        
        CGFloat width=(KProjectScreenWidth-30-65)/3;

        for(int i=0;i<3;i++)
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 58, width, 15)];

            label.textColor=[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            label.tag=KTitleLabelTag+i;
            [self addSubview:label];

            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 83, width, 20)];////new
            contentlabel.tag=KContentLabelTag+i;
            contentlabel.textColor=KContentTextColor;

            if (i==0) {
                contentlabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
            }
            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            contentlabel.font=[UIFont boldSystemFontOfSize:12];
            [self addSubview:contentlabel];
            
            if(i>0)
            {
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width*i, 55, 0.5f, 50)];
            lineView.backgroundColor=KSepLineColorSetup;
            [self addSubview:lineView];
            }
            
        }
        
        UIImageView *repayImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 105, 15, 15)];
        repayImage.image=[UIImage imageNamed:@"project.png"];
        
        UILabel *repayLabel=[[UILabel alloc]initWithFrame:CGRectMake(27, 105, KProjectScreenWidth-10-27, 15)];
        repayLabel.backgroundColor=[UIColor clearColor];
        repayLabel.font=[UIFont systemFontOfSize:12.0f];
        repayLabel.textColor=[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1];
        self.repayLabel=repayLabel;
        
        UIView *dateView=[[UIView alloc]init];
        dateView.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        self.dateView=dateView;
        dateView.hidden=YES;
        [self addSubview:dateView];
        
        UIImageView *dateImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        dateImage.image=[UIImage imageNamed:@"date.png"];
        [dateView addSubview:dateImage];
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 7.5, 80, 15)];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.text=@"过期时间:";
        dateLabel.textColor=KContentTextColor;
        dateLabel.font=[UIFont systemFontOfSize:13.0f];
        [dateView addSubview:dateLabel];
        
        UILabel *dateContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 7.5, 200, 15)];
        dateContentLabel.backgroundColor=[UIColor clearColor];
        dateContentLabel.textColor=[UIColor redColor];
        dateContentLabel.font=[UIFont systemFontOfSize:13.0f];
        self.dateContentLabel=dateContentLabel;
        [dateView addSubview:dateContentLabel];
        
        UIView *bottomView=[[UIView alloc]init];
        self.bottomLineView=bottomView;
        self.bottomLineView.backgroundColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self addSubview:bottomView];
        
    }
    return self;
}
- (void) disClaimsArea:(ProjectModel* )model
{
    int style=[model.rongzifangshi intValue];
    if (style==1) {
        self.danImageView.image=[UIImage imageNamed:@"diya.png"];
    }
    else if (style==2)
    {
        self.danImageView.image=[UIImage imageNamed:@"piaoju.png"];
    }
    else
    {
        self.danImageView.image=[UIImage imageNamed:@"firsr_2.png"];
    }
    
//    
//    if ([model.rongzifangshi isEqualToString:@"3"]) {
//        self.danImageView.image=[UIImage imageNamed:@"担icon"];
//        
//    }else
//    {
//        //dang_small_icon
//       self.danImageView.image=[UIImage imageNamed:@"dang_small_icon.png"];
//        
//    }

    

    self.titleLabl.text=model.projectTitle;
    
    NSString *companyStr=[NSString stringWithFormat:@" %@ ",model.projectCompany];
    CGSize comSize=[companyStr sizeWithFont:self.companyLabl.font];
    self.companyLabl.frame=CGRectMake(KProjectScreenWidth-10-60, 13, comSize.width, 15);
    self.companyLabl.text=companyStr;
    
    
    if (model.projectStyle==8) {
        
        self.progressLabel.text=@"售罄";
        self.progressLabel.numberOfLines=2;
        self.progressLabel.textColor=[FMThemeManager skin].navigationBarTintColor;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle: M_PI/2*3
                     clockwise:YES];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
        self.progressLabel.font=[UIFont systemFontOfSize:14];

    }
    else if (model.projectStyle==4) {
        
        self.progressLabel.text=@"满标";
        self.progressLabel.textColor=[FMThemeManager skin].navigationBarTintColor;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/3
                    startAngle:-M_PI/2
                      endAngle: M_PI/2*3
                     clockwise:YES];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
        self.progressLabel.font=[UIFont systemFontOfSize:14];
        
    }
    else if (model.projectStyle==6) {
        
        self.progressLabel.text=@"售罄";
        self.progressLabel.textColor=[FMThemeManager skin].navigationBarTintColor;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/3
                    startAngle:-M_PI/2
                      endAngle: M_PI/2*3
                     clockwise:YES];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
        self.progressLabel.font=[UIFont systemFontOfSize:14];
        
    }
    else
    {
        self.progressLabel.font=[UIFont systemFontOfSize:12.0f];
        self.progressLabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
        NSString *content=[NSString stringWithFormat:@"%@%%",model.jindu];
        NSRange range=[content rangeOfString:[NSString stringWithFormat:@"%@",model.jindu]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:range];
        self.progressLabel.attributedText=attriContent;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        if(model.jindut==1)
        {
            [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                            radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                        startAngle:-M_PI/2
                          endAngle:M_PI/2*3
                         clockwise:YES];
        }
        else if (model.jindut==0)
        {
            [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                            radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                        startAngle:-M_PI/2
                          endAngle:-M_PI/2
                         clockwise:YES];
        }
        else
        {
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle:2*M_PI*(1-model.jindut)-M_PI/2
                     clockwise:NO];
        }
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
    }
    
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"认购后收益",@"转让份额",@"剩余期限", nil];
    for(int i=0;i<3;i++)
    {
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",model.projectYearEarn],[NSString stringWithFormat:@"%@",model.jiner],[self judgeCurrentType:model],nil];
        NSArray *cArr=[[NSArray alloc]initWithObjects:model.projectYearEarn,model.jiner,model.projectDate, nil];
        UILabel *titleLabel=(UILabel *)[self viewWithTag:KTitleLabelTag+i];
        titleLabel.text=titleArr[i];
        
        UILabel *contentLabel=(UILabel *)[self viewWithTag:KContentLabelTag+i];
        NSString *content=contentArr[i];
        NSRange range=[content rangeOfString:cArr[i]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        if (i==1) {
            [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.0f] range:range];
        }
        else
        {
            [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:range];
        }
        contentLabel.attributedText=attriContent;
        
        
    }
    
    self.repayLabel.text=model.projectRepayType;
    self.bottomLineView.frame=CGRectMake(0, 180-15-5, KProjectScreenWidth, 15.0f);
    
    [self.dateView setHidden:NO];
    self.dateView.frame=CGRectMake(0, 180-50, KProjectScreenWidth, 30);
    
    self.dateContentLabel.text=[self getSurplusTimesWithendTime:model.SurplusTime];
}

- (void) displayQuestion:(ProjectModel* )model
{
    
//    int style=[model.rongzifangshi intValue];
//    if (style==1) {
//        self.danImageView.image=[UIImage imageNamed:@"diya.png"];
//    }
//    else if (style==2)
//    {
//        self.danImageView.image=[UIImage imageNamed:@"piaoju.png"];
//    }
//    else
//    {
//        self.danImageView.image=[UIImage imageNamed:@"firsr_2.png"];
//    }
    
    if ([model.zhuangtai integerValue] == 10 || [model.zhuangtai integerValue] == 4) {
        
        if ([model.rongzifangshi isEqualToString:@"3"]) {
           
            if ([model.qixian integerValue] <= 4) {
                [self.danImageView setImage:[UIImage imageNamed:@"融益盈_03"]];
            }else
            {
                [self.danImageView setImage:[UIImage imageNamed:@"融稳盈_03"]];
            }
            
        }else if ([model.rongzifangshi isEqualToString:@"2"]){
            
            
        }else if ([model.rongzifangshi isEqualToString:@"1"]){
            
            [self.danImageView setImage:[UIImage imageNamed:@"融抵押_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"4"]){
            
            [self.danImageView setImage:[UIImage imageNamed:@"融保理_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"5"])
        {
            [self.danImageView setImage:[UIImage imageNamed:@"经营贷_03"]];
        }
    }else{
        if ([model.rongzifangshi isEqualToString:@"3"]) {
            if ([model.qixian integerValue] <= 4) {
                [self.danImageView setImage:[UIImage imageNamed:@"融益盈-灰_03"]];
            }else
            {
                [self.danImageView setImage:[UIImage imageNamed:@"融稳盈-灰_03"]];
            }
            
        }else if ([model.rongzifangshi isEqualToString:@"2"]){
            
            
        }else if ([model.rongzifangshi isEqualToString:@"1"]){
            
            [self.danImageView setImage:[UIImage imageNamed:@"融抵押-灰_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"4"]){
            
            [self.danImageView setImage:[UIImage imageNamed:@"融保理-灰_03"]];
            
        }else if ([model.rongzifangshi isEqualToString:@"5"])
        {
            [self.danImageView setImage:[UIImage imageNamed:@"经营贷-灰_03"]];
        }
    }
    

    
    self.titleLabl.text=model.projectTitle;
    
//    if (self.titleLabl.text.length > 15) {
//        
//        self.titleLabl.lineBreakMode = NSLineBreakByWordWrapping;
//        self.titleLabl.numberOfLines = 0;
//
//        CGSize size = [self.titleLabl sizeThatFits:CGSizeMake(self.titleLabl.frame.size.width, MAXFLOAT)];
//        self.titleLabl.frame = CGRectMake(28, 16, KProjectScreenWidth-28-16-100, size.height);
//
//    }
    
    NSString *companyStr=[NSString stringWithFormat:@" %@ ",model.projectCompany];
    CGSize comSize=[companyStr sizeWithFont:self.companyLabl.font];
    self.companyLabl.frame=CGRectMake(KProjectScreenWidth-10-60, 13, comSize.width, 15);
    self.companyLabl.text=companyStr;
    
    if (model.projectStyle==8) {
        
        self.progressLabel.text=@"售罄";
        self.progressLabel.numberOfLines=2;
        self.progressLabel.textColor=[FMThemeManager skin].navigationBarTintColor;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle: M_PI/2*3
                     clockwise:YES];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
        self.progressLabel.font=[UIFont systemFontOfSize:14];

    }
    else if (model.projectStyle==4) {
        
        self.progressLabel.text=@"满标";
        self.progressLabel.textColor=[FMThemeManager skin].navigationBarNewTintColor;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle: M_PI/2*3
                     clockwise:YES];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
        self.progressLabel.font=[UIFont systemFontOfSize:14];
        
    }
    else if (model.projectStyle==6) {
        
        self.progressLabel.text=@"售罄";
        self.progressLabel.textColor=[FMThemeManager skin].navigationBarNewTintColor;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle: M_PI/2*3
                     clockwise:YES];
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];
        
        self.progressLabel.font=[UIFont systemFontOfSize:14];
        
    }
    else
    {
        self.progressLabel.font=[UIFont systemFontOfSize:12.0f];
        self.progressLabel.textColor=[UIColor colorWithRed:0.93 green:0.29 blue:0.17 alpha:1];
        NSString *content=[NSString stringWithFormat:@"%@%%",model.jindu];
        NSRange range=[content rangeOfString:[NSString stringWithFormat:@"%@",model.jindu]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:range];
        self.progressLabel.attributedText=attriContent;
        
        CAShapeLayer *progressLayer;//进度Layer
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        if(model.jindut==1)
        {
            [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                            radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                        startAngle:-M_PI/2
                          endAngle:M_PI/2*3
                         clockwise:YES];
        }
        else if (model.jindut==0)
        {
            [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                            radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                        startAngle:-M_PI/2
                          endAngle:-M_PI/2
                         clockwise:YES];
        }
        else
        {
        [path addArcWithCenter:CGPointMake((KCircleOuterRadius-KCircleBorderWidth)/2, (KCircleOuterRadius-KCircleBorderWidth)/2)
                        radius:(KCircleOuterRadius-KCircleBorderWidth)/2
                    startAngle:-M_PI/2
                      endAngle:2*M_PI*(model.jindut)-M_PI/2
                     clockwise:YES];
        }
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = path.CGPath;//46,169,230
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [FMThemeManager skin].navigationBarNewTintColor.CGColor;
        progressLayer.lineWidth = KCircleBorderWidth;
        progressLayer.frame = CGRectMake(KCircleBorderWidth/2, KCircleBorderWidth/2,(KCircleOuterRadius-KCircleBorderWidth), (KCircleOuterRadius-KCircleBorderWidth));
        [self.corImageView.layer addSublayer:progressLayer];

    }
    
    NSArray *titleArr=[[NSArray alloc]initWithObjects:@"预期年化收益",@"融资金额",@"融资期限", nil];

    for(int i=0;i<3;i++)
    {
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@%%",model.projectYearEarn],[NSString stringWithFormat:@"%@",model.jiner],[self judgeCurrentType:model],nil];
        NSArray *cArr=[[NSArray alloc]initWithObjects:model.projectYearEarn,model.jiner,model.projectDate, nil];

        UILabel *titleLabel=(UILabel *)[self viewWithTag:KTitleLabelTag+i];
        titleLabel.text=titleArr[i];

        UILabel *contentLabel=(UILabel *)[self viewWithTag:KContentLabelTag+i];
        NSString *content=contentArr[i];
        NSRange range=[content rangeOfString:cArr[i]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        if (i==1) {
            
            NSRange range=[model.jiner rangeOfString:@"万"];
            
            NSRange priRange = NSMakeRange(0, range.location);

            
            [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:priRange];
            
            [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:range];
        }
        else
        {
        [attriContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:range];
        }
        contentLabel.attributedText=attriContent;

        
        if (i == 2) {
            contentLabel.font = [UIFont boldSystemFontOfSize:20];
            NSString * qixian = model.projectDate == nil ? @"1" : model.projectDate;
            //                NSString * retTianshu ;
            if ([qixian floatValue] < 1) {
                
                
                NSRange range=[[NSString stringWithFormat:@"%d天",model.tianshu]rangeOfString:@"天"];
                NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:range];
                contentLabel.attributedText=attriContent;
            }else {
                
                NSRange range=[[NSString stringWithFormat:@"%@个月",model.projectDate]rangeOfString:@"个月"];
//                NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@个月",model.projectDate]];
                [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:range];
                contentLabel.attributedText=attriContent;
          
            }
            
        }

    }

    self.repayLabel.text=model.projectRepayType;
    self.bottomLineView.frame=CGRectMake(0, 130.0f, KProjectScreenWidth, 10.0f);

}
-(NSString *)judgeCurrentType:(ProjectModel *)model
{
    NSString * qixian = model.projectDate == nil ? @"1" : model.projectDate;
    NSString * retTianshu ;
    if ([qixian floatValue] < 1) {
        retTianshu = [NSString stringWithFormat:@"%d天",model.tianshu];
    }else
    {
        retTianshu = [NSString stringWithFormat:@"%@个月",model.projectDate];
    }
    return retTianshu;
}
- (NSString *)getSurplusTimesWithendTime:(int)endtime
{
    Log(@"%d",endtime);
    if (endtime<=0) {
        return nil;
    }
    
    return [self intervalSinceNow:endtime];
}

- (NSString * )intervalSinceNow: (NSInteger) theDate

{
    
    NSTimeInterval  cha=theDate;
    
    NSString *days=@"";
    NSString *house=@"";
    NSString *mins=@"";
    NSString *sens=@"";
    
    //秒
    sens = [NSString stringWithFormat:@"%d",(int)cha%60];
    
    if(cha>60)
    {
        //分
        mins = [NSString stringWithFormat:@"%d", (int)cha/60%60];
        
    }
    else
    {
        mins=@"0";
    }
    if (cha>3600)
    {
        //时
        house = [NSString stringWithFormat:@"%d", (int)cha/3600%24];
    }
    else
    {
        house=@"0";
    }
    if (cha>86400) {
        //天
        days = [NSString stringWithFormat:@"%d", (int)cha/86400];
    }
    else
    {
    days=@"0";
    }
    
    NSString *dateStr=[NSString stringWithFormat:@"%@天%@时%@分%@秒",days,house,mins,sens];
    return dateStr;
    
}

- (void)layoutSubviews
{

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
