//
//
//  CRSegmentControl
//
//  Created by xuk on 2017/3/7.
//  Copyright © 2017年 xuk. All rights reserved.
//

#import "UIButton+CRCategory.h"

@implementation UIButton (CRCategory)

- (UIButton *)btnMask
{
    UIButton *btn = [self viewWithTag:998];
    if (!btn)
    {
        
    }
    return btn;
}

- (void)setBtnMask:(UIButton *)btnMask
{
    btnMask.tag = 998;
}

@end
