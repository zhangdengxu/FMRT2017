//
//  DataPage.m
//  FM_CZFW
//
//  Created by liyuhui on 13-1-26.
//  Copyright (c) 2013年 ETelecom. All rights reserved.
//

#import "DataPage.h"

#define kDataPageDefaultPageSize        6
#define kDataPageDefaultMinPageCount    0

@interface DataPage ()
@property (nonatomic, assign) NSUInteger        pageSize;
@property (strong) NSMutableArray               *dataContainer;      //数据容器
@property (assign) NSUInteger                   currentPageIndex;
@end


@implementation DataPage
@synthesize pageCount = _pageCount;
@synthesize pageSize = _pageSize;
@synthesize dataContainer = _dataContainer;

+ (id)pageWithPageSize:(NSUInteger)pageSize
{
    return [[self alloc] initWithPageSize:pageSize];
}

+ (id)page
{
    return [self pageWithPageSize:kDataPageDefaultPageSize];
}

- (id)initWithPageSize:(NSUInteger)pageSize
{
    self = [super init];
    if (self == nil) 
        return nil;
    
    _pageSize = pageSize;
    [self cleanAllData];
    
    return self;
}

- (id)init
{
    return [self initWithPageSize:kDataPageDefaultPageSize];
}

#pragma mark - Data Managment
- (NSArray *)data
{
    return self.dataContainer;
}

- (NSUInteger)count
{
    return [self.dataContainer count];
}

- (BOOL)canLoadMore
{
    return ([self.dataContainer count]>0);
}

- (NSUInteger)nextPageIndex
{
    return self.currentPageIndex + 1;
}

- (void)appendPage:(NSArray *)pageData
{   
    //数据个数大于分页尺寸，非法数据，不加入
    //if ([pageData count] > self.pageSize)
    //   return;
        
    [self.dataContainer addObjectsFromArray:pageData];
    
    self.currentPageIndex++;
}
- (void)appendData:(id)objectData
{
    [self.dataContainer addObject:objectData];
    
    self.currentPageIndex++;
}
- (void)deleteData:(id)data
{
    if (!data)
        return;
    
    [self.dataContainer removeObject:data];
}
- (void)deleteDataAtIndex:(NSUInteger)index
{
    [self.dataContainer removeObjectAtIndex:index];
}
- (void)deleteDatas:(NSArray* )datas
{
    if (!datas)
        return;
    
    [self.dataContainer removeObjectsInArray:datas];
}
- (void)cleanAllData
{
    [self setDataContainer:[NSMutableArray array]];
    [self setPageCount:kDataPageDefaultMinPageCount];
    [self setCurrentPageIndex:0];
}
- (void)removeAllObjects
{
    [self.dataContainer removeAllObjects];
}
@end
