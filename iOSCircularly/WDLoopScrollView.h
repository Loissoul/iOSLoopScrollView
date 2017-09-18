//
//  WDLoopScrollView.h
//  iOSCircularly
//
//  Created by Lois_pan on 2017/9/18.
//  Copyright © 2017年 Lois_pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDLoopScrollView;

@protocol WDLoopScrollViewDelegate <NSObject>
@required

- (NSInteger)wd_numberOfContentViewsInLoopScrollView:(WDLoopScrollView *)loopScrollView;

- (UIView *)wd_loopScrollView:(WDLoopScrollView *)loopScrollView contentViewAtIndex:(NSInteger)index;

@optional

- (void)wd_loopScrollView:(WDLoopScrollView *)loopScrollView currentContentViewAtIndex:(NSInteger)index;

- (void)wd_loopScrollView:(WDLoopScrollView *)loopScrollView didSelectContentViewAtIndex:(NSInteger)index;


@end

@interface WDLoopScrollView : UIView

@property (nonatomic,assign) id<WDLoopScrollViewDelegate> delegate;

// 当duration<=0时，默认不自动滚动
- (id)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration;

- (void)reloadData;

@end
