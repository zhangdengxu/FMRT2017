//
//  FMSelectShopCollectionViewFlowlayout.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/28.
//  Copyright © 2016年 yk. All rights reserved.
//
#define KCollectionViewTitleHeigh 55

#import "FMSelectShopCollectionViewFlowlayout.h"

@interface FMSelectShopCollectionViewFlowlayout ()
@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;

@property (nonatomic, strong) NSMutableArray *itemAttributes;

@property (nonatomic, assign) CGFloat contentHeight;


@property (nonatomic, strong) NSArray * contentArray;
@end

@implementation FMSelectShopCollectionViewFlowlayout


-(instancetype)initWithContentArray:(NSArray *)contentArray
{
    self = [super init];
    
    if (self) {
        _contentArray = contentArray;
        [self setupFlowLayout];
    }
    
    return self;
}
-(void)setupFlowLayout
{
    self.itemSize = CGSizeMake(100.0f, 26.0f);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 10.0f;
    self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    
    
    
    _itemAttributes = [NSMutableArray array];

}


#pragma mark -

- (void)prepareLayout
{
    
    [super prepareLayout];
    
    [self.itemAttributes removeAllObjects];
    
    
    
    
    self.contentHeight = 0;
    
    CGFloat originX = self.sectionInset.left;
    CGFloat originY = self.contentHeight;
    
    for (NSInteger section = 0; section < self.contentArray.count; section++) {
        
        NSIndexPath * secIndexPath = [NSIndexPath indexPathForItem:INT_MAX inSection:section];
        [self.itemAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:secIndexPath]];
        
        originY = self.contentHeight;
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        CGFloat sizeItenHeigh = 0;
        
        for (NSInteger i = 0; i < itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            
            CGSize itemSize = [self itemSizeForIndexPath:indexPath];
            
            if ((originX + itemSize.width + self.sectionInset.right/2) > self.collectionView.frame.size.width) {
                originX = self.sectionInset.left;
                originY += itemSize.height + self.minimumLineSpacing;
                
                self.contentHeight += itemSize.height + self.minimumLineSpacing;
            }else
            {
                sizeItenHeigh = itemSize.height;
            }
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
            
            [self.itemAttributes addObject:attributes];
            
            originX += itemSize.width + self.minimumInteritemSpacing;
        }
        originX = self.sectionInset.left;
        self.contentHeight += (sizeItenHeigh + self.minimumLineSpacing + self.minimumLineSpacing);
        originY += (sizeItenHeigh + self.minimumLineSpacing + self.minimumLineSpacing);
        
    }
    
    
    self.contentHeight += self.sectionInset.bottom;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    attributes.frame = CGRectMake(0, self.contentHeight, [UIScreen mainScreen].bounds.size.width, KCollectionViewTitleHeigh);
    self.contentHeight += KCollectionViewTitleHeigh ;
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (id<UICollectionViewDelegateFlowLayout>)delegate
{
    if (_delegate == nil) {
        _delegate =  (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    }
    
    return _delegate;
}

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        self.itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    return self.itemSize;
}


@end
