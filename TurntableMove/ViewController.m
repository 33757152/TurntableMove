//
//  ViewController.m
//  TurntableMove
//
//  Created by 张锦江 on 2019/11/25.
//  Copyright © 2019 zyy. All rights reserved.
//

#import "ViewController.h"
#import "QriaCircleSelectView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    QriaCircleSelectView *view = [[QriaCircleSelectView alloc] initWithFrame:CGRectMake(30, 50, self.view.frame.size.width-60, self.view.frame.size.width-60) withTitleArray:@[@"第一项", @"第二项", @"第三项", @"第四项", @"第五项"]];
    view.probabilityArray = @[@0.70, @0.10, @0.10, @0.10, @0.0];
    view.colorArray = @[[UIColor blackColor], [UIColor redColor], [UIColor blueColor], [UIColor grayColor], [UIColor purpleColor]];
    [self.view addSubview:view];
}

@end
