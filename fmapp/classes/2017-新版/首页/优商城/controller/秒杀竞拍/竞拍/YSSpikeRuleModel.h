//
//  YSSpikeRuleModel.h
//  fmapp
//
//  Created by yushibo on 16/8/10.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSSpikeRuleModel : NSObject
/**
 *  内容
 */
@property (nonatomic, strong) NSString *content;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
