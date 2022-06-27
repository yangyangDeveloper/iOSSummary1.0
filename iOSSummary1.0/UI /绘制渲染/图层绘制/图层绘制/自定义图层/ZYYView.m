//
//  ZYYView.m
//  图层绘制
//
//  Created by zhangyangyang on 2022/6/23.
//

#import "ZYYView.h"

@implementation ZYYView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSString *text = @"drawRect:(CGRect)rect";
    CGRect textFrame=CGRectMake(0, 0, 250, 250);
    NSDictionary *dict=@{
        NSFontAttributeName:[UIFont systemFontOfSize:20],
        NSForegroundColorAttributeName:[UIColor redColor],
        NSStrokeWidthAttributeName:@10
    };
    //UIRectFill(textFrame);
    [text drawInRect:textFrame withAttributes:dict];
    //[text drawAtPoint:CGPointZero withAttributes:dict];
}

@end
