//
//  FMShoppigListBottomEditView.h
//  fmapp
//
//  Created by apple on 16/4/24.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)(UIButton *sender);
typedef void(^RemoveBlock)(UIButton *sender);
typedef void(^ShareBlock)(UIButton *sender);

@interface FMShoppigListBottomEditView : UIView

@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, copy) RemoveBlock removeBlock;
@property (nonatomic, copy) ShareBlock  shareBlcok;

@property (nonatomic, strong) UIButton *removeButton;

@end
