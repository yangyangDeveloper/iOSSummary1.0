//
//  ZYYTableViewCell.m
//  列表
//
//  Created by zhangyangyang on 2022/6/9.
//

#import "ZYYTableViewCell.h"

@implementation ZYYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self configUI];
    }
    return self;
    
}

- (void)configUI {

}

@end
