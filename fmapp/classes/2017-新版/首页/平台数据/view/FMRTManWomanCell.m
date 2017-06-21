//
//  FMRTManWomanCell.m
//  fmapp
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 yk. All rights reserved.
//

#import "FMRTManWomanCell.h"
#import "FMRTPlatformModel.h"


@interface FMRTManWomanCell ()

@property (nonatomic, weak)UILabel *nnblLabel,*nperLabel,*wperLabel,*nsexLabel,*wsexLabel;
@property (nonatomic, weak)UIImageView *nPhotoView,*wPhotoView;


@end

@implementation FMRTManWomanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = XZColor(249, 249, 249);
        [self createContentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)createContentView{
    
    
    UILabel *nnblLabel = [[UILabel alloc]init];
    nnblLabel.text = @"男女比例分布";
    self.nnblLabel = nnblLabel;
    nnblLabel.font = [UIFont systemFontOfSize:18];
    nnblLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:nnblLabel];
    [nnblLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.left).offset(25);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    UILabel *nperLabel = [[UILabel alloc]init];
    self.nperLabel = nperLabel;
    nperLabel.font = [UIFont systemFontOfSize:14];
    nperLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:nperLabel];
    [nperLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).dividedBy(2);
        make.top.equalTo(nnblLabel.bottom).offset(40);
    }];
    
    UILabel *wperLabel = [[UILabel alloc]init];
    wperLabel.text = @"48.75%";
    self.wperLabel = wperLabel;
    wperLabel.font = [UIFont systemFontOfSize:14];
    wperLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:wperLabel];
    [wperLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).multipliedBy(1.5);
        make.top.equalTo(nnblLabel.bottom).offset(40);
    }];
    
    UIImageView *nPhotoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_男_1702"]];
    self.nPhotoView = nPhotoView;
    nPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:nPhotoView];
    [nPhotoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).dividedBy(2);
        make.top.equalTo(nperLabel.bottom).offset(25);
    }];
    
    UIImageView *wPhotoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"平台数据_女_1702"]];
    self.wPhotoView = wPhotoView;
    wPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:wPhotoView];
    [wPhotoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).multipliedBy(1.5);
        make.top.equalTo(nperLabel.bottom).offset(25);
    }];
    
    UILabel *nsexLabel = [[UILabel alloc]init];
    nsexLabel.text = @"男";
    self.nsexLabel = nsexLabel;
    nsexLabel.font = [UIFont systemFontOfSize:15];
    nsexLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:nsexLabel];
    [nsexLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).dividedBy(2);
        make.top.equalTo(nPhotoView.bottom).offset(30);
    }];
    
    UILabel *wsexLabel = [[UILabel alloc]init];
    wsexLabel.text = @"女";
    self.wsexLabel = wsexLabel;
    wsexLabel.font = [UIFont systemFontOfSize:15];
    wsexLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:wsexLabel];
    [wsexLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.centerX).multipliedBy(1.5);
        make.top.equalTo(wPhotoView.bottom).offset(30);
    }];
    
}

- (void)setModel:(UserGender *)model{
    _model = model;
    if (model) {
        [self.nnblLabel setHidden:NO];
        [self.nsexLabel setHidden:NO];
        [self.nperLabel setHidden:NO];
        [self.wsexLabel setHidden:NO];
        [self.wperLabel setHidden:NO];
        [self.nPhotoView setHidden:NO];
        [self.wPhotoView setHidden:NO];
        
        self.nperLabel.text = [NSString stringWithFormat:@"%@%%",model.Male];
        self.wperLabel.text = [NSString stringWithFormat:@"%@%%",model.Female];
        
    }else{
        [self.nnblLabel setHidden:YES];
        [self.nsexLabel setHidden:YES];
        [self.nperLabel setHidden:YES];
        [self.wsexLabel setHidden:YES];
        [self.wperLabel setHidden:YES];
        [self.nPhotoView setHidden:YES];
        [self.wPhotoView setHidden:YES];
    }
    
}

@end
