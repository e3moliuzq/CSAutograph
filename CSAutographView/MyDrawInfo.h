//
//  MyDrawInfo.h
//  CSAutograph
//
//  Created by e3mo on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyDrawInfo : NSObject


+ (id)drawInfoWithColor:(UIColor *)color path:(UIBezierPath *)path width:(CGFloat)width;

@property (strong, nonatomic) UIColor *color;

@property (strong, nonatomic) UIBezierPath *path;

@property (assign, nonatomic) CGFloat width;

@end
