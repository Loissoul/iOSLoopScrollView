//
//  ViewController.m
//  iOSCircularly
//
//  Created by Lois_pan on 2017/9/18.
//  Copyright © 2017年 Lois_pan. All rights reserved.
//

#import "ViewController.h"
#import "WDLoopScrollView.h"

@interface ViewController () <WDLoopScrollViewDelegate> {

    NSMutableArray * _bannerMutableArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _bannerMutableArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];

    for (int i = 0; i < 3; i++) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
        tempLabel.backgroundColor = colorArray[i];
        tempLabel.textAlignment   = NSTextAlignmentCenter;
        tempLabel.text            = [NSString stringWithFormat:@"%d",i];
        tempLabel.font            = [UIFont boldSystemFontOfSize:50];
        [_bannerMutableArr addObject:tempLabel];
    }
    
    WDLoopScrollView * scrollView = [[WDLoopScrollView alloc] initWithFrame:CGRectMake(20, 100, 280, 200) animationScrollDuration:3];
    scrollView.delegate        = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
}


#pragma mark - LMJEndlessLoopScrollView Delegate
- (NSInteger)wd_numberOfContentViewsInLoopScrollView:(WDLoopScrollView *)loopScrollView{
    return _bannerMutableArr.count;
}

- (UIView *)wd_loopScrollView:(WDLoopScrollView *)loopScrollView contentViewAtIndex:(NSInteger)index{
    NSLog(@"-----------------------------%ld", index);
    return _bannerMutableArr[index];
}

- (void)wd_loopScrollView:(WDLoopScrollView *)loopScrollView didSelectContentViewAtIndex:(NSInteger)index{
    NSLog(@"----点击-----%ld",index);
}

- (void)wd_loopScrollView:(WDLoopScrollView *)loopScrollView currentContentViewAtIndex:(NSInteger)index{
    NSLog(@"----当前-----%ld",index);
}



@end
