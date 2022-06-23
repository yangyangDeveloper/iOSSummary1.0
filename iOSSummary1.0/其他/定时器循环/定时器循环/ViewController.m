//
//  ViewController.m
//  定时器循环
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "ViewController.h"
#import "VC1.h""

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    VC1 *vc = [[VC1 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
