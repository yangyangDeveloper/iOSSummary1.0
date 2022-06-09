//
//  Case1.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/12/1.
//

#ifndef Case1_h
#define Case1_h


#endif /* Case1_h */

NSObject *yang = [[NSObject alloc] init];
__block NSObject *yang2 = yang;

NSLog(@"ok block前=%ld",CFGetRetainCount((__bridge CFTypeRef)(ok)));  // 3
NSLog(@"ppp block前=%ld",CFGetRetainCount((__bridge CFTypeRef)(ppp))); // 3
NSLog(@"ppp2 block前=%ld",CFGetRetainCount((__bridge CFTypeRef)(ppp2))); // 3
//


// 1  + 1
void(^block)(void) = ^{

    NSLog(@"ok block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(ok)));   // 5
    NSLog(@"ppp block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(ppp))); // 5
    NSLog(@"ppp2 block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(ppp2))); // 5
};




NSLog(@"%@",[block class]);
block();
//

NSLog(@"-----------------------------");
void(^block2)(void) = ^{

    NSLog(@"ok block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(ok)));   // 7
    NSLog(@"ppp block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(ppp))); // 7
    NSLog(@"ppp2 block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(ppp2))); // 7

};

block2();




NSObject *yang = [[NSObject alloc] init];
__block NSObject *yang2 = yang;
NSLog(@"yang=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
NSLog(@"yang2=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
NSLog(@"-----------------------------");

void(^block)(void) = ^{
    NSLog(@"yang block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
};
NSLog(@"block类型=%@",[block class]);
block();

NSLog(@"-----------------------------");
void(^block2)(void) = ^{
    NSLog(@"yang block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
};
NSLog(@"block2类型=%@",[block2 class]);
block2();



NSObject *yang = [[NSObject alloc] init];
__block NSObject *yang2 = yang;
__block NSObject *yang3 = yang;
NSLog(@"yang=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
NSLog(@"yang2=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
NSLog(@"yang3=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang3)));
NSLog(@"-----------------------------");

void(^block)(void) = ^{
    NSLog(@"yang block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
    NSLog(@"yang3 block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang3)));
};
NSLog(@"block类型=%@",[block class]);
block();

NSLog(@"-----------------------------");
void(^block2)(void) = ^{
    NSLog(@"yang block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
    NSLog(@"yang3 block2内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang3)));
};
NSLog(@"block2类型=%@",[block2 class]);
block2();

yang=3
yang2=3
yang3=3
-----------------------------
block类型=__NSMallocBlock__
yang block内=5
yang2 block内=5
yang3 block内=5
-----------------------------
block2类型=__NSMallocBlock__
yang block2内=7
yang2 block2内=7
yang3 block2内=7







NSObject *yang = [[NSObject alloc] init];
__block NSObject *yang2 = yang;
NSLog(@"yang=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
NSLog(@"yang2=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
NSLog(@"-----------------------------");
void(^__weak block)(void) = ^{
    NSLog(@"yang block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
   
};
NSLog(@"block类型=%@",[block class]);
block();

yang=2
yang2=2
-----------------------------
block类型=__NSStackBlock__
yang block内=3
yang2 block内=3
(lldb)





NSObject *yang = [[NSObject alloc] init];
__block NSObject *yang2 = yang;
NSLog(@"yang=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
NSLog(@"yang2=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
NSLog(@"-----------------------------");
void(^__weak block)(void) = ^{
    NSLog(@"yang block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));
   
};
NSLog(@"block类型=%@",[block class]);
block();

NSLog(@"-----------------------------");
void(^block2)(void) = [block copy];
NSLog(@"block2类型=%@",[block2 class]);
block2();

NSLog(@"-----------------------------");
void(^block3)(void) = ^{
    NSLog(@"yang block3内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang)));
    NSLog(@"yang2 block3内=%ld",CFGetRetainCount((__bridge CFTypeRef)(yang2)));

};
NSLog(@"block3类型=%@",[block3 class]);
block3();
NSLog(@"-----------------------------");

