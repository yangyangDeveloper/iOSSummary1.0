//
//  M4.h
//  03_内存管理
//
//  Created by zhangyangyang on 2021/11/27.
//

#ifndef M4_h
#define M4_h


#endif /* M4_h */
//        __block int age = 10;
//
//        NSObject *yang = [NSObject new];
//
//        __weak NSObject *yang2 = yang;
        
        NSObject *yang3 = [NSObject new];  // 1
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang3)));
        
        __block NSObject *yang4 = yang3;   // 2
        
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang3)));
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang4)));
        
        __block NSObject *yang5 = yang4;   // 3
        
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang3)));
        NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang5)));   //  3

        void(^__weak yangblock)(void) = ^{
            NSLog(@"%ld",CFGetRetainCount((__bridge CFTypeRef)(yang5))); //  3
//            NSLog(@"%d", age);
//            NSLog(@"%@", yang);
//            NSLog(@"%@", yang2);
//            NSLog(@"%@", yang3);
//            NSLog(@"%@", yang4);
        };
        yangblock();
//
