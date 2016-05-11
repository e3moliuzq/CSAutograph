//
//  ViewController.m
//  CSAutograph
//
//  Created by e3mo on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ViewController.h"
#import "CSAutographDrawView.h"

@interface ViewController () {
    CSAutographDrawView *draw_view;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    draw_view = [[CSAutographDrawView alloc] initWithFrame:CGRectMake(10, 30, winsize.width-20, winsize.height-90)];
    draw_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:draw_view];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, winsize.height-40, winsize.width, 40)];
    [btn setTitle:@"GET!" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeImage:(UIButton*)btn {
    [btn removeFromSuperview];
    btn = nil;
}

- (void)getImage {
    if (![draw_view isAutograph]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请签名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImage *image = [draw_view snapshot];
    if (!image) {
        return;
    }
    [draw_view clearAll];
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:draw_view.frame];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

@end
