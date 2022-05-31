//
//  ViewController.m
//  KVO
//
//  Created by zhangyangyang on 2022/1/15.
//

#import "ViewController.h"
#import "ZYYObject.h"
#import "ZYYObserver.h"

@interface ViewController ()

@end

/*
 KVO本质
 利用runtime API 动态生成一个子类，并且让instance对象的isa指向这个全新的子类，全新的子类的superclass指针指向原本的类
 
 当修改instance对象属性时，会调用Foundation的 _NSSet***ValueAndNotify函数
 
 willChangeValueForKey
 父类原本的setter
 didChangeValueForKey
 内部会触发监听类的监听方法 （observeValueForKeyPath:ofObject:change:context）
 
 如何手动触发kVO？
 手动调用willChangeValueForKey didChangeValueForKey
 */


/*
 
 KVC
 key-value-coding 键值编码 通过一个key来访问某个属性
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self testKVO];
    //[self testKVC];
    [self testErrorKVC];
}

- (void)testKVO {
    ZYYObject *obj = [[ZYYObject alloc] init];
    ZYYObserver *observer = [[ZYYObserver alloc] init];
    [obj addObserver:observer forKeyPath:@"num" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 1、触发kvo
    obj.num = 1;
    
    
    /*
     其他情况
     // 2、通过成员变量直接赋值num 是否使kvo 生效？  不能
     [obj increase];
     
     // 3  重写obj的setter方法  能生效
     [obj increase2];
     
     // 4 通过 kvc 设置num 是否使kvo 生效？  生效
     [obj setValue:@2 forKey:@"num"];
     
     kvc等价下面3行代码
     [self willChangeValueForKey:@"num"];
     _num = 2;
     [self didChangeValueForKey:@"num"];
     
     */
}

- (void)testKVC {
    ZYYObject *obj = [[ZYYObject alloc] init];
    // setvalue:forkey时候   value一定要包装成对象  比如int 包装成NSNumber对象类型
    [obj setValue:@2 forKey:@"num"];
    // valueForKey时候 系统自动包装成id类型 返回给我们
    NSNumber* t = [obj valueForKey:@"num"];
    NSLog(@"%d",t.intValue);
}

/*
 
 2022-04-25 16:38:11.363008+0800 KVO[21643:248299] 设置num666错误
 2022-04-25 16:38:11.363205+0800 KVO[21643:248299] 获取num5555错误
 */
- (void)testErrorKVC {
    ZYYObject *obj = [[ZYYObject alloc] init];
    [obj setValue:@2 forKey:@"num666"];
    NSNumber* t = [obj valueForKey:@"num5555"];
    NSLog(@"%d",t.intValue);
}

@end
