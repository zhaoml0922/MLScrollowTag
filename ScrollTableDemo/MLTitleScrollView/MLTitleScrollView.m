//
//  MLTitleScrollView.m
//  ScrollTableDemo
//
//  Created by zhaoml on 2017/3/24.
//  Copyright © 2017年 zhaoml. All rights reserved.
//
#define btnFont  15


#import "MLTitleScrollView.h"

@implementation MLTitleScrollView

{
    NSMutableArray *btnArray;
    UIView *lineView;
    CGRect SFrame;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        SFrame = frame;
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray {
    self.showsHorizontalScrollIndicator = NO;
    
    if (titleArray.count == 0) {
        self.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        return;
    }
    for(UIButton *delete in self.subviews){
        [delete removeFromSuperview];
    }
    _titleArray = titleArray;
    btnArray = [NSMutableArray array];
    for (int i=0; i<titleArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        CGFloat width = [self getWidthWithStr:titleArray[i] andHeight:0 andTextFont:btnFont]+20;
        btn.tag = 10000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.frame = CGRectMake(0, 0, width, SFrame.size.height-2);
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            UIButton *btn0 = btnArray[i-1];
            btn.frame = CGRectMake(ViewEndX(btn0)+20, 0, width, SFrame.size.height-2);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [self addSubview:btn];
        
        [btnArray addObject:btn];
    }
    UIButton *btn0 = [btnArray firstObject];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(10, SFrame.size.height -2, btn0.frame.size.width-20, 2)];
    lineView.backgroundColor = [UIColor blueColor];
    [self addSubview:lineView];
    
    
    UIButton *lastBtn = [btnArray lastObject];
    self.contentSize = CGSizeMake(ViewEndX(lastBtn), 0);
}



- (void)btnClick:(UIButton *)btn{
    for(UIButton *button in btnArray){
        if (button == btn) {
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [btn convertRect:btn.bounds toView:window];
    CGFloat posileft = rect.origin.x;
    if (btn.tag - 10000 == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    }else if (btn.tag - 10000 == btnArray.count-1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = CGPointMake(btn.frame.origin.x-SCREEN_WIDTH+btn.frame.size.width, 0);
        }];
    }
    else{
        UIButton *lastBtn = btnArray[btn.tag - 10000 - 1];
        UIButton *nextBtn = btnArray[btn.tag - 10000 + 1];
        if (posileft-lastBtn.frame.size.width<0) {
            [UIView animateWithDuration:0.5 animations:^{
                self.contentOffset = CGPointMake(lastBtn.frame.origin.x, 0);
            }];
        }
        if (posileft +btn.frame.size.width + nextBtn.frame.size.width>SCREEN_WIDTH) {
            [UIView animateWithDuration:0.5 animations:^{
                self.contentOffset = CGPointMake(nextBtn.frame.origin.x-SCREEN_WIDTH+nextBtn.frame.size.width, 0);
            }];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        lineView.frame = CGRectMake(btn.frame.origin.x+10, SFrame.size.height -2, btn.frame.size.width-20, 2);
    }];
    [self.myDelegate scrollowButtonClick:btn.tag - 10000];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if (index>=_titleArray.count) {
        return;
    }
    UIButton *btn = (UIButton *)[self viewWithTag:10000+index];
    [self btnClick:btn];
}

-(CGFloat)getWidthWithStr:(NSString *)str
                andHeight:(CGFloat)height
              andTextFont:(int)num
{
    if(str.length>0)
    {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT,height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]}
                                        context:nil];
        float wight = rect.size.width;
        return wight+2;
    }else{
        return 5;
    }
}


@end
