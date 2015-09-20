//
//  SCTableViewCell.m
//  SCTableView
//
//  Created by chen Yuheng on 15/9/13.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "SCTableViewCell.h"
#import <objc/runtime.h>

@interface SCTableViewCell()
{
    BOOL _isMoving;
}
@end

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
        self.buttonWidth = ScreenWidth / 6.0f;
        self.actionButton_1 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height)];
        _actionButton_1.backgroundColor = [UIColor redColor];
        _actionButton_1.tag = 0;
        [_actionButton_1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton_1 setTitle:@"Test1" forState:UIControlStateNormal];
        
        self.actionButton_2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height)];
        _actionButton_2.backgroundColor = [UIColor orangeColor];
        _actionButton_2.tag = 1;
        [_actionButton_2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton_2 setTitle:@"Test1" forState:UIControlStateNormal];
        
        self.actionButton_3 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height)];
        _actionButton_3.backgroundColor = [UIColor blueColor];
        _actionButton_3.tag = 2;
        [_actionButton_3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton_3 setTitle:@"Test1" forState:UIControlStateNormal];
        
        [self addSubview:_actionButton_1];
        [self addSubview:_actionButton_2];
        [self addSubview:_actionButton_3];
        _isMoving = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)buttonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    NSLog(@"pressed at index : %ld",index);
}

- (void)layoutSubviews
{
    if(_isMoving)
    {
        return;
    }
    [super layoutSubviews];
    //self.contentView.frame = CGRectMake(0.0f, 0.0f, self.contentView.width, self.contentView.height);
    _actionButton_1.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
    _actionButton_2.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
    _actionButton_3.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count == 1)
    {
        for(UITouch *touch in touches)
        {
            if(touch.phase != UITouchPhaseBegan)
            {
                //[super touchesBegan:touches withEvent:event];
                return;
            }
            else
            {
                NSLog(@"begin!");
                UIView *mainTableView = self.superview.superview;
                if([mainTableView isKindOfClass:[UITableView class]])
                {
                    self.touchBeganPointX = [touch locationInView:mainTableView].x;
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                        self.actionButton_1.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        self.actionButton_2.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        self.actionButton_3.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                    } completion:^(BOOL finished) {
                        _isMoving = YES;
                    }];
                }
            }
        }
    }

    //[super touchesBegan:touches withEvent:event];
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
                        if(delta > ScreenWidth / 2.0f)
                        {
                            CGFloat t_delta = (delta - (ScreenWidth / 2.0f))/ 3.0f;
                            [UIView animateWithDuration:0.2f animations:^{
                                self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                                self.actionButton_1.frame = CGRectMake(ScreenWidth - delta, _actionButton_1.top, self.buttonWidth + t_delta, _actionButton_1.height);
                                self.actionButton_2.frame = CGRectMake(ScreenWidth - delta * 2.0f/3.0f , _actionButton_2.top, self.buttonWidth + t_delta, _actionButton_2.height);
                                self.actionButton_3.frame = CGRectMake(ScreenWidth - delta / 3.0f, _actionButton_3.top, self.buttonWidth +t_delta, _actionButton_3.height);
                            }];
                        }
                        else
                        {
                            // 位移量超过0像素才移动，这是保证只有右边的区域会出现
                            [UIView animateWithDuration:0.2f animations:^{
                                self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                                self.actionButton_1.frame = CGRectMake(ScreenWidth - delta, _actionButton_1.top, self.buttonWidth , _actionButton_1.height);
                                self.actionButton_2.frame = CGRectMake(ScreenWidth - delta * 2.0f/3.0f, _actionButton_2.top, self.buttonWidth , _actionButton_2.height);
                                self.actionButton_3.frame = CGRectMake(ScreenWidth - delta / 3.0f, _actionButton_3.top, self.buttonWidth , _actionButton_3.height);
                            }];
                        }
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
                CGFloat CurrentXIndex = [touch locationInView:mainTableView].x;
                NSLog(@"end!");
                if(CurrentXIndex>ScreenWidth/3.0f)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                        self.actionButton_1.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        self.actionButton_2.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        self.actionButton_3.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                    } completion:^(BOOL finished) {
                        if(finished)
                        {
                            // 重置动画完成后重置界面状态
                            self.touchBeganPointX = 0.0f;
                           _isMoving = NO;
                        }
                    }];
                }
                else
                {
                    if(_isMoving)
                    {
                        [UIView animateWithDuration:0.2f animations:^{
                            self.contentView.frame = CGRectMake(- ScreenWidth/2.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                            self.actionButton_1.frame = CGRectMake(ScreenWidth / 2.0f, _actionButton_1.top, self.buttonWidth, _actionButton_1.height);
                            self.actionButton_2.frame = CGRectMake(ScreenWidth * 2.0f / 3.0f, _actionButton_2.top, self.buttonWidth, _actionButton_2.height);
                            self.actionButton_3.frame = CGRectMake(ScreenWidth * 5.0f / 6.0f, _actionButton_3.top, self.buttonWidth, _actionButton_3.height);
                        } completion:^(BOOL finished) {
                            if(finished)
                            {
                                self.touchBeganPointX = 0.0f;
                                _isMoving = NO;
                            }
                        }];
                    }
                    else
                    {
                        [UIView animateWithDuration:0.2f animations:^{
                            self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                            self.actionButton_1.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                            self.actionButton_2.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                            self.actionButton_3.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        } completion:^(BOOL finished) {
                            if(finished)
                            {
                                // 重置动画完成后重置界面状态
                                self.touchBeganPointX = 0.0f;
                                _isMoving = NO;
                            }
                        }];
                    }
                }
            }
        }
        //[super touchesEnded:touches withEvent:event];
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
                if(CurrentXIndex>ScreenWidth/3.0f)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                        self.actionButton_1.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        self.actionButton_2.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                        self.actionButton_3.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                    } completion:^(BOOL finished) {
                        if(finished)
                        {
                            self.touchBeganPointX = 0.0f;
                            _isMoving = NO;
                        }
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.contentView.frame = CGRectMake(- ScreenWidth/2.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                        self.actionButton_1.frame = CGRectMake(ScreenWidth / 2.0f, _actionButton_1.top, self.buttonWidth, _actionButton_1.height);
                        self.actionButton_2.frame = CGRectMake(ScreenWidth * 2.0f / 3.0f, _actionButton_2.top, self.buttonWidth, _actionButton_2.height);
                        self.actionButton_3.frame = CGRectMake(ScreenWidth * 5.0f / 6.0f, _actionButton_3.top, self.buttonWidth, _actionButton_2.height);
                    } completion:^(BOOL finished) {
                        if(finished)
                        {
                            self.touchBeganPointX = 0.0f;
                            _isMoving = NO;
                        }
                    }];
                }
            }
        }
        //[super touchesCancelled:touches withEvent:event];
        return;
    }
}

- (void)test
{
    NSLog(@"*************");
}

@end
