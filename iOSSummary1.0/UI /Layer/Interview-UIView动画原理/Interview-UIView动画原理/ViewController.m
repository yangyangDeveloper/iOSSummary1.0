//
//  ViewController.m
//  Interview-UIView动画原理
//
//  Created by zhangyangyang on 2022/2/10.
//

#import "ViewController.h"
#import "ZYYView.h"

@interface ViewController ()
@property (nonatomic, strong)  ZYYView *zyyview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.zyyview = [[ZYYView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    
    self.zyyview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.zyyview];
    
    [self uiviewAnimation];
}
/** UIView 动画产生原理 */
- (void)uiviewAnimation {
    NSLog(@"%@",[self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"]);

    [UIView animateWithDuration:1.25 animations:^{
        NSLog(@"%@",[self.view.layer.delegate actionForLayer:self.view.layer forKey:@"position"]);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    self.zyyview.backgroundColor = [UIColor yellowColor];
    
}
@end
