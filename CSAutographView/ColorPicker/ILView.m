//
//  ILView.m
//
//  Created by Jon Gilkison on 7/30/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#import "ILView.h"

@implementation ILView

#pragma mark - Initialization/Deallocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    
}


@end
