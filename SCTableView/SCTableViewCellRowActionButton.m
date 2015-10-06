//
//  SCTableViewCellRowActionButton.m
//  SCTableView
//
//  Created by chen Yuheng on 15/9/21.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "SCTableViewCellRowActionButton.h"

@implementation SCTableViewCellRowActionButton

- (id)initWithTitle:(NSString *)title color:(UIColor *)color withActionBlock:(CommintActionBlock)block
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = color;
        [self setTitle:title forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentEdgeInsets = UIEdgeInsetsMake(0,10,0,0);
        self.titleLabel.numberOfLines = 2;
        //self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.actionCallBack = block;
    }
    return self;
}

@end
