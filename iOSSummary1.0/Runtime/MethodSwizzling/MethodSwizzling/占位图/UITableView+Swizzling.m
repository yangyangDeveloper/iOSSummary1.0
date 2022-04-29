//
//  UITableView+Swizzling.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/29.
//

#import "UITableView+Swizzling.h"
#import <objc/runtime.h>
#import "ZYYPlaceholderView.h"
#import "ZYYUITableview.h"

@implementation UITableView (Swizzling)

//+ (void)load {
//    Class cls = [self class];
//    if ([cls isMemberOfClass:[ZYYUITableview class]]) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            Class class = [self class];
//            SEL originalSelector = @selector(reloadData);
//            SEL swizzledSelector = @selector(zyy_reloadData);
//            Method originalMethod = class_getInstanceMethod(class, originalSelector);
//            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//            BOOL didAddMethod = class_addMethod(class,
//                                                originalSelector,
//                                                method_getImplementation(swizzledMethod),
//                                                method_getTypeEncoding(swizzledMethod));
//            if (didAddMethod) {
//                class_replaceMethod(class,
//                                    swizzledSelector,
//                                    method_getImplementation(originalMethod),
//                                    method_getTypeEncoding(originalMethod));
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod);
//            }
//        });
//    }else {
//        NSLog(@"不交换");
//    }
//}
//
//- (void)zyy_reloadData {
//    if (!self.firstReload) {
//        [self checkEmpty];
//    }
//    self.firstReload = NO;
//    [self zyy_reloadData];
//}
//
//- (void)checkEmpty {
//    NSLog(@"进入一次");
//    BOOL isEmpty = YES; // 判空 flag 标示
//    id <UITableViewDataSource> dataSource = self.dataSource;
//    NSInteger sections = 1; // 默认TableView 只有一组
//    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
//        sections = [dataSource numberOfSectionsInTableView:self] - 1; // 获取当前TableView 组数
//    }
//    for (NSInteger i = 0; i <= sections; i++) {
//        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:i]; // 获取当前TableView各组行数
//        if (rows) {
//            isEmpty = NO; // 若行数存在，不为空
//        }
//    }
//    if (isEmpty) { // 若为空，加载占位图
//        if (!self.placeholderView) { // 若未自定义，加载默认占位图
//            [self makeDefaultPlaceholderView];
//        }
//        self.placeholderView.hidden = NO;
//        [self addSubview:self.placeholderView];
//    } else { // 不为空，隐藏占位图
//        self.placeholderView.hidden = YES;
//    }
//}
//
//- (void)makeDefaultPlaceholderView {
//    self.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    ZYYPlaceholderView *placeholderView = [[ZYYPlaceholderView alloc] initWithFrame:self.bounds];
//    __weak typeof(self) weakSelf = self;
//    placeholderView.reloadBlock = ^{
//        if (weakSelf.reloadBlock) {
//            weakSelf.reloadBlock();
//        }
//    };
////    [placeholderView setReloadClickBlock:^{
////        if (weakSelf.reloadBlock) {
////            weakSelf.reloadBlock();
////        }
////    }];
//    self.placeholderView = placeholderView;
//}
//
//- (BOOL)firstReload {
//    return [objc_getAssociatedObject(self, @selector(firstReload)) boolValue];
//}
//
//- (void)setFirstReload:(BOOL)firstReload {
//    objc_setAssociatedObject(self, @selector(firstReload), @(firstReload), OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (UIView *)placeholderView {
//    return objc_getAssociatedObject(self, @selector(placeholderView));
//}
//- (void)setPlaceholderView:(UIView *)placeholderView {
//    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void (^)(void))reloadBlock {
//    return objc_getAssociatedObject(self, @selector(reloadBlock));
//}
//
//- (void)setReloadBlock:(void (^)(void))reloadBlock {
//    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

@end
