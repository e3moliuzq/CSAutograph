//
//  CSAutographDrawView.m
//  CSAutograph
//
//  Created by e3mo on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "CSAutographDrawView.h"
#import "MyDrawInfo.h"
#import "UIColor+GetHSB.h"

@interface CSAutographDrawView () {
    
}
@end

@implementation CSAutographDrawView

#define SYS_LOGO_IMAGE_NAME         @"icon_popup_sign@2x.png"

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _pathArray = [[NSMutableArray alloc] init];
        remove_pathArray = [[NSMutableArray alloc] init];
        remove_all_array = [[NSMutableArray alloc] init];
        line_color = [UIColor blackColor];
        line_width = 4.f;
        
        [self initMenu];
    }
    
    return self;
}

#pragma mark - menu
- (void)setIsShowMenu:(BOOL)isShow {
    if (isShow) {
        [self initMenu];
    }
    else {
        [menu_view removeFromSuperview];
        menu_view = nil;
    }
}

- (void)setMenuHidden:(BOOL)hidden {
    if (slider) {
        [slider removeFromSuperview];
        slider = nil;
    }
    if (colorPicker) {
        [colorPicker removeFromSuperview];
        colorPicker = nil;
        
        [huePicker removeFromSuperview];
        huePicker = nil;
    }
    [menu_view setHidden:hidden];
}

