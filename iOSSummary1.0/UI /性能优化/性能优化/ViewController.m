//
//  ViewController.m
//  性能优化
//
//  Created by zhangyangyang on 2022/6/17.
//

#import "ViewController.h"
#import "VC1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    VC1 *vc = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
