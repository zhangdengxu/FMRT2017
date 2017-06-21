//
//  FirstLeadViewController.m
//  fmapp
//
//  Created by runzhiqiu on 16/1/7.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "FirstLeadViewController.h"

@interface FirstLeadViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scroll;
@property (nonatomic, strong) NSMutableArray * imageMuArray;
@property (nonatomic, strong) UIImageView * imagePhoto;
@property (nonatomic, strong) UIView * backGrouneImage;
@end

@implementation FirstLeadViewController

-(UIView *)backGrouneImage
{
    if (!_backGrouneImage) {
        CGRect rect=[[UIScreen mainScreen] bounds];

        
        _backGrouneImage = [[UIView alloc]init];
        _backGrouneImage.userInteractionEnabled = YES;

        _backGrouneImage.frame = rect;
        _backGrouneImage.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_backGrouneImage];
    }
    return _backGrouneImage;
}
-(UIImageView *)imagePhoto
{
    if (!_imagePhoto) {
        _imagePhoto = [[UIImageView alloc]init];
        _imagePhoto.userInteractionEnabled = YES;
        CGRect rect=[[UIScreen mainScreen] bounds];
        _imagePhoto.frame = CGRectMake(0, 0, KProjectScreenWidth * 0.3, KProjectScreenHeight * 0.3);
        _imagePhoto.alpha = 0.35;
        _imagePhoto.center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
        _imagePhoto.image = [UIImage imageNamed:self.imageMuArray[0]];
        [self.backGrouneImage addSubview:_imagePhoto];
        
        UISwipeGestureRecognizer *recognizer;

        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
        [_imagePhoto addGestureRecognizer:recognizer];

    }
    return _imagePhoto;
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self setTabRootControl];
}

-(NSMutableArray *)imageMuArray
{
    if (!_imageMuArray) {
        _imageMuArray = [NSMutableArray array];
        

        [_imageMuArray addObject:@"APP开机页1"];
        
    }
    return _imageMuArray;
}

-(UIScrollView *)scroll
{
    if (!_scroll) {

        CGRect rect=[[UIScreen mainScreen] bounds];
        UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:rect];
        scroll.backgroundColor=[UIColor clearColor];
        scroll.contentSize=CGSizeMake(rect.size.width * self.imageMuArray.count, rect.size.height);
        scroll.pagingEnabled=YES;
        scroll.showsHorizontalScrollIndicator=NO;
        scroll.showsVerticalScrollIndicator=NO;
        scroll.bounces = NO;
        scroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 3);
        scroll.delegate = self;
        _scroll = scroll;
        [self.view addSubview:scroll];
    }
    return _scroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.imageMuArray.count > 1) {
         CGRect rect=[[UIScreen mainScreen] bounds];
        for(int i=0;i<self.imageMuArray.count;i++)
        {
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width*i, 0, rect.size.width, rect.size.height)];

            image.image=[UIImage imageNamed:self.imageMuArray[i]];
            
            image.userInteractionEnabled=YES;
            [self.scroll addSubview:image];
            if (i == (self.imageMuArray.count - 1)) {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(38, KProjectScreenHeight-150, KProjectScreenWidth-76, 100)];
                [btn addTarget:self action:@selector(setTabRootControl) forControlEvents:UIControlEventTouchUpInside];
                [image addSubview:btn];
            }
        }
    }else
    {
        [self imagePhoto];
        [UIView animateWithDuration:0.75f animations:^{
            CGRect rect=[[UIScreen mainScreen] bounds];
            self.imagePhoto.alpha = 1.0;
            self.imagePhoto.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            _imagePhoto.center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
            
            _imagePhoto.layer.cornerRadius = 0;
            
        } completion:^(BOOL finished) {
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(38, KProjectScreenHeight-150, KProjectScreenWidth-76, 100)];
            [btn addTarget:self action:@selector(setTabRootControl) forControlEvents:UIControlEventTouchUpInside];
            [self.imagePhoto addSubview:btn];
            
        }];
        
    }

    
}

#pragma mark ----- scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGPoint pInView = scrollView.contentOffset;
    if (pInView.x > [[UIScreen mainScreen] bounds].size.width * (self.imageMuArray.count - 1 )) {
        
        [self setTabRootControl];
    }
    
}


- (void)setTabRootControl
{
    if ([self.delegate respondsToSelector:@selector(FirstLeadViewControllerTurnToMainView:)]) {
        [self.delegate FirstLeadViewControllerTurnToMainView:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