- (void)initMenu {
    if (menu_view) {
        [menu_view removeFromSuperview];
        menu_view = nil;
    }
    
    menu_view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    [menu_view setBackgroundColor:[UIColor clearColor]];
    [self addSubview:menu_view];
    
    clear_all_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clear_all_btn setFrame:CGRectMake(10, 0, 50, 40)];
    [clear_all_btn setTitle:@"清除" forState:UIControlStateNormal];
    [clear_all_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clear_all_btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0.8 alpha:1] forState:UIControlStateHighlighted];
    [clear_all_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [clear_all_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [clear_all_btn setBackgroundColor:[UIColor clearColor]];
    [clear_all_btn addTarget:self action:@selector(removeAll) forControlEvents:UIControlEventTouchUpInside];
    [menu_view addSubview:clear_all_btn];
    
    clear_last_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clear_last_btn setFrame:CGRectMake(70, 0, 50, 40)];
    [clear_last_btn setTitle:@"撤销" forState:UIControlStateNormal];
    [clear_last_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clear_last_btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0.8 alpha:1] forState:UIControlStateHighlighted];
    [clear_last_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [clear_last_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [clear_last_btn setBackgroundColor:[UIColor clearColor]];
    [clear_last_btn addTarget:self action:@selector(removeLast) forControlEvents:UIControlEventTouchUpInside];
    [menu_view addSubview:clear_last_btn];
    
    restore_last_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [restore_last_btn setFrame:CGRectMake(130, 0, 50, 40)];
    [restore_last_btn setTitle:@"恢复" forState:UIControlStateNormal];
    [restore_last_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [restore_last_btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0.8 alpha:1] forState:UIControlStateHighlighted];
    [restore_last_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [restore_last_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [restore_last_btn setBackgroundColor:[UIColor clearColor]];
    [restore_last_btn addTarget:self action:@selector(restoreLast) forControlEvents:UIControlEventTouchUpInside];
    [menu_view addSubview:restore_last_btn];
    
    thickness_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [thickness_btn setFrame:CGRectMake(190, 0, 70, 40)];
    [thickness_btn setTitle:@"笔粗:4.0" forState:UIControlStateNormal];
    [thickness_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [thickness_btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0.8 alpha:1] forState:UIControlStateHighlighted];
    [thickness_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [thickness_btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [thickness_btn setBackgroundColor:[UIColor clearColor]];
    [thickness_btn addTarget:self action:@selector(chooseThickness:) forControlEvents:UIControlEventTouchUpInside];
    [menu_view addSubview:thickness_btn];
    
    color_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [color_btn setFrame:CGRectMake(270, 10, 20, 20)];
    [color_btn setBackgroundColor:[UIColor blackColor]];
    [color_btn addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
    //不能和加圆角同时使用
    color_btn.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    color_btn.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移x，y向下偏移y，默认(0, -3),这个跟shadowRadius配合使用
    color_btn.layer.shadowOpacity = 1;//阴影透明度，默认0
    color_btn.layer.shadowRadius = 2;//阴影半径，默认3
    [menu_view addSubview:color_btn];
    
    [self changeMenuEnable];
}

- (void)changeMenuEnable {
    if (_pathArray && _pathArray.count > 0) {
        [clear_all_btn setEnabled:YES];
        [clear_last_btn setEnabled:YES];
    }
    else {
        [clear_all_btn setEnabled:NO];
        [clear_last_btn setEnabled:NO];
    }
    
    if (remove_all_array.count > 0 || remove_pathArray.count > 0) {
        [restore_last_btn setEnabled:YES];
    }
    else {
        [restore_last_btn setEnabled:NO];
    }
}

- (UIImage *)snapshot {
    if (![self isAutograph]) {
        
        return nil;
    }
    
    if (menu_view) {
        [self setMenuHidden:YES];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (menu_view) {
        [self setMenuHidden:NO];
    }
    
    //添加logo用不到
    UIImage *logo = [UIImage imageNamed:SYS_LOGO_IMAGE_NAME];
    CGRect logoRect = CGRectMake(50, 0, self.frame.size.width-100, 0);
    logoRect.size.height = logoRect.size.width/logo.size.width * logo.size.height;
    logoRect.origin.y = (self.frame.size.height-logoRect.size.height)/2;
    
    image = [self addImageLogo:image logo:logo logoRect:logoRect label:nil];
    
    return image;
}


//图片加水印
-(UIImage*)addImageLogo:(UIImage*)img logo:(UIImage*)logo logoRect:(CGRect)logoRect label:(UILabel*)label
{
    if (!img) {
        return img;
    }
    
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    
    if (label) {
        NSString *text = label.text;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = label.textAlignment;
        //文字的属性
        NSDictionary *dic = @{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:label.textColor};
        //将文字绘制上去
        [text drawInRect:label.frame withAttributes:dic];
    }
    
    if (logo) {
        //四个参数为水印图片的位置
        [logo drawInRect:logoRect];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

#pragma mark - draw
- (BOOL)isAutograph {
    if (_pathArray.count > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();  //创建一块画布
    
    for (MyDrawInfo *drawInfo in _pathArray) {
        CGContextAddPath(context, drawInfo.path.CGPath);
        [drawInfo.color set];  //设置线的颜色
        CGContextSetLineWidth(context, drawInfo.width);//设置线的宽度
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (path) {
        CGContextAddPath(context, path.CGPath);
        [line_color set];  //设置线的颜色
        CGContextSetLineWidth(context, line_width);//设置线的宽度
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}


- (void)chooseThickness:(id)sender {
    if (slider) {
        [slider removeFromSuperview];
        slider = nil;
        return;
    }
    if (colorPicker) {
        [colorPicker removeFromSuperview];
        colorPicker = nil;
        
        [huePicker removeFromSuperview];
        huePicker = nil;
    }
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(20, self.frame.size.height-70, self.frame.size.width-40, 27)];
    [slider setMaximumValue:24];
    [slider setMinimumValue:1];
    [slider setEnabled:YES];
    [slider setUserInteractionEnabled:YES];
    [slider setValue:line_width animated:NO];
    [slider addTarget:self action:@selector(sliderChoose) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
}

- (void)sliderChoose {
    line_width = [[NSString stringWithFormat:@"%.1f",slider.value] floatValue];
    
    [thickness_btn setTitle:[NSString stringWithFormat:@"笔粗:%.1f",line_width] forState:UIControlStateNormal];
}

- (void)chooseColor:(id)sender {
    if (colorPicker) {
        [colorPicker removeFromSuperview];
        colorPicker = nil;
        
        [huePicker removeFromSuperview];
        huePicker = nil;
        
        return;
    }
    if (slider) {
        [slider removeFromSuperview];
        slider = nil;
    }
    
    HSBType hsb = [line_color HSB];
    
    huePicker = [[ILHuePickerView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-80, self.frame.size.width-40, 40)];
    huePicker.delegate = self;
    huePicker.hue = hsb.hue;
    [self addSubview:huePicker];
    colorPicker = [[ILSaturationBrightnessPickerView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-250, self.frame.size.width-40, 160)];
    colorPicker.delegate = self;
    colorPicker.hue = hsb.hue;
    colorPicker.saturation = hsb.saturation;
    colorPicker.brightness = hsb.brightness;
    [self addSubview:colorPicker];
}

-(void)huePicked:(float)hue picker:(ILHuePickerView *)picker {
    colorPicker.hue = hue;
    
    line_color = colorPicker.color;
    [color_btn setBackgroundColor:line_color];
}

-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker {
    line_color = newColor;
    [color_btn setBackgroundColor:line_color];
}

- (void)clearAll {
    if (_pathArray && _pathArray.count > 0) {
        [_pathArray removeAllObjects];
        if (remove_all_array && remove_all_array.count > 0) {
            [remove_all_array removeAllObjects];
        }
        if (remove_pathArray && remove_pathArray.count > 0) {
            [remove_pathArray removeAllObjects];
        }
        
        [self changeMenuEnable];
        
        [self setNeedsDisplay];
    }
}

- (void)removeAll {
    if (_pathArray && _pathArray.count > 0) {
        [remove_all_array addObjectsFromArray:_pathArray];
        [_pathArray removeAllObjects];
        [self setNeedsDisplay];
        
        [self changeMenuEnable];
    }
}

- (void)removeLast {
    if (_pathArray && _pathArray.count > 0) {
        [remove_pathArray addObject:[_pathArray lastObject]];
        [_pathArray removeLastObject];
        [self setNeedsDisplay];
        
        [self changeMenuEnable];
    }
}

- (void)restoreLast {
    if (remove_all_array && remove_all_array.count > 0) {
        [_pathArray addObjectsFromArray:remove_all_array];
        [remove_all_array removeAllObjects];
        [self setNeedsDisplay];
        
        [self changeMenuEnable];
        return;
    }
    
    if (remove_pathArray && remove_pathArray.count > 0) {
        [_pathArray addObject:[remove_pathArray lastObject]];
        [remove_pathArray removeLastObject];
        [self setNeedsDisplay];
        
        [self changeMenuEnable];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (colorPicker) {
        [colorPicker removeFromSuperview];
        colorPicker = nil;
        
        [huePicker removeFromSuperview];
        huePicker = nil;
    }
    if (slider) {
        [slider removeFromSuperview];
        slider = nil;
    }
    
    UITouch *touch = [touches anyObject];
    previousPoint = [touch locationInView:self];
    path = [UIBezierPath bezierPath];
    [path moveToPoint:previousPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGPoint midPoint = midpoint(previousPoint, location);
    [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    previousPoint = [touch locationInView:self];
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGPoint midPoint = midpoint(previousPoint, location);
    [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    previousPoint = [touch locationInView:self];
    
    MyDrawInfo *myDrawInfo = [MyDrawInfo drawInfoWithColor:line_color path:path width:line_width];
    [_pathArray addObject:myDrawInfo];
    
    path = nil;
    
    if (remove_pathArray) {
        [remove_pathArray removeAllObjects];
    }
    if (remove_all_array) {
        [remove_all_array removeAllObjects];
    }
    
    [self changeMenuEnable];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGPoint midPoint = midpoint(previousPoint, location);
    [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    previousPoint = [touch locationInView:self];
    
    MyDrawInfo *myDrawInfo = [MyDrawInfo drawInfoWithColor:line_color path:path width:line_width];
    [_pathArray addObject:myDrawInfo];
    
    path = nil;
    
    if (remove_pathArray) {
        [remove_pathArray removeAllObjects];
    }
    if (remove_all_array) {
        [remove_all_array removeAllObjects];
    }
    
    CGPathRelease(path.CGPath);
    
    [self changeMenuEnable];
    
    [self setNeedsDisplay];
}

@end
