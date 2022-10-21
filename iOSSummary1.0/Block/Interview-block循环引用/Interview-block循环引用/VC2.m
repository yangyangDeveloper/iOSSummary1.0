//
//  VC2.m
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/9/30.
//

#import "VC2.h"

@interface VC2 ()

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"vc2";
//    NBBlock * nb0 = [[NBBlock alloc] init];
//    [nb0 nb];
    
    __weak UIViewController * weakself = self;
    [self.nbo addBlock:^{
        NSLog(@"2");
        self.view.backgroundColor = [UIColor redColor];
    }];

  
    
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
