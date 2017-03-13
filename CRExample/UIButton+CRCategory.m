//
//
//  CRSegmentControl
//
//  Created by xuk on 2017/3/7.
//  Copyright © 2017年 xuk. All rights reserved.
//

#import "UIButton+CRCategory.h"
#import <objc/runtime.h>

@implementation UIButton (CRCategory)

- (UIButton *)btnMask
{
    UIButton *btn = objc_getAssociatedObject(self, @selector(btnMask));
    return btn;
}

- (void)setBtnMask:(UIButton *)btnMask
{
    objc_setAssociatedObject(self, @selector(btnMask), btnMask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
