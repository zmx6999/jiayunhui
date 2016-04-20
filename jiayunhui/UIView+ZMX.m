//
//  UIView+ZMX.m
//  jiayunhui
//
//  Created by zmx on 16/1/12.
//  Copyright © 2016年 com. All rights reserved.
//

#import "UIView+ZMX.h"

@implementation UIView (ZMX)

- (UIViewController *)getViewController {
    UIResponder *responder = self.nextResponder;
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    return nil;
}

@end
