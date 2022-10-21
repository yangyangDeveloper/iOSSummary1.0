//
//  ViewController.m
//  Interview-block循环引用
//
//  Created by zhangyangyang on 2022/2/9.
//

#import "ViewController.h"
#import "VC2.h"

#import "ZYYPerson.h""

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
//    ZYYPerson *zyy = [[ZYYPerson alloc] init];
//    [zyy dosome];
    

    
   // [self.nbo nb];
  //  [self testblock1];
}

- (void)testblock1 {

    // self -> block ——> testblock对象 ——> self
   


    //self.block.nbblock();
   // block();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    VC2 *vc = [[VC2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
