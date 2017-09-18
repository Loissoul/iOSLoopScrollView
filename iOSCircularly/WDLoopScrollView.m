//
//  WDLoopScrollView.m
//  iOSCircularly
//
//  Created by Lois_pan on 2017/9/18.
//  Copyright © 2017年 Lois_pan. All rights reserved.
//

#import "WDLoopScrollView.h"
#import "NSTimer+ForWDLoopScrollView.h"
#import "UIView+ForWDLoopScrollView.h"
#import "TAPageControl.h"


#define SelfWidth     (self.frame.size.width)
#define SelfHeight    (self.frame.size.height)

@interface WDLoopScrollView() <UIScrollViewDelegate> {
    UIScrollView   * _scrollView;
    
    NSInteger        _totalPageCount;
    NSInteger        _currentPageIndex;
    
    NSTimer        * _animationTimer;
    NSTimeInterval   _animationDuration;
    
    UIPageControl  * _pageControlWd;
    
}


@end

@implementation WDLoopScrollView


- (id)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initData];
        
        [self initAnimationScrollTimerWithDuration:duration];
        
        [self buildScrollView];
    }
    return self;
}

- (void)initData {
    _animationTimer    = nil;
    _animationDuration = 0;
}

- (void)initAnimationScrollTimerWithDuration:(NSTimeInterval)duration {
    _animationDuration = duration;
    
    if (duration > 0) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                           target:self
                                                         selector:@selector(startScroll:)
                                                         userInfo:nil
                                                          repeats:YES];
        NSRunLoop *main = [NSRunLoop currentRunLoop];
        [main addTimer:_animationTimer forMode:NSRunLoopCommonModes];
        [_animationTimer pause];
    }
}

- (void)buildScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SelfWidth, SelfHeight)];
    _scrollView.delegate         = self;
    _scrollView.contentSize      = CGSizeMake(SelfWidth *3, SelfHeight);
    _scrollView.contentOffset    = CGPointMake(SelfWidth, 0);
    _scrollView.pagingEnabled    = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    [self addSubview:_scrollView];
}

- (void)setDelegate:(id<WDLoopScrollViewDelegate>)delegate {
    _delegate = delegate;
    
    [self reloadData];
}

- (void)reloadData {
    _currentPageIndex  = 0;
    _totalPageCount    = 0;
    
    if ([self.delegate respondsToSelector:@selector(wd_numberOfContentViewsInLoopScrollView:)]) {
        _totalPageCount = [self.delegate wd_numberOfContentViewsInLoopScrollView:self];
    }else{
        NSAssert(NO, @"请实现numberOfContentViewsInLoopScrollView:代理函数");
    }
    
    [self setupPageControl];
    [self resetContentViews];
    [_animationTimer restartAfterTimeInterval:_animationDuration];
}

//重置页面
- (void)resetContentViews {

    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger beforePageIndex = [self getPreviousPageIndexWithCurrentPageIndex:_currentPageIndex];
    NSInteger currentPageIndex  = _currentPageIndex;
    NSInteger nextPageIndex     = [self getNextPageIndexWithCurrentPageIndex:_currentPageIndex];
    
    UIView * previousContentView;
    UIView * currentContentView;
    UIView * nextContentView;

    if ([self.delegate respondsToSelector:@selector(wd_loopScrollView:contentViewAtIndex:)]) {
        
        previousContentView = [self.delegate wd_loopScrollView:self contentViewAtIndex:beforePageIndex];
        currentContentView  = [self.delegate wd_loopScrollView:self contentViewAtIndex:currentPageIndex];
        nextContentView     = [self.delegate wd_loopScrollView:self contentViewAtIndex:nextPageIndex];
        
        NSArray * viewsArr = @[[previousContentView copyView],[currentContentView copyView],[nextContentView copyView]]; // copy操作主要是为了只有两张内容视图的情况
        
        for (int i = 0; i < viewsArr.count; i++) {
            UIView * contentView = viewsArr[i];
            
            [contentView setFrame:CGRectMake(SelfWidth*i, 0, contentView.frame.size.width, contentView.frame.size.height)];
            contentView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
            [contentView addGestureRecognizer:tapGesture];
            
            [_scrollView insertSubview:contentView belowSubview:_pageControlWd];
        }
        
        [_scrollView setContentOffset:CGPointMake(SelfWidth, 0)];
        
    }else{
        NSAssert(NO, @"请实现loopScrollView:contentViewAtIndex:代理函数");
    }
}

// 获取当前页上一页的序号
- (NSInteger)getPreviousPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    if (currentIndex == 0) {
        return _totalPageCount - 1;
    } else {
        return currentIndex - 1;
    }
}

// 获取当前页下一页的序号
- (NSInteger)getNextPageIndexWithCurrentPageIndex:(NSInteger)currentIndex{
    if (currentIndex == _totalPageCount -1) {
        return 0;
    } else {
        return currentIndex + 1;
    }
}

#pragma mark - action
- (void)startScroll:(NSTimer *)timer{
    CGFloat contentOffsetX = ( (int)(_scrollView.contentOffset.x +SelfWidth) / (int)SelfWidth ) * SelfWidth;
    CGPoint newOffset = CGPointMake(contentOffsetX, 0);
    [_scrollView setContentOffset:newOffset animated:YES];
}

- (void)tapContentView:(UITapGestureRecognizer *)gesture{
    
    if ([self.delegate respondsToSelector:@selector(wd_loopScrollView:didSelectContentViewAtIndex:)]) {
        [self.delegate wd_loopScrollView:self didSelectContentViewAtIndex:_currentPageIndex];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 当手动滑动时 暂停定时器
    [_animationTimer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 当手动滑动结束时 开启定时器
    [_animationTimer restartAfterTimeInterval:_animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsetX = scrollView.contentOffset.x;
    
    if(contentOffsetX >= (2 * SelfWidth)) {
        _currentPageIndex = [self getNextPageIndexWithCurrentPageIndex: _currentPageIndex];
        // 调用代理函数 当前页面序号
        if ([self.delegate respondsToSelector:@selector(wd_loopScrollView:currentContentViewAtIndex:)]) {
            [self.delegate wd_loopScrollView:self currentContentViewAtIndex:_currentPageIndex];
        }
        [self resetContentViews];
    }
    
    if(contentOffsetX <= 0) {
        _currentPageIndex = [self getPreviousPageIndexWithCurrentPageIndex:_currentPageIndex];
        // 调用代理函数 当前页面序号
        if ([self.delegate respondsToSelector:@selector(wd_loopScrollView:currentContentViewAtIndex:)]) {
            [self.delegate wd_loopScrollView:self currentContentViewAtIndex:_currentPageIndex];
        }
        [self resetContentViews];
    }
    _pageControlWd.currentPage = _currentPageIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(SelfWidth, 0) animated:YES];
}

//MARK: - 设置pageControl
- (void)setupPageControl {
    CGSize pageControlDotSize = CGSizeMake(2, 2);
    CGSize size = CGSizeZero;
    size = CGSizeMake(_totalPageCount * pageControlDotSize.width * 1.5, pageControlDotSize.height);
    CGFloat x = (SelfWidth - size.width) * 0.5;
    CGFloat y = SelfHeight - size.height - 10;
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);

    if (_pageControlWd) [_pageControlWd removeFromSuperview];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame: pageControlFrame];
    pageControl.numberOfPages = _totalPageCount;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = _currentPageIndex;
    pageControl.tintColor = [UIColor blackColor];
    [self addSubview:pageControl];
    _pageControlWd = pageControl;
}


@end
