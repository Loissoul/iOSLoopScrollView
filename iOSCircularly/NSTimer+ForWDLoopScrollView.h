//
//  NSTimer+ForWDLoopScrollView.h
//  iOSCircularly
//
//  Created by Lois_pan on 2017/9/18.
//  Copyright © 2017年 Lois_pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ForWDLoopScrollView)

// 暂停
- (void)pause;
// 重新开始
- (void)restart;
// 延迟一定时间启动
- (void)restartAfterTimeInterval:(NSTimeInterval)interval;


@end
