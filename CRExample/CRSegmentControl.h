//
//
//  CRSegmentControl
//
//  Created by xuk on 2017/3/7.
//  Copyright © 2017年 xuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRSegmentControl;
@protocol CRSegmentControlDelegate <NSObject>

- (void)crsegmentControl:(CRSegmentControl *)segmentControl
           selectedIndex:(NSInteger)index;

@end

@interface CRSegmentControl : UIView

///代理
@property (nonatomic, assign)  id<CRSegmentControlDelegate>delegate ;
///数据
@property (nonatomic, strong) NSArray <NSString *>*arrList ;
///目前所选序号
@property (nonatomic, assign) NSInteger indexSelected;
///tintColor为文字颜色和滑块背景色

@end
