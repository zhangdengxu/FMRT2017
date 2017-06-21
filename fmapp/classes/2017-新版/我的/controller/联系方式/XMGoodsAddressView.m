//
//  XMGoodsAddressView.m
//  fmapp
//
//  Created by runzhiqiu on 16/2/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "XMGoodsAddressView.h"
#import "RegexKitLite.h"

@interface XMGoodsAddressView ()

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberlabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@end

@implementation XMGoodsAddressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"XMGoodsAddressView" owner:self options:nil] lastObject];
        
        CGRect rect = self.frame;
        rect.size.width = 375 * KProjectScreenWidth / 375 ;
        rect.size.height = 667 * KProjectScreenHeight / 667;
        
        self.frame = rect;
    }
    return self;
}

- (IBAction)operateButtonOnClick:(id)sender {
    if (self.nameLabel.text.length <= 0) {
        ShowAutoHideMBProgressHUD(self,@"姓名不能为空！");
        return;
    }
    if (self.phoneNumberlabel.text.length <= 0) {
        ShowAutoHideMBProgressHUD(self,@"电话号码不能为空！");
        return;
    }
    if (self.addressTextView.text.length <= 0) {
        ShowAutoHideMBProgressHUD(self,@"地址不能为空！");
        return;
    }
    if (![self.phoneNumberlabel.text isMatchedByRegex:@"^[1][0-9][0-9]{9}$"]) {
        ShowAutoHideMBProgressHUD(self,@"您输入的手机号不合法！");
        return;
    }
    if ([self.delegate respondsToSelector:@selector(XMGoodsAddressViewDidOnClickOperateButton: withInfo:)]) {
        
        NSDictionary * dataInfo = @{@"name":self.nameLabel.text,@"phoneNumber":self.phoneNumberlabel.text,@"address":self.addressTextView.text};
        
        [self.delegate XMGoodsAddressViewDidOnClickOperateButton:self withInfo:dataInfo];
    }
}

-(void)setDatasource:(NSDictionary *)datasource
{
    _datasource = datasource;
    if (datasource) {
        if (datasource[@"xingming"]) {
            NSString * name = [NSString stringWithFormat:@"%@",datasource[@"xingming"]];
            self.nameLabel.text = name;
            
            if (datasource[@"shoujihao"]) {
                NSString * shoujihao = [NSString stringWithFormat:@"%@",datasource[@"shoujihao"]];
                self.phoneNumberlabel.text = shoujihao;
            }
            if (datasource[@"dizhi"]) {
                NSString * dizhi = [NSString stringWithFormat:@"%@",datasource[@"dizhi"]];
                self.addressTextView.text = dizhi;
            }
        
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
