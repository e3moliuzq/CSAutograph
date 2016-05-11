//
//  MyDrawInfo.m
//  CSAutograph
//
//  Created by e3mo on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "MyDrawInfo.h"

@implementation MyDrawInfo

+ (id)drawInfoWithColor:(UIColor *)color path:(UIBezierPath *)path width:(CGFloat)width
{
    MyDrawInfo *myDrawInfo = [[MyDrawInfo alloc] init];
    
    myDrawInfo.color = color;
    myDrawInfo.path = path;
    myDrawInfo.width = width;
    
    return myDrawInfo;
}

@end
