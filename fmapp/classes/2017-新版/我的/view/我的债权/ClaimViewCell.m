//
//  ClaimViewCell.m
//  fmapp
//
//  Created by apple on 15/3/21.
//  Copyright (c) 2015年 yk. All rights reserved.
//

#import "ClaimViewCell.h"

#define KContentLabelTag           10001


@interface ClaimViewCell ()

@property (nonatomic,weak) UILabel  *titleLabl;
@property (nonatomic,weak) UILabel  *companyLabl;
@property (nonatomic,weak) UIImageView *corImageView;
@property (nonatomic,weak) UILabel  *progressLabel;
@property (nonatomic,weak) UILabel  *repayLabel;
@property (nonatomic,weak) UIView   *bottomLineView;
@property (nonatomic,weak) UIView   *dateView;
@property (nonatomic,weak) UILabel  *dateLabel;

@end

@implementation ClaimViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, KProjectScreenWidth-28, 16)];
        titleLable.font = [UIFont systemFontOfSize:16.0f];
        [titleLable setTextColor:KContentTextColor];
        [titleLable setBackgroundColor:[UIColor clearColor]];
        self.titleLabl = titleLable;
        [self addSubview:titleLable];
        
        NSArray *titleArr=[[NSArray alloc]initWithObjects:@"投资金额",@"预期年化收益",@"项目收益", nil];
        
        for(int i=0;i<3;i++)
        {
            CGFloat width=KProjectScreenWidth/3;
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 48, width, 15)];
            label.text=titleArr[i];
            label.textColor=KContentTextColor;
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            [self addSubview:label];
            
            UILabel *contentlabel=[[UILabel alloc]initWithFrame:CGRectMake(width*i, 73, width, 15)];
            contentlabel.tag=KContentLabelTag+i;
            contentlabel.textColor=KContentTextColor;

            contentlabel.textAlignment=NSTextAlignmentCenter;
            contentlabel.backgroundColor=[UIColor clearColor];
            contentlabel.font=[UIFont systemFontOfSize:15];
            [self addSubview:contentlabel];
            
            if(i>0)
            {
                UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width*i, 45, 0.5f, 50)];
                lineView.backgroundColor=KSepLineColorSetup;
                [self addSubview:lineView];
            }
            
        }
        
        UIView *dateView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, KProjectScreenWidth, 30)];
        dateView.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        self.dateView=dateView;
        [self addSubview:dateView];
        
        UIImageView *dateImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        dateImage.image=[UIImage imageNamed:@"date.png"];
        [dateView addSubview:dateImage];
        
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 7.5, KProjectScreenWidth-30-10, 15)];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.textColor=KContentTextColor;
        dateLabel.font=[UIFont systemFontOfSize:14.0f];
        self.dateLabel=dateLabel;
        [dateView addSubview:dateLabel];
        
        UIView *bottomView=[[UIView alloc]init];
        self.bottomLineView=bottomView;
        self.bottomLineView.backgroundColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        [self addSubview:bottomView];

        
    }
    return self;
}
- (void) disClaimsArea:(ProjectModel* )model
{
    self.titleLabl.text=model.projectTitle;
    
    if (self.titleLabl.text.length > 15) {
        
        self.titleLabl.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabl.numberOfLines = 2;
        
        CGSize size = [self.titleLabl sizeThatFits:CGSizeMake(self.titleLabl.frame.size.width, MAXFLOAT)];
        self.titleLabl.frame = CGRectMake(10, 10, KProjectScreenWidth-28, size.height);
        
    }

    for(int i=0;i<3;i++)
    {
        NSArray *contentArr=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",model.projectMoney],[self retJudegWithOldNewLong:model.projectYearEarn WithJiaxishu:model.jiaxishuzhi ],[NSString stringWithFormat:@"%@",model.xmshouyi],nil];
        NSArray *cArr=[[NSArray alloc]initWithObjects:model.projectMoney,[self retJudegWithOld:model.projectYearEarn WithJiaxishu:model.jiaxishuzhi] ,model.xmshouyi, nil];
        
        UILabel *contentLabel=(UILabel *)[self viewWithTag:KContentLabelTag+i];
        NSString *content=contentArr[i];
        NSRange range=[content rangeOfString:cArr[i]];
        NSMutableAttributedString *attriContent=[[NSMutableAttributedString alloc]initWithString:content];
        [attriContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:range];
        contentLabel.attributedText=attriContent;
        
    }
    
    self.dateLabel.text=[NSString stringWithFormat:@"%@起投-%@到期",model.qitshijian,model.daoqshijian];
    self.repayLabel.text=model.projectRepayType;
    self.bottomLineView.frame=CGRectMake(0, 130, KProjectScreenWidth, 10);
}


-(NSString *)retJudegWithOld:(NSString *)oldString WithJiaxishu:(NSString *)jiaxishuzhi
{
    NSString * retString;
    if ([jiaxishuzhi floatValue] > 0) {
        retString = oldString;
    }else
    {
        retString = [NSString stringWithFormat:@"%.1f%%",[oldString floatValue]];
    }
    
    return retString;
}

-(NSString *)retJudegWithOldNewLong:(NSString *)oldString WithJiaxishu:(NSString *)jiaxishuzhi
{
    NSString * retString = [self retJudegWithOld:oldString WithJiaxishu:jiaxishuzhi];
    NSString * retOldString;
    if ([jiaxishuzhi floatValue] > 0) {
        retOldString = [NSString stringWithFormat:@"%@+%@%%",retString,[NSString stringWithFormat:@"%.1f",[jiaxishuzhi floatValue]]];
    }else
    {
        retOldString = [NSString stringWithFormat:@"%@",retString];
    }
    
    
    return retOldString;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
