//
//  ViewController.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "ViewController.h"
#import "ZYYView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYYView *view = [[ZYYView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
   // [view updateContents];
    view.backgroundColor= [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
    [self.view addSubview:view];
    
    UIImage *t = [UIImage ]
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"6666");
   // self.view.backgroundColor = [UIColor yellowColor];
}


@end
