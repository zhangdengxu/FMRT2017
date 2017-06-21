
#import "FMViewController.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface GestureViewController : FMViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;
+(void)cleanFigureGesture;

@end
