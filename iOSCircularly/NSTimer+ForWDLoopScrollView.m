//
//  NSTimer+ForWDLoopScrollView.m
//  iOSCircularly
//
//  Created by Lois_pan on 2017/9/18.
//  Copyright © 2017年 Lois_pan. All rights reserved.
//

#import "NSTimer+ForWDLoopScrollView.h"

@implementation NSTimer (ForWDLoopScrollView)

- (void)pause{
    
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

- (void)restart{
    
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}

- (void)restartAfterTimeInterval:(NSTimeInterval)interval{
    
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
}


@end
