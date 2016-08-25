//
//  CSAutographDrawView.h
//  CSAutograph
//
//  Created by e3mo on 16/5/10.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILSaturationBrightnessPickerView.h"
#import "ILHuePickerView.h"

@interface CSAutographDrawView : UIView <ILSaturationBrightnessPickerViewDelegate,ILHuePickerViewDelegate> {
    UIColor *line_color;
    float line_width;
    
    UIBezierPath *path;
    CGPoint previousPoint;
    
    NSMutableArray *remove_all_array;
    NSMutableArray *remove_pathArray;
    
    UIView *menu_view;
    UIButton *clear_all_btn;
    UIButton *clear_last_btn;
    UIButton *restore_last_btn;
    UIButton *color_btn;
    UIButton *thickness_btn;
    
    UISlider *slider;
    
    ILSaturationBrightnessPickerView *colorPicker;
    ILHuePickerView *huePicker;
}
@property (strong, nonatomic) NSMutableArray *pathArray;


- (void)setIsShowMenu:(BOOL)isShow;
- (void)setMenuHidden:(BOOL)hidden;

- (BOOL)isAutograph;

- (UIImage*)snapshot;

- (void)clearAll;
- (void)removeAll;
- (void)removeLast;
- (void)restoreLast;

@end
