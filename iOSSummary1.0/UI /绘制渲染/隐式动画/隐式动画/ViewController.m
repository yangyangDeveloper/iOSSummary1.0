//
//  ViewController.m
//  隐式动画
//
//  Created by zhangyangyang on 2022/6/20.
//

#import "ViewController.h"
#import "ZYYView.h"

@interface ViewController ()
@property (nonatomic, strong)  ZYYView *zyyview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zyyview = [[ZYYView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    self.zyyview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.zyyview];
    [self uiviewAnimation];
}

/** UIView 动画产生原理 */
/*
 
 动画块外返回<null>  返回nil是继续往下查找 返回null是直接跳出查找流程
 动画块内返回<_UIViewAdditiveAnimationAction: 0x600001923820>遵守CAAction协议的对象
 */
- (void)uiviewAnimation {
    
    NSLog(@"%@",[self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"]);

    [UIView animateWithDuration:1.25 animations:^{
        NSLog(@"%@",[self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"]);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.zyyview.backgroundColor = [UIColor yellowColor];
}

@end
