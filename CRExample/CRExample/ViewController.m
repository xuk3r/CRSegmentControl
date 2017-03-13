//
//  ViewController.m
//  CRExample
//
//  Created by MacMini2017 on 2017/3/8.
//  Copyright © 2017年 xuk. All rights reserved.
//

#import "ViewController.h"
#import "CRSegmentControl.h"

@interface ViewController ()<
CRSegmentControlDelegate
>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CRSegmentControl *segmentView = [[CRSegmentControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 160/2, 50, 160, 35)];
    segmentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:1];
    segmentView.tintColor = [UIColor whiteColor];
    segmentView.arrList = @[@"title1",@"title2",@"title3"];
    segmentView.indexSelected = 2;
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)crsegmentControl:(CRSegmentControl *)segmentControl selectedIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}


@end
