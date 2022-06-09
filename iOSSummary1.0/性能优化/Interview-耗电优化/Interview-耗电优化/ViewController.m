//
//  ViewController.m
//  Interview-耗电优化
//
//  Created by zhangyangyang on 2022/2/4.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationManager *mgr;
    
    // 快速定位  定位完成后会自动让定位硬件断点
    [mgr requestLocation];
}


@end
