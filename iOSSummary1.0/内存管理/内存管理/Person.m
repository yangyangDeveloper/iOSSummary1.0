//
//  Person.m
//  内存管理
//
//  Created by zhangyangyang on 2022/5/13.
//

#import "Person.h"


@implementation Person
//@synthesize name = _name;

- (void)setName:(NSString *)name {
    if (_name != name) {
        [_name release];
        _name = [name retain];
    }
}

- (NSString *)name {
    return _name;
}

- (void)dealloc {
    [_name release];
    _name = nil;
    [super dealloc];
}
@end
