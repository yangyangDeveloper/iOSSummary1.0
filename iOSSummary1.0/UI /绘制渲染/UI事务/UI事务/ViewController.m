//
//  ViewController.m
//  UI事务
//
//  Created by zhangyangyang on 2022/6/14.
//

#import "ViewController.h"
#import "ZYYView.h"

@interface ViewController ()
@property(nonatomic, strong) ZYYView *zyyview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zyyview = [[ZYYView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.zyyview.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.zyyview];
    //[self.zyyview updateContents];
   // [self.zyyview updateContentsInsubThreads];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"6666");
    [self.zyyview updateContentsInsubThreads];
   // self.view.backgroundColor = [UIColor yellowColor];
}

@end
