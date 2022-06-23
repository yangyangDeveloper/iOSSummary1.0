//
//  SceneDelegate.h
//  APP生命周期
//
//  Created by zhangyangyang on 2022/6/23.
//

/*
 之前iOS 一个应用程序之后一个界面窗口
 iOS13之后 为了iPadOS的多窗口支持，它可以高效的把应用委托工作分成两部分
 
 */
#import <UIKit/UIKit.h>

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

