//
//  FMMyRecommendController.h
//  fmapp
//
//  Created by runzhiqiu on 2017/2/21.
//  Copyright © 2017年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMMyRecommendModel;

@interface FMMyRecommendController : FMViewController

@end



@interface FMMyRecommendModel : NSObject

@property (nonatomic,copy) NSString *jinriyjjiner;
@property (nonatomic,copy) NSString *leijiyjjiner;
@property (nonatomic,copy) NSString *benyyjjiner;
@property (nonatomic,copy) NSString *myzichanjiner;
@property (nonatomic,copy) NSString *myzichanjinerwanyi;
@property (nonatomic,copy) NSString *myreuserjiner;
@property (nonatomic,copy) NSString *haoygongxianwanyi;
@property (nonatomic,copy) NSString *haoygongxian;
@property (nonatomic,copy) NSString *hygxyongjin;
@property (nonatomic,copy) NSString *jibie;

-(void)setUpDefaultValue;

@end
