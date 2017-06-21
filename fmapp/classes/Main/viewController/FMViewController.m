//
//  FMViewController.m
//  fmapp
//
//  Created by 李 喻辉 on 14-5-8.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMViewController.h"
#import "HTTPClient+UserLoginOrRegister.h"
#import "LocalDataManagement.h"
#import "UIButton+Bootstrap.h" //修改右侧button

#import "OpenUDID.h"


#define KRightButtonRedPointImageTag INT_MAX

@interface FMViewController ()

@property (nonatomic,weak) UIActivityIndicatorView*  indicatorView;

@end

@implementation FMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            self.enableCustomNavbarBackButton = YES;
//            self.navButtonSize = 24.0;
        }
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:HUIApplicationFrame()];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navButtonSize = KNavSize;

    if (self.enableCustomNavbarBackButton){
        [self setLeftNavButtonFA:FMIconLeftArrow
                       withFrame:kNavButtonRect
                    actionTarget:self
                          action:@selector(_backToPrevController)];
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;


}

//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
////    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}

- (void) settingNavTitle:(NSString *)title{

    CGRect rcTileView = CGRectMake(90, 0, KProjectScreenWidth - 2*90, 44);
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame: rcTileView];
    titleTextLabel.backgroundColor = [UIColor clearColor];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.textColor = [UIColor blackColor];
    [titleTextLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [titleTextLabel setText:title];
    CGSize sizeTitle = [title sizeWithAttributes:@{NSFontAttributeName:titleTextLabel.font}];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(rcTileView.size.width/2+sizeTitle.width/2+10, 12, 20, 20);
    [indicatorView setHidesWhenStopped:YES];
    [titleTextLabel addSubview:indicatorView];
    self.indicatorView = indicatorView;
    self.navigationItem.titleView = titleTextLabel;
    

}
- (void) setLeftNavButtonFA:(NSInteger)buttonType withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action{
    
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navButton simpleButtonWithImageColor:[UIColor blackColor]];
    [navButton addAwesomeIcon:buttonType beforeTitle:YES];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    }else{
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    }
    self.navigationItem.leftBarButtonItem = navItem;
    
}
- (void) setLeftNavButton:(NSString* )title withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action{
    
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    [navButton setTitle:title forState:(UIControlStateNormal)];
    navButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -6;
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, navItem, nil] animated:NO];
    }else{
        self.navigationItem.leftBarButtonItem = navItem;
    }
    
}
- (void)setRightNavButton:(NSString* )title withFrame:(CGRect) frame actionTarget:(id)target action:(SEL)action color:(UIColor *)color {
    
    if (target == nil && action == nil)
        return;
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    [navButton setTitle:title forState:(UIControlStateNormal)];
    navButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [navButton setTitleColor:color forState:UIControlStateNormal];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -6;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, navItem, nil] animated:NO];
   }
        else{
        self.navigationItem.rightBarButtonItem = navItem;
    }
    
}

- (void)setRightNavButtonFA:(NSInteger)buttonType withFrame:(CGRect) frame actionTarget:(id)target action:(SEL) action{
    
    if (target == nil && action == nil)
        return;

    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setFrame:frame];
    navButton.titleLabel.font = [UIFont systemFontOfSize:self.navButtonSize];
    navButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [navButton simpleButtonWithImageColor:[FMThemeManager.skin navigationTextColor]];
    [navButton addAwesomeIcon:buttonType beforeTitle:YES];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    if(HUISystemVersionAboveOrIs(kHUISystemVersion_7_0)){//iOS 7以上
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    }else{
        navButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
    }
    self.navigationItem.rightBarButtonItem = navItem;
}


- (void)setEnableCustomNavbarBackButton:(BOOL)enableCustomNavbarBackButton{
    _enableCustomNavbarBackButton = enableCustomNavbarBackButton;
    if (!_enableCustomNavbarBackButton)
        self.navigationItem.leftBarButtonItems = nil;
}

- (void)_backToPrevController{
    if (self.navBackButtonRespondBlock){
        self.navBackButtonRespondBlock();
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) startWaitting{
    [self.indicatorView startAnimating];
}

- (void) stopWaitting{
    [self.indicatorView stopAnimating];
}

- (void) updateNaviTheme{
    //标题
    id tileView = self.navigationItem.titleView;
    if ([tileView isKindOfClass:[UILabel class]]) {
        [tileView setTextColor:[FMThemeManager.skin navigationTextColor]];
    }
    //导航栏按钮
    UIButton* leftButton = (UIButton* )self.navigationItem.leftBarButtonItem.customView;
    if([leftButton isKindOfClass:[UIButton class]]){
        [leftButton simpleButtonWithImageColor:[FMThemeManager.skin navigationTextColor]];
    }
    UIButton* rightButton = (UIButton* )self.navigationItem.rightBarButtonItem.customView;
    if([rightButton isKindOfClass:[UIButton class]]){
        [rightButton simpleButtonWithImageColor:[FMThemeManager.skin navigationTextColor]];
    }
}

- (void)setRightNavBarButtonRedPointAnnotation:(BOOL)displayAnnotation{
    
    int m = INT_MAX;
    Log(@" m is %d\n is KRightButtonRedPointImageTag %d",m,KRightButtonRedPointImageTag)
    UIButton *rightButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    UIImageView *redPointImage = (UIImageView *)[rightButton viewWithTag:KRightButtonRedPointImageTag];
    if (redPointImage) {
        if (displayAnnotation == YES) {
            [redPointImage setHidden:NO];
        }else{
            [redPointImage setHidden:YES];
        }
    }
    else{
        if (displayAnnotation == YES) {
            redPointImage= [[UIImageView alloc]init];
            [redPointImage setFrame:CGRectMake(55.0f , 10.5f, 7.0f, 7.0f)];
//            if (HUISystemVersionBelowOrIs(kHUISystemVersion_7_0)) {
//                [redPointImage setFrame:CGRectMake(47.0f , 10.5f, 7.0f, 7.0f)];
//            }
            Log(@"KRightButtonRedPointImageTag is %d",KRightButtonRedPointImageTag)
            [redPointImage setTag:KRightButtonRedPointImageTag];
            [redPointImage setImage:kImgHintPointImage];
            [rightButton addSubview:redPointImage];
        }
    }
}
@end
