//
//  FMBeautifulModel.m
//  fmapp
//
//  Created by runzhiqiu on 2016/11/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FMBeautifulModel.h"

@implementation FMBeautifulModel


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.addtime = [coder decodeObjectForKey:@"addtime"];
        self.author = [coder decodeObjectForKey:@"author"];
        self.classone = [coder decodeObjectForKey:@"classone"];
        self.news_id = [coder decodeObjectForKey:@"news_id"];
        self.recommend_app_first = [coder decodeObjectForKey:@"recommend_app_first"];
        self.shareContent = [coder decodeObjectForKey:@"shareContent"];
        self.thumb = [coder decodeObjectForKey:@"thumb"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.videoPath = [coder decodeObjectForKey:@"videoPath"];
        self.videoThumb = [coder decodeObjectForKey:@"videoThumb"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.addtime forKey:@"addtime"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.classone forKey:@"classone"];
    [aCoder encodeObject:self.news_id forKey:@"news_id"];
    [aCoder encodeObject:self.recommend_app_first forKey:@"recommend_app_first"];
    [aCoder encodeObject:self.shareContent forKey:@"shareContent"];
    [aCoder encodeObject:self.thumb forKey:@"thumb"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoThumb forKey:@"videoThumb"];
    
    
    
}


/**
 *  归档
 *
 *  @param user <#user description#>
 */
- (void)saveUserObjectWithUser:(NSMutableArray *)dataArray
{
    //我们要将自定义对象转化为二进制流 并写入沙盒 我们要进行以下操作
    //1.先创建一个NSMutableData对象
    NSMutableData *data = [NSMutableData data];
    //2.创建一个归档对象
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    //3.归档
    [archive encodeObject:dataArray forKey:self.keyString];
    
    //4.完成归档
    [archive finishEncoding];
    
    //5.写入文件
    [data writeToFile: [self  path] atomically:YES];
}

-(void)removUserInfoArachive
{
    BOOL bRet = [[NSFileManager defaultManager] fileExistsAtPath:[self path]];
    
    if (bRet) {
        //
        NSError *err;
        
        [[NSFileManager defaultManager] removeItemAtPath:[self path] error:&err];
        
    }
}

- (NSMutableArray *)dataArrayFromArachiver
{
    //1.首先判断文件是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self path]])
    {
        
        return [NSMutableArray array];
    }
    //2.读取data对象
    NSData *data = [NSData dataWithContentsOfFile:[self path]];
    //3.创建解归档对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //4.解档 创建接受对象
    NSMutableArray * dataArray =  [unArchiver decodeObjectForKey:self.keyString];
    
    //4.解档 创建接受对象
    if (dataArray == nil) {
        return  [NSMutableArray array];
    }else
    {
       return  dataArray;
    }
    
    
   
}

- (NSString *)path
{
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES)lastObject];
    
    return [chachePath stringByAppendingPathComponent:self.keyString];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
