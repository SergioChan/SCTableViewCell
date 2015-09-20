//
//  SCTableViewCell.m
//  SCTableView
//
//  Created by chen Yuheng on 15/9/13.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "SCTableViewCell.h"

#define INDEX_X_FOR_DELETING 50.0f

@interface SCTableViewCell()
{
    BOOL _isMoving;
    BOOL _hasMoved;
}
@property (nonatomic) SCTableViewCellStyle style;

@property (nonatomic, strong) NSMutableArray *rightActionButtons;
@property (nonatomic, strong) NSMutableArray *leftActionButtons;

@property (nonatomic) CGFloat touchBeganPointX;
@property (nonatomic) CGFloat buttonWidth;

// temporarily using
@property (nonatomic, strong) UIButton *actionButton_1;
@property (nonatomic, strong) UIButton *actionButton_2;
@property (nonatomic, strong) UIButton *actionButton_3;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SCTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView withSCStyle:(SCTableViewCellStyle)sc_style
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.style = sc_style;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.touchBeganPointX = 0.0f;
        self.dragAnimationDuration = 0.2f;
        self.resetAnimationDuration = 0.4f;
        self.buttonWidth = ScreenWidth / 6.0f;
        self.tableView = tableView;
        _isMoving = NO;
        _hasMoved = NO;
        assert([self.tableView isKindOfClass:[UITableView class]]);
        
        self.actionButton_1 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height)];
        _actionButton_1.backgroundColor = [UIColor lightGrayColor];
        _actionButton_1.tag = 0;
        [_actionButton_1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton_1 setTitle:@"更多" forState:UIControlStateNormal];
        _actionButton_1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _actionButton_1.contentEdgeInsets = UIEdgeInsetsMake(0,15,0,0);
        
        self.actionButton_2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height)];
        _actionButton_2.backgroundColor = [UIColor orangeColor];
        _actionButton_2.tag = 1;
        [_actionButton_2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton_2 setTitle:@"旗标" forState:UIControlStateNormal];
        _actionButton_2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _actionButton_2.contentEdgeInsets = UIEdgeInsetsMake(0,15,0,0);
        
        self.actionButton_3 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height)];
        _actionButton_3.backgroundColor = [UIColor redColor];
        _actionButton_3.tag = 2;
        [_actionButton_3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton_3 setTitle:@"删除" forState:UIControlStateNormal];
        _actionButton_3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _actionButton_3.contentEdgeInsets = UIEdgeInsetsMake(0,15,0,0);
        
        [self addSubview:_actionButton_1];
        [self addSubview:_actionButton_2];
        [self addSubview:_actionButton_3];
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
                return;
            }
            else
            {
                NSLog(@"begin!");
                if(self.contentView.left == 0.0f)
                {
                    self.touchBeganPointX = [touch locationInView:self.tableView].x;
                }
                _isMoving = YES;
            }
        }
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count == 1)
    {
        for(UITouch *touch in touches)
        {
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                self.tableView.scrollEnabled = YES;
                [super touchesMoved:touches withEvent:event];
                return;
            }
            else if(touch.phase == UITouchPhaseMoved)
            {
                self.tableView.scrollEnabled = NO;
                _hasMoved = YES;
                CGFloat CurrentXIndex = [touch locationInView:self.tableView].x;
                CGFloat PreviousXIndex = [touch previousLocationInView:self.tableView].x;
                NSLog(@"--- (%f,%f) --- %f",PreviousXIndex,CurrentXIndex,self.touchBeganPointX - CurrentXIndex);
                CGFloat delta = self.touchBeganPointX - CurrentXIndex;
                if(delta > 0)
                {
                    if(delta > ScreenWidth / 2.0f)
                    {
                        if(CurrentXIndex < INDEX_X_FOR_DELETING)
                        {
                            // 最后一个button需要变宽度了
                            if(delta > ScreenWidth / 2.0f)
                            {
                                CGFloat t_delta = (delta - (ScreenWidth / 2.0f))/ 3.0f;
                                [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                                    self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                                    self.actionButton_1.frame = CGRectMake(ScreenWidth - delta, _actionButton_1.top, self.buttonWidth + t_delta, _actionButton_1.height);
                                    self.actionButton_2.frame = CGRectMake(ScreenWidth - delta * 2.0f/3.0f , _actionButton_2.top, self.buttonWidth + t_delta, _actionButton_2.height);
                                    self.actionButton_3.frame = CGRectMake(ScreenWidth - delta, _actionButton_3.top,(self.buttonWidth + t_delta ) * 3.0f, _actionButton_3.height);
                                }];
                            }
                            else
                            {
                                // 位移量超过0像素才移动，这是保证只有右边的区域会出现
                                [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                                    self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                                    self.actionButton_1.frame = CGRectMake(ScreenWidth - delta, _actionButton_1.top, self.buttonWidth , _actionButton_1.height);
                                    self.actionButton_2.frame = CGRectMake(ScreenWidth - delta * 2.0f/3.0f, _actionButton_2.top, self.buttonWidth , _actionButton_2.height);
                                    self.actionButton_3.frame = CGRectMake(ScreenWidth - delta, _actionButton_3.top,self.buttonWidth * 3.0f, _actionButton_3.height);
                                }];
                            }
                        }
                        else
                        {
                            CGFloat t_delta = (delta - (ScreenWidth / 2.0f))/ 3.0f;
                            [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                                self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                                self.actionButton_1.frame = CGRectMake(ScreenWidth - delta, _actionButton_1.top, self.buttonWidth + t_delta, _actionButton_1.height);
                                self.actionButton_2.frame = CGRectMake(ScreenWidth - delta * 2.0f/3.0f , _actionButton_2.top, self.buttonWidth + t_delta, _actionButton_2.height);
                                self.actionButton_3.frame = CGRectMake(ScreenWidth - delta / 3.0f, _actionButton_3.top, self.buttonWidth +t_delta, _actionButton_3.height);
                            }];
                        }
                    }
                    else
                    {
                        // 位移量超过0像素才移动，这是保证只有右边的区域会出现
                        [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                            self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                            self.actionButton_1.frame = CGRectMake(ScreenWidth - delta, _actionButton_1.top, self.buttonWidth , _actionButton_1.height);
                            self.actionButton_2.frame = CGRectMake(ScreenWidth - delta * 2.0f/3.0f, _actionButton_2.top, self.buttonWidth , _actionButton_2.height);
                            self.actionButton_3.frame = CGRectMake(ScreenWidth - delta / 3.0f, _actionButton_3.top, self.buttonWidth , _actionButton_3.height);
                        }];
                    }
                }
            }
            else
            {
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
    if(touches.count == 1)
    {
        self.tableView.scrollEnabled = YES;
        for(UITouch *touch in touches)
        {
            if(touch.tapCount > 1)
            {
                //双击事件可以由其他recognizer捕获到
                [super touchesEnded:touches withEvent:event];
                return;
            }
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                CGFloat CurrentXIndex = [touch locationInView:self.tableView].x;
                CGFloat PreviousXIndex = [touch previousLocationInView:self.tableView].x;
                NSLog(@"end ! --(%f)-- %f",CurrentXIndex, PreviousXIndex - CurrentXIndex);
                
                // 判断特殊的删除情况
                if(self.actionButton_3.width > self.buttonWidth * 3.0f)
                {
                    if(self.deleteRowHandler)
                    {
                        self.deleteRowHandler();
                    }
                    return;
                }
                
                if(fabs(PreviousXIndex - CurrentXIndex) <= 3.0f)
                {
                    // 并没有怎么移动
                    if(self.contentView.left < - ScreenWidth / 2.0f)
                    {
                        // 需要还原到显示的位置
                        if(!_hasMoved)
                        {
                            return;
                        }
                        [self resetButtonsToDisplayPosition];
                    }
                    else
                    {
                        // 需要还原到初始位置
                        [self resetButtonsToOriginPosition];
                    }
                }
                else
                {
                    if(CurrentXIndex > ScreenWidth / 2.0f)
                    {
                        // 需要还原到初始位置
                        [self resetButtonsToOriginPosition];
                    }
                    else
                    {
                        // 需要还原到显示的位置
                        if(!_hasMoved)
                        {
                            return;
                        }
                        [self resetButtonsToDisplayPosition];
                    }
                }
            }
        }
    }
    else
    {
        [super touchesEnded:touches withEvent:event];
        return;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count == 1)
    {
        self.tableView.scrollEnabled = YES;
        for(UITouch *touch in touches)
        {
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                NSLog(@"cancelled!");
                CGFloat CurrentXIndex = [touch locationInView:self.tableView].x;
                if(CurrentXIndex > ScreenWidth/2.0f)
                {
                    [self resetButtonsToOriginPosition];
                }
                else
                {
                    [self resetButtonsToDisplayPosition];
                }
            }
        }
    }
    else
    {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
}

- (void)resetButtonsToOriginPosition
{
    [UIView animateWithDuration:self.resetAnimationDuration animations:^{
        self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
        self.actionButton_1.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
        self.actionButton_2.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
        self.actionButton_3.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
    } completion:^(BOOL finished) {
        _isMoving = NO;
        _hasMoved = NO;
    }];
}

- (void)resetButtonsToDisplayPosition
{
    [UIView animateWithDuration:self.resetAnimationDuration animations:^{
        self.contentView.frame = CGRectMake(- ScreenWidth/2.0f, self.contentView.top, self.contentView.width, self.contentView.height);
        self.actionButton_1.frame = CGRectMake(ScreenWidth / 2.0f, _actionButton_1.top, self.buttonWidth, _actionButton_1.height);
        self.actionButton_2.frame = CGRectMake(ScreenWidth * 2.0f / 3.0f, _actionButton_2.top, self.buttonWidth, _actionButton_2.height);
        self.actionButton_3.frame = CGRectMake(ScreenWidth * 5.0f / 6.0f, _actionButton_3.top, self.buttonWidth, _actionButton_2.height);
    } completion:^(BOOL finished) {
        _isMoving = NO;
        _hasMoved = NO;
    }];
}
@end
