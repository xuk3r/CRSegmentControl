//
//
//  CRSegmentControl
//
//  Created by xuk on 2017/3/7.
//  Copyright © 2017年 xuk. All rights reserved.
//

#import "CRSegmentControl.h"
#import "UIButton+CRCategory.h"
#import "UIView+FrameExt.h"

#define M_WPSegmentView_INTERVAL 1.5

@interface CRSegmentControl ()

@property (nonatomic, strong) NSMutableArray *marrSubButtons;
@property (nonatomic, strong) UIButton *btnLastClick;

@end

@implementation CRSegmentControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = frame.size.height/2.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

#pragma mark - Setter && Getter

- (void)setArrList:(NSArray *)arrList
{
    _arrList = arrList;
    self.imgViewBackground.hidden = (arrList.count == 0);
    [self initView];
    self.indexSelected = 0;
}

- (void)setIndexSelected:(NSInteger)indexSelected
{
    if (indexSelected > self.marrSubButtons.count || indexSelected < 0)
    {
        _indexSelected = -1;
        return;
    }
    _indexSelected = indexSelected;
    [self clickFunction:self.marrSubButtons[indexSelected]];
}

- (NSMutableArray *)marrSubButtons
{
    if (!_marrSubButtons)
    {
        _marrSubButtons = [NSMutableArray array];
    }
    return _marrSubButtons;
}

- (UIImageView *)imgViewBackground
{
    if (!_imgViewBackground)
    {
        _imgViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(M_WPSegmentView_INTERVAL, M_WPSegmentView_INTERVAL, self.frame.size.width - M_WPSegmentView_INTERVAL * 2, self.frame.size.height - 2 * M_WPSegmentView_INTERVAL)];
        _imgViewBackground.backgroundColor = [UIColor whiteColor];
        _imgViewBackground.layer.cornerRadius = _imgViewBackground.frame.size.height/2.0f;
        _imgViewBackground.layer.masksToBounds = YES;
        [self addSubview:_imgViewBackground];
    }
    return _imgViewBackground;
}

- (void)initView
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.imgViewBackground])
        {
            [obj removeFromSuperview];
        }
    }];
    
    self.marrSubButtons = nil;
    
    CGFloat width = self.frame.size.width/self.arrList.count;
    for (int i = 0 ; i < self.arrList.count ; i++)
    {
        NSString *strTitle = self.arrList[i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        [btn setTitle:strTitle forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self
                action:@selector(clickFunction:)
      forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitleColor:self.backgroundColor forState:UIControlStateSelected];
        [btn setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.marrSubButtons addObject:btn];
        
        UIButton *btnMask = [[UIButton alloc]initWithFrame:btn.bounds];
        [btnMask setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        btnMask.titleLabel.font = btn.titleLabel.font;
        [btnMask setTitleColor:self.backgroundColor
                      forState:UIControlStateNormal];
        btnMask.userInteractionEnabled = NO;
        btnMask.maskView = [UIView new];
        btnMask.tag = 998;
        btn.btnMask = btnMask;
        [btn addSubview:btnMask];
        
        if (i == 0)
        {
            self.imgViewBackground.frame = CGRectMake(M_WPSegmentView_INTERVAL, M_WPSegmentView_INTERVAL, width - 2* M_WPSegmentView_INTERVAL, self.frame.size.height - 2 * M_WPSegmentView_INTERVAL);
            self.imgViewBackground.center = btn.center;
        }
    }
//    [self bringSubviewToFront:self.imgViewBackground];
}


#pragma mark - UserInteraction
- (void)clickFunction:(UIButton *)sender
{
    if ([sender isEqual:self.btnLastClick])
    {
        return;
    }
    
    BOOL isScrollFromLeft = NO;
    if (self.btnLastClick.tag < sender.tag)
    {
        isScrollFromLeft = YES;
    }
    
    UIView *viewMaskLast;
    if (self.btnLastClick)
    {
        self.btnLastClick.selected = NO;
        viewMaskLast = self.btnLastClick.btnMask.maskView ;
    }
    self.btnLastClick = sender;
    
    UIView *view = [[UIView alloc]initWithFrame:self.imgViewBackground.frame];
    view.backgroundColor = [UIColor blueColor];
    view.leftExt = isScrollFromLeft ? -view.widthExt : view.widthExt;
    sender.btnMask.maskView = view;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self.imgViewBackground.center = sender.center;
        view.leftExt = 0;
        if (viewMaskLast)
        {
            viewMaskLast.leftExt = isScrollFromLeft?viewMaskLast.widthExt:-viewMaskLast.widthExt;
        }
    } completion:^(BOOL finished) {
//        view.frame = CGRectZero;
    }];
}


@end
