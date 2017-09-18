//
//  UIView+ForWDLoopScrollView.m
//  iOSCircularly
//
//  Created by Lois_pan on 2017/9/18.
//  Copyright © 2017年 Lois_pan. All rights reserved.
//

#import "UIView+ForWDLoopScrollView.h"

@implementation UIView (ForWDLoopScrollView)

- (UIView *)copyView{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


@end
