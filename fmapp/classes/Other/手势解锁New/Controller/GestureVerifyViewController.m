
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "GestureViewController.h"

@interface GestureVerifyViewController ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

@end

@implementation GestureVerifyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:CircleViewBackgroundColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingNavTitle:@"验证手势解锁"];
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    CGFloat imageViewWidth;
    if (kScreenW == 320) {
        imageViewWidth = 65;
    }else if (kScreenW == 375)
    {
        imageViewWidth = 75;
    }else
    {
        imageViewWidth = 85;
    }
    imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
    if (KProjectScreenWidth == 320) {
        imageView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 15 - 45);
    }else
    {
        imageView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - 30 - 45);
        
    }
    

    imageView.layer.cornerRadius = imageView.frame.size.height * 0.5;
    imageView.layer.masksToBounds = YES;
    
    NSString * imageUrl = [NSString stringWithFormat:@"https://%@",[CurrentUserInformation sharedCurrentUserInfo].touxiangsde];
//    NSLog(@"====>%@",imageUrl);
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"commtouxiang110"]];
    
    [self.view addSubview:imageView];
}

#pragma mark - login or verify gesture


- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            Log(@"验证成功");
            
            if (self.isToSetNewGesture) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } else {
            Log(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    }
}

@end
