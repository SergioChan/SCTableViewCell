//
//  SCTableViewCell.m
//  SCTableView
//
//  Created by chen Yuheng on 15/9/13.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "SCTableViewCell.h"
#import <objc/runtime.h>

@implementation SCTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.touchBeganPointX = 0.0f;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count == 1)
    {
        for(UITouch *touch in touches)
        {
            if(touch.phase != UITouchPhaseBegan)
            {
                [super touchesBegan:touches withEvent:event];
                return;
            }
            else
            {
                UIView *mainTableView = self.superview.superview;
                if([mainTableView isKindOfClass:[UITableView class]])
                {
                    self.touchBeganPointX = [touch locationInView:mainTableView].x;
                }
                [super touchesBegan:touches withEvent:event];
                return;
            }
        }
    }

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITableView *mainTableView = (UITableView *)self.superview.superview;
    if(touches.count == 1)
    {
        for(UITouch *touch in touches)
        {
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                mainTableView.scrollEnabled = YES;
                [super touchesMoved:touches withEvent:event];
                return;
            }
            else if(touch.phase == UITouchPhaseMoved)
            {
                mainTableView.scrollEnabled = NO;
                if([mainTableView isKindOfClass:[UITableView class]])
                {
                    CGFloat CurrentXIndex = [touch locationInView:mainTableView].x;
                    CGFloat PreviousXIndex = [touch previousLocationInView:mainTableView].x;
                    NSLog(@"--- (%f,%f) --- %f",PreviousXIndex,CurrentXIndex,self.touchBeganPointX - CurrentXIndex);
                    CGFloat delta = self.touchBeganPointX - CurrentXIndex;
                    if(delta > 0)
                    {
                        // 位移量超过0像素才移动，这是保证只有右边的区域会出现
                        [UIView animateWithDuration:0.2f animations:^{
                            self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                        }];
                    }
                }
            }
            else
            {
                NSLog(@"phase:%ld",touch.phase);
                [super touchesMoved:touches withEvent:event];
            }
        }
    }
    else
    {
        [super touchesMoved:touches withEvent:event];
        return;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITableView *mainTableView = (UITableView *)self.superview.superview;
    if(touches.count == 1)
    {
        mainTableView.scrollEnabled = YES;
        for(UITouch *touch in touches)
        {
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                NSLog(@"end!");
                CGFloat CurrentXIndex = [touch locationInView:mainTableView].x;
                if(CurrentXIndex>ScreenWidth/3.0f)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(- ScreenWidth/2.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                    }];
                }
            }
        }
        [super touchesEnded:touches withEvent:event];
        return;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITableView *mainTableView = (UITableView *)self.superview.superview;
    if(touches.count == 1)
    {
        mainTableView.scrollEnabled = YES;
        for(UITouch *touch in touches)
        {
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                NSLog(@"cancelled!");
                CGFloat CurrentXIndex = [touch locationInView:mainTableView].x;
                if(CurrentXIndex>ScreenWidth/2.0f)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(- ScreenWidth/2.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                    }];
                }
            }
        }
        [super touchesCancelled:touches withEvent:event];
        return;
    }
}

- (void)test
{
    NSLog(@"*************");
}

@end
