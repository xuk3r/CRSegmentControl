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

#define M_CRSegmentView_INTERVAL 1.5 ////滑块默认间距

@interface CRSegmentControl ()

///所有按钮
@property (nonatomic, strong) NSMutableArray *marrSubButtons;
///最后点击按钮
@property (nonatomic, strong) UIButton *btnLastClick;
///背景滑块
@property (nonatomic, strong) UIImageView *imgViewBackground;

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
        _imgViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(M_CRSegmentView_INTERVAL, M_CRSegmentView_INTERVAL, self.frame.size.width - M_CRSegmentView_INTERVAL * 2, self.frame.size.height - 2 * M_CRSegmentView_INTERVAL)];
        _imgViewBackground.backgroundColor = [UIColor whiteColor];
        _imgViewBackground.layer.cornerRadius = _imgViewBackground.frame.size.height/2.0f;
        _imgViewBackground.layer.masksToBounds = YES;
        [self addSubview:_imgViewBackground];
    }
    return _imgViewBackground;
}

#pragma mark - View

- (void)initView
{
    ///移除子视图
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.imgViewBackground])
        {
            [obj removeFromSuperview];
        }
    }];
    self.marrSubButtons = nil;
    
    ///创建按钮
    CGFloat width = self.frame.size.width/self.arrList.count;
    for (int i = 0 ; i < self.arrList.count ; i++)
    {
        NSString *strTitle = self.arrList[i];
        
        ///主按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, self.frame.size.height)];
        [btn setTitle:strTitle forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        [btn addTarget:self
                action:@selector(clickFunction:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:self.tintColor forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.marrSubButtons addObject:btn];
        
        ///遮罩按钮
        UIButton *btnMask = [[UIButton alloc]initWithFrame:btn.bounds];
        [btnMask setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        btnMask.titleLabel.font = btn.titleLabel.font;
        [btnMask setTitleColor:self.backgroundColor
                      forState:UIControlStateNormal];
        btnMask.userInteractionEnabled = NO;
        btnMask.maskView = [UIView new];
        btn.btnMask = btnMask;
        [btn addSubview:btnMask];
        
        ///将背景移动到第0个按钮后
        if (i == 0)
        {
            self.imgViewBackground.frame = CGRectMake(M_CRSegmentView_INTERVAL, M_CRSegmentView_INTERVAL, width - 2* M_CRSegmentView_INTERVAL, self.frame.size.height - 2 * M_CRSegmentView_INTERVAL);
            self.imgViewBackground.center = btn.center;
        }
    }
}


#pragma mark - UserInteraction
- (void)clickFunction:(UIButton *)sender
{
    ///点击同一个按钮
    if ([sender isEqual:self.btnLastClick])
    {
        return;
    }
    ///判断遮罩方向
    BOOL isScrollFromLeft = NO;
    if (self.btnLastClick.tag < sender.tag)
    {
        isScrollFromLeft = YES;
    }
    ///获取上一次点击按钮遮罩
    UIView *viewMaskLast;
    if (self.btnLastClick)
    {
        self.btnLastClick.selected = NO;
        viewMaskLast = self.btnLastClick.btnMask.maskView ;
    }
    self.btnLastClick = sender;
    self.indexSelected = sender.tag;
    
    ///本次遮罩
    UIView *viewMask = sender.btnMask.maskView;
    ///防止获取不到view
    if (!viewMask)
    {
        viewMask = [UIView new];
    }
    viewMask.frame = self.imgViewBackground.frame;
    viewMask.backgroundColor = [UIColor blueColor];
    viewMask.leftExt = isScrollFromLeft ? -viewMask.widthExt : viewMask.widthExt;
    ///aniamtion
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self.imgViewBackground.center = sender.center;
        viewMask.leftExt = 0;
        if (viewMaskLast)
        {
            viewMaskLast.leftExt = isScrollFromLeft?viewMaskLast.widthExt:-viewMaskLast.widthExt;
        }
    } completion:^(BOOL finished) {

    }];
    ///delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(crsegmentControl:selectedIndex:)])
    {
        [self.delegate crsegmentControl:self selectedIndex:sender.tag];
    }
}


@end
