//
//  FMMessageAlterView.m
//  fmapp
//
//  Created by runzhiqiu on 16/4/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#define KHeaderViewTextColor [HXColor colorWithHexString:@"#1e1e1e"]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define LeftToView 10.f
#define TopToView 10.f

#import "FMMessageAlterView.h"



@interface FMMessageAlterView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) FMMessageAlterViewDirection direction;

@end

@implementation FMMessageAlterView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(FMMessageAlterViewDirection)direction {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        //背景色为clearColor
        self.backgroundColor = [UIColor clearColor];
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        self.dataArray = dataArray;
        if (height <= 0) {
            height = 44;
        }
        if (direction == kFMMessageAlterViewDirectionLeft) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, height * _dataArray.count) style:UITableViewStylePlain];
        }else {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, -width, height * _dataArray.count) style:UITableViewStylePlain];
        }
        
        _tableView.separatorColor = [UIColor colorWithRed:(220.0/255.0) green:(221.0/255.0) blue:(223.0/255.0) alpha:1];
        _tableView.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(234.0/255.0) blue:(241.0/255.0) alpha:1];;
        _tableView.bounces = NO;
        _tableView.layer.cornerRadius = 2;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [self addSubview:self.tableView];
        
        //cell线条
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:CellLineEdgeInsets];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:CellLineEdgeInsets];
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = [UIColor clearColor];
    //取出模型
    FMMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:(220.0/255.0) green:(221.0/255.0) blue:(223.0/255.0) alpha:1];
    if (model.isRedSpot) {
        UIButton * redButton = [[UIButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width - 10 - 8, 0, 10, 10)];
        redButton.backgroundColor = [UIColor redColor];
        redButton.layer.cornerRadius = 5;
        redButton.center = CGPointMake(self.width - 8 - 10, cell.contentView.center.y);
        [cell.contentView addSubview:redButton];
        [cell.contentView bringSubviewToFront:redButton];
    }else
    {
        for (UIView * contView in cell.contentView.subviews) {
            if ([contView isMemberOfClass:[UIButton class]]) {
                [contView removeFromSuperview];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndexPath:)]) {
        [self.delegate didSelectedAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:CellLineEdgeInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:CellLineEdgeInsets];
    }
}

//画出尖尖
- (void)drawRect:(CGRect)rect {
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    if (self.direction == kFMMessageAlterViewDirectionLeft) {
        CGFloat startX = self.origin.x + 20;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }else {
        CGFloat startX = self.origin.x - 20;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [self.tableView.backgroundColor setFill]; //设置填充色
    
    
    [self.tableView.backgroundColor setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    

}

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0;
    CGRect frame = self.tableView.frame;
    self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.tableView.frame = frame;
    }];
}

- (void)dismiss {
    //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (self.dismissOperation) {
                self.dismissOperation();
            }
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        [self dismiss];
    }
}

@end


#pragma mark - FMMessageModel

@implementation FMMessageModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName isShowRed:(BOOL)isRedSpot {
    FMMessageModel *model = [[FMMessageModel alloc] init];
    model.title = title;
    model.imageName = imageName;
    model.isRedSpot = isRedSpot;
    return model;
}

@end
