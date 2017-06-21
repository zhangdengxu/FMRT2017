//
//  FMDuobaoClass.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/1.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMDuobaoClass.h"


//夺宝Model
@implementation FMDuobaoClass
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end

//夺宝 - 参与记录Model
@implementation FMDuobaoClassNotes
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end



//夺宝 - 参与样式Model
@implementation FMDuobaoClassStyle


-(void)changeModelStatus;
{
    self.isSpread = NO;
    
    self.buttonStyle = 0;//为默认
    //self.buttonStyle = 1,为颜色变灰
    //self.buttonStyle = 2，为受侵变灰
    
    
    //stauts = 1 为没有进度条，status = 2为存在进度条；
    if ([self.type integerValue] == 1) {//判断抽奖
        
        if ([self.online integerValue] <= 0) {
            self.status = @"1";
        }else
        {
            self.status = @"2";
        }
        
    }else
    {
        self.status = @"1";
    }
    
    
    if ([self.shop_Status integerValue] == 2) {
        if ([self.online integerValue] <= 0) {
            self.buttonStyle = 2;
            
        }else
        {
             if ([self.type integerValue] == 1)
             {
                 if([self.purchased integerValue] == 0)
                 {
                     self.buttonStyle = 0;
                 }else
                 {
                     self.buttonStyle = 1;
                 }

             }else
             {
                 self.buttonStyle = 0;
             }
            
        }
        
    }else
    {
        
        self.buttonStyle = 1;
       
    }
    
    
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.style_id = value;
    }
    
}
@end



//夺宝 - 选中商品Model
@implementation FMDuobaoClassSelectStyle
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
