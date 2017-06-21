//
//  FMShoppingListScanView.m
//  fmapp
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMShoppingListScanView.h"

#import "SDCycleScrollView.h"

@interface FMShoppingListScanView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScroView;
@property (nonatomic, strong) UIImageView       *scanPhotoView;
@property (nonatomic, strong) UILabel           *titleLabel, *detailLabel;
@property (nonatomic, strong) UIButton          *saveButton, *closeButton;
@property (nonatomic, strong) NSArray           *photoArr;

@end

@implementation FMShoppingListScanView

- (instancetype)initWithData:(NSMutableArray *)imageData count:(NSInteger)count withQRImage:(UIImage *)QRImage{
    self = [super init];
    if (self) {
        
        self.photoArr =  [NSArray arrayWithArray:imageData];
        self.titleLabel.text = [NSString stringWithFormat:@"您共分享了%ld个宝贝",(long)count];
        self.scanPhotoView.image = QRImage;
        self.backgroundColor =[UIColor colorWithHexString:@"1e1e1e" alpha:0.6];
        [self createShareView];

    }
    return self;
}

- (void)createShareView {
    
    UIView *centerView = [[UIView alloc]init];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 3;
    [self addSubview:centerView];
    [centerView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
        make.width.equalTo(KProjectScreenWidth - 110);
        make.height.equalTo((KProjectScreenWidth - 110)*1.4);
        
    }];
    
    [centerView addSubview:self.cycleScroView];
    [self.cycleScroView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(centerView);
        make.height.equalTo(centerView.mas_height).dividedBy(2);
    }];
    
    [centerView addSubview:self.closeButton];
    [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_top).offset(10);
        make.right.equalTo(centerView.mas_right).offset(-10);
    }];
    
    [centerView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScroView.mas_bottom);
        make.left.right.equalTo(centerView);
        make.height.equalTo(@30);
    }];
    
    [centerView addSubview:self.scanPhotoView];
    self.scanPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scanPhotoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(centerView.mas_left).offset(60);
        make.right.equalTo(centerView.mas_right).offset(-60);
        make.bottom.equalTo(centerView.mas_bottom).offset(-35);
    }];
    
    [centerView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.scanPhotoView.mas_bottom).offset(10);
        make.centerX.equalTo(centerView.mas_centerX);
    }];
    
    [self addSubview:self.saveButton];
    [self.saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom).offset(10);
        make.width.equalTo(@85);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.mas_centerX);
    }];
}


- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_saveButton setTitle:@"保存到相册" forState:(UIControlStateNormal)];
        _saveButton.layer.borderWidth = 1;
        _saveButton.layer.borderColor =[UIColor whiteColor].CGColor;
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _saveButton;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = kColorTextColorClay;
        _detailLabel.text = @"扫描二维码，查看更多信息";
        _detailLabel.font = [UIFont systemFontOfSize:14];

    }
    return _detailLabel;
}

- (UIImageView *)scanPhotoView {
    if (!_scanPhotoView) {
        _scanPhotoView = [[UIImageView alloc]init];

    }
    return _scanPhotoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"小鱼儿分享了购物车里的一个宝贝";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = KContentTextLightGrayColor;
    }
    return _titleLabel;
}

- (SDCycleScrollView *)cycleScroView {
    if (!_cycleScroView) {
        _cycleScroView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:self.photoArr];
        _cycleScroView.delegate = self;
        _cycleScroView.showPageControl = NO;
        _cycleScroView.autoScroll = NO;
        _cycleScroView.backgroundColor = [UIColor purpleColor];

    }
    return _cycleScroView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeButton setImage:[UIImage imageNamed:@"t4"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (void)closeAction:(UIButton *)sender {
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)saveAction:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.scanPhotoView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    self.hidden = YES;
    ShowAutoHideMBProgressHUD(self, @"二维码图片已保存至相册");

}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSString *msg = nil ;
   if(error != NULL){
          msg = @"保存图片失败" ;
        }else{
       msg = @"保存图片成功" ;
    }
    
    if (self.block) {
        self.block(error);
    }
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    
}

@end
