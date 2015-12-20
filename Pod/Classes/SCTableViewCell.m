//
//  SCTableViewCell.m
//  SCTableView
//
//  Created by chen Yuheng on 15/9/13.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "SCTableViewCell.h"

#define INDEX_X_FOR_DELETING 50.0f
#define SCNotificationExitEditing @"SCNotificationExitEditing"

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

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation SCTableViewCell

/**
 *  滑动的时候取消所有cell的编辑状态
 */
+ (void)endEditing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SCNotificationExitEditing object:nil userInfo:nil];
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.touchBeganPointX = 0.0f;
        self.dragAnimationDuration = 0.2f;
        self.resetAnimationDuration = 0.4f;
        self.buttonWidth = ScreenWidth / 6.0f;
        self.dragAcceleration = 1.14f;
        self.isEditing = NO;
        self.tableView = tableView;
        _isMoving = NO;
        _hasMoved = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExitEditing:) name:SCNotificationExitEditing object:nil];
        assert([self.tableView isKindOfClass:[UITableView class]]);
    }
    return self;
}

- (void)layoutSubviews
{
    if(_isMoving)
    {
        return;
    }
    [super layoutSubviews];
    [self getSCStyle];
    [self getActionsArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 *  接收到别的cell的通知来取消自己的编辑状态
 *
 *  @param sender NSNotification
 */
- (void)ExitEditing:(id)sender
{
    if([(NSNotification *)sender object] != self)
    {
        if(self.isEditing && !_isMoving)
        {
            [self resetButtonsToOriginPosition];
        }
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Button Actions
- (void)rightButtonPressed:(id)sender
{
    SCTableViewCellRowActionButton *btn = (SCTableViewCellRowActionButton *)sender;
    [self actionTrigger:YES button:btn];
}

- (void)leftButtonPressed:(id)sender
{
    SCTableViewCellRowActionButton *btn = (SCTableViewCellRowActionButton *)sender;
    [self actionTrigger:NO button:btn];
}

/**
 *  触发事件的最终汇总出口
 *
 *  @param isRight 是否是右边滑动菜单
 */
- (void)actionTrigger:(BOOL)isRight button:(SCTableViewCellRowActionButton *)btn
{
    self.indexPath = [self.tableView indexPathForCell:self];
    
    if(isRight)
    {
        // 判断index是否是最后一个
        if(btn.actionCallBack)
        {
            btn.actionCallBack(self.indexPath);
        }
    }
    else
    {
        if(btn.actionCallBack)
        {
            btn.actionCallBack(self.indexPath);
        }
        [self resetButtonsToOriginPosition];
    }
}

#pragma mark - Main Touch processer
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
                switch (self.style) {
                    case SCTableViewCellStyleRight:
                    {
                        if(self.contentView.left == 0.0f)
                        {
                            self.touchBeganPointX = [touch locationInView:self.tableView].x;
                            //当开始编辑的时候，向其他cell发送取消编辑的通知
                            [[NSNotificationCenter defaultCenter] postNotificationName:SCNotificationExitEditing object:self userInfo:nil];
                        }
                        _isMoving = YES;
                    }
                        break;
                    case SCTableViewCellStyleLeft:
                    {
                        if(self.contentView.left == 0.0f)
                        {
                            self.touchBeganPointX = [touch locationInView:self.tableView].x;
                            //当开始编辑的时候，向其他cell发送取消编辑的通知
                            [[NSNotificationCenter defaultCenter] postNotificationName:SCNotificationExitEditing object:self userInfo:nil];
                        }
                        _isMoving = YES;
                    }
                        break;
                    case SCTableViewCellStyleBoth:
                    {
                        
                    }
                        break;
                    case SCTableViewCellStyleDefault:
                    {
                        [super touchesBegan:touches withEvent:event];
                    }
                        break;
                    default:
                        break;
                }
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
                switch (self.style) {
                    case SCTableViewCellStyleRight:
                    {
                        _hasMoved = YES;
                        _isEditing = YES;
                        CGFloat CurrentXIndex = [touch locationInView:self.tableView].x;
                        CGFloat CurrentYIndex = [touch locationInView:self.tableView].y;
                        NSLog(@"--- (%f,%f) --- %f",CurrentXIndex,CurrentYIndex,self.touchBeganPointX - CurrentXIndex);
                        CGFloat delta = (self.touchBeganPointX - CurrentXIndex) * self.dragAcceleration;
                        [self rightMenuAnimation:delta andCurrentIndexX:CurrentXIndex];
                    }
                        break;
                    case SCTableViewCellStyleLeft:
                    {
                        _hasMoved = YES;
                        _isEditing = YES;
                        CGFloat CurrentXIndex = [touch locationInView:self.tableView].x;
                        CGFloat CurrentYIndex = [touch locationInView:self.tableView].y;
                        NSLog(@"--- (%f,%f) --- %f",CurrentXIndex,CurrentYIndex,self.touchBeganPointX - CurrentXIndex);
                        CGFloat delta = (self.touchBeganPointX - CurrentXIndex) * self.dragAcceleration;
                        [self leftMenuAnimation:delta andCurrentIndexX:CurrentXIndex];
                    }
                        break;
                    case SCTableViewCellStyleBoth:
                    {
                        
                    }
                        break;
                    case SCTableViewCellStyleDefault:
                    {
                        [super touchesMoved:touches withEvent:event];
                    }
                    default:
                        break;
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
                NSLog(@"double tap!");
                [super touchesEnded:touches withEvent:event];
                return;
            }
            if(touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
            {
                CGFloat CurrentXIndex = [touch locationInView:self.tableView].x;
                CGFloat PreviousXIndex = [touch previousLocationInView:self.tableView].x;
                NSLog(@"end ! --(%f)-- %f",CurrentXIndex, PreviousXIndex - CurrentXIndex);
                switch (self.style) {
                    case SCTableViewCellStyleRight:
                    {
                        [self rightMenuAnimationEndpreviousIndex:PreviousXIndex currentIndex:CurrentXIndex];
                    }
                        break;
                    case SCTableViewCellStyleLeft:
                    {
                        [self leftMenuAnimationEndpreviousIndex:PreviousXIndex currentIndex:CurrentXIndex];
                    }
                        break;
                    case SCTableViewCellStyleBoth:
                    {
                        
                    }
                        break;
                    case SCTableViewCellStyleDefault:
                    {
                        if(fabs(PreviousXIndex - CurrentXIndex) <= 10.0f)
                        {
                            if(!_isEditing)
                            {
                                // 由于把整个手势的检测判断都覆盖了，这里需要把系统的didSelect也重新实现一下
                                self.indexPath = [self.tableView indexPathForCell:self];
                                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
                                return;
                            }
                        }
                    }
                    default:
                        break;
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
                switch (self.style) {
                    case SCTableViewCellStyleRight:
                    {
                        if(CurrentXIndex > ScreenWidth/2.0f)
                        {
                            [self resetButtonsToOriginPosition];
                        }
                        else
                        {
                            [self resetButtonsToDisplayPosition];
                        }
                    }
                        break;
                    case SCTableViewCellStyleLeft:
                    {
                        if(CurrentXIndex > ScreenWidth/3.0f)
                        {
                            [self resetButtonsToOriginPosition];
                        }
                        else
                        {
                            [self resetButtonsToDisplayPosition];
                        }
                    }
                        break;
                    case SCTableViewCellStyleBoth:
                    {
                        
                    }
                        break;
                    case SCTableViewCellStyleDefault:
                    {
                        [super touchesCancelled:touches withEvent:event];
                    }
                        break;
                    default:
                        break;
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

#pragma mark - Reset methods
/**
 *  将Action重置到原始区域，即不可见区域
 */
- (void)resetButtonsToOriginPosition
{
    switch (self.style) {
        case SCTableViewCellStyleRight:
        {
            [UIView animateWithDuration:self.resetAnimationDuration animations:^{
                self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                for(UIButton *button in self.rightActionButtons)
                {
                    button.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                }
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _hasMoved = NO;
                _isEditing = NO;
            }];
        }
            break;
        case SCTableViewCellStyleLeft:
        {
            [UIView animateWithDuration:self.resetAnimationDuration animations:^{
                self.contentView.frame = CGRectMake(0.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                for(UIButton *button in self.leftActionButtons)
                {
                    button.frame = CGRectMake(-self.buttonWidth, 0.0f, self.buttonWidth, self.height);
                }
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _hasMoved = NO;
                _isEditing = NO;
            }];
        }
            break;
        case SCTableViewCellStyleBoth:
        {
            
        }
            break;
        case SCTableViewCellStyleDefault:
        default:
            break;
    }
}

/**
 *  将Action重置到应该显示的区域，Both模式下可能需要引入当前编辑模式
 */
- (void)resetButtonsToDisplayPosition
{
    switch (self.style) {
        case SCTableViewCellStyleRight:
        {
            [UIView animateWithDuration:self.resetAnimationDuration animations:^{
                self.contentView.frame = CGRectMake(- ScreenWidth/2.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                CGFloat t_start = ScreenWidth / 2.0f;
                for(UIButton *button in self.rightActionButtons)
                {
                    button.frame = CGRectMake(t_start, 0.0f, self.buttonWidth, self.height);
                    t_start += self.buttonWidth;
                }
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _hasMoved = NO;
                _isEditing = YES;
            }];
        }
            break;
        case SCTableViewCellStyleLeft:
        {
            [UIView animateWithDuration:self.resetAnimationDuration animations:^{
                self.contentView.frame = CGRectMake(ScreenWidth/3.0f, self.contentView.top, self.contentView.width, self.contentView.height);
                CGFloat t_start = self.buttonWidth * (self.leftActionButtons.count - 1);
                for(UIButton *button in self.leftActionButtons)
                {
                    button.frame = CGRectMake(t_start, 0.0f, self.buttonWidth, self.height);
                    t_start -= self.buttonWidth;
                }
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _hasMoved = NO;
                _isEditing = YES;
            }];
        }
            break;
        case SCTableViewCellStyleBoth:
        {
            
        }
            break;
        case SCTableViewCellStyleDefault:
        default:
            break;
    }
}

#pragma mark - Delegate method to get data
- (void)getActionsArray
{
    self.indexPath = [self.tableView indexPathForCell:self];
    switch (self.style) {
        case SCTableViewCellStyleRight:
        {
            if([self.delegate respondsToSelector:@selector(SCTableView:rightEditActionsForRowAtIndexPath:)])
            {
                NSLog(@"get Actions!");
                self.rightActionButtons = [[self.delegate SCTableView:self.tableView rightEditActionsForRowAtIndexPath:self.indexPath] mutableCopy];
                
                // 右侧由于滑动空间小，个数不要超过三个
                assert(self.rightActionButtons.count < 4);
                
                self.buttonWidth = (self.width / 2.0f)/ self.rightActionButtons.count;
                
                for(UIButton *button in self.rightActionButtons)
                {
                    button.frame = CGRectMake(ScreenWidth, 0.0f, self.buttonWidth, self.height);
                    [button addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                }
            }
        }
            break;
        case SCTableViewCellStyleLeft:
        {
            if([self.delegate respondsToSelector:@selector(SCTableView:leftEditActionsForRowAtIndexPath:)])
            {
                self.leftActionButtons = [[self.delegate SCTableView:self.tableView leftEditActionsForRowAtIndexPath:self.indexPath] mutableCopy];
                
                // 左侧由于滑动空间小，个数不要超过一个
                assert(self.leftActionButtons.count < 2);
                
                self.buttonWidth = (self.width / 3.0f)/ self.leftActionButtons.count;
                
                for(UIButton *button in self.leftActionButtons)
                {
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    button.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,10);
                    button.frame = CGRectMake(- self.buttonWidth, 0.0f, self.buttonWidth, self.height);
                    [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                }
            }
        }
            break;
        case SCTableViewCellStyleBoth:
        {
            if([self.delegate respondsToSelector:@selector(SCTableView:rightEditActionsForRowAtIndexPath:)])
            {
                self.rightActionButtons = [[self.delegate SCTableView:self.tableView rightEditActionsForRowAtIndexPath:self.indexPath] mutableCopy];
            }
            if([self.delegate respondsToSelector:@selector(SCTableView:leftEditActionsForRowAtIndexPath:)])
            {
                self.leftActionButtons = [[self.delegate SCTableView:self.tableView leftEditActionsForRowAtIndexPath:self.indexPath] mutableCopy];
            }
        }
            break;
        case SCTableViewCellStyleDefault:
        default:
            break;
    }
}

- (void)getSCStyle
{
    self.indexPath = [self.tableView indexPathForCell:self];
    if([self.delegate respondsToSelector:@selector(SCTableView:editStyleForRowAtIndexPath:)])
    {
        self.style = [self.delegate SCTableView:self.tableView editStyleForRowAtIndexPath:self.indexPath];
    }
}

#pragma mark - Dragging processing methods
/**
 *  右侧菜单滑动显示的过程代码
 *
 *  @param delta
 *  @param CurrentXIndex
 */
- (void)rightMenuAnimation:(CGFloat)delta andCurrentIndexX:(CGFloat)CurrentXIndex
{
    if(delta > 0)
    {
        if(delta > ScreenWidth / 2.0f)
        {
            if(CurrentXIndex < INDEX_X_FOR_DELETING)
            {
                // 最后一个button需要变宽度了
                if(delta > ScreenWidth / 2.0f)
                {
                    CGFloat t_delta = (delta - (ScreenWidth / 2.0f))/ self.rightActionButtons.count;
                    [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                        self.contentView.frame = CGRectMake(CurrentXIndex-self.width, self.contentView.top, self.contentView.width, self.contentView.height);
                        
                        CGFloat p_delta = delta;
                        for(NSInteger i=0;i<self.rightActionButtons.count-1;i++)
                        {
                            UIButton *button = [self.rightActionButtons objectAtIndex:i];
                            button.frame = CGRectMake(self.width - p_delta, 0.0f, self.buttonWidth + t_delta, self.height);
                            p_delta -= delta / self.rightActionButtons.count;
                        }
                        
                        CGFloat t_x = CurrentXIndex;
                        if([(UIButton *)[self.rightActionButtons objectAtIndex:0] left] < CurrentXIndex)
                        {
                            t_x = [(UIButton *)[self.rightActionButtons objectAtIndex:0] left];
                        }
                        UIButton *lastOne = [self.rightActionButtons lastObject];
                        lastOne.frame = CGRectMake(t_x, 0.0f, self.width - t_x, self.height);
                    }];
                }
                else
                {
                    // 位移量超过0像素才移动，这是保证只有右边的区域会出现
                    [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                        self.contentView.frame = CGRectMake(CurrentXIndex-self.width, self.contentView.top, self.contentView.width, self.contentView.height);
                        
                        CGFloat t_delta = delta;
                        for(NSInteger i=0;i<self.rightActionButtons.count-1;i++)
                        {
                            UIButton *button = [self.rightActionButtons objectAtIndex:i];
                            button.frame = CGRectMake(self.width - t_delta, 0.0f, self.buttonWidth, self.height);
                            t_delta -= delta / self.rightActionButtons.count;
                        }
                        CGFloat t_x = CurrentXIndex;
                        if([(UIButton *)[self.rightActionButtons objectAtIndex:0] left] < CurrentXIndex)
                        {
                            t_x = [(UIButton *)[self.rightActionButtons objectAtIndex:0] left];
                        }
                        UIButton *lastOne = [self.rightActionButtons lastObject];
                        lastOne.frame = CGRectMake(t_x, 0.0f,self.width - t_x, self.height);
                    }];
                }
            }
            else
            {
                CGFloat t_delta = (delta - (ScreenWidth / 2.0f))/ self.rightActionButtons.count;
                [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                    self.contentView.frame = CGRectMake(-delta, self.contentView.top, self.contentView.width, self.contentView.height);
                    
                    CGFloat p_delta = 0.0f;
                    for(UIButton *button in self.rightActionButtons)
                    {
                        p_delta = delta * (self.rightActionButtons.count - [self.rightActionButtons indexOfObject:button]) / self.rightActionButtons.count;
                        button.frame = CGRectMake(self.width - p_delta, 0.0f, self.buttonWidth + t_delta, self.height);
                    }
                }];
            }
        }
        else
        {
            // 位移量超过0像素才移动，这是保证只有右边的区域会出现
            [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                self.contentView.frame = CGRectMake(- delta, self.contentView.top, self.contentView.width, self.contentView.height);
                
                CGFloat t_delta = 0.0f;
                for(UIButton *button in self.rightActionButtons)
                {
                    t_delta = delta * (self.rightActionButtons.count - [self.rightActionButtons indexOfObject:button]) / self.rightActionButtons.count;
                    button.frame = CGRectMake(self.width - t_delta, 0.0f, self.buttonWidth, self.height);
                }
            }];
        }
    }
}

/**
 *  右侧菜单显示滑动结束
 *
 *  @param PreviousXIndex
 *  @param CurrentXIndex
 */
- (void)rightMenuAnimationEndpreviousIndex:(CGFloat)PreviousXIndex currentIndex:(CGFloat)CurrentXIndex
{
    // 判断特殊的删除情况
    if([(UIButton *)self.rightActionButtons.lastObject width] > self.buttonWidth * self.rightActionButtons.count)
    {
        [self actionTrigger:YES button:(SCTableViewCellRowActionButton *)self.rightActionButtons.lastObject];
        return;
    }
    
    if(fabs(PreviousXIndex - CurrentXIndex) <= 3.0f)
    {
        if(!_isEditing)
        {
            // 由于把整个手势的检测判断都覆盖了，这里需要把系统的didSelect也重新实现一下
            self.indexPath = [self.tableView indexPathForCell:self];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
            return;
        }
        
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

- (void)leftMenuAnimationEndpreviousIndex:(CGFloat)PreviousXIndex currentIndex:(CGFloat)CurrentXIndex
{
    // 判断特殊的删除情况
    if([(UIButton *)self.leftActionButtons.lastObject width] > self.buttonWidth * self.leftActionButtons.count)
    {
        [self actionTrigger:NO button:(SCTableViewCellRowActionButton *)self.leftActionButtons.lastObject];
        return;
    }
    
    if(fabs(PreviousXIndex - CurrentXIndex) <= 3.0f)
    {
        if(!_isEditing)
        {
            // 由于把整个手势的检测判断都覆盖了，这里需要把系统的didSelect也重新实现一下
            self.indexPath = [self.tableView indexPathForCell:self];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
            return;
        }
        
        // 并没有怎么移动
        if(self.contentView.left > ScreenWidth / 3.0f)
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
        if(CurrentXIndex < ScreenWidth / 3.0f)
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

- (void)leftMenuAnimation:(CGFloat)delta andCurrentIndexX:(CGFloat)CurrentXIndex
{
    if(delta < 0)
    {
        delta = - delta;
        if(delta > ScreenWidth / 3.0f)
        {
            if(CurrentXIndex > ScreenWidth / 2.0f)
            {
                // 最后一个button需要变宽度了
                if(delta > ScreenWidth / 2.0f)
                {
                    [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                        CGFloat t_x = CurrentXIndex;
                        self.contentView.frame = CGRectMake(t_x, self.contentView.top, self.contentView.width, self.contentView.height);
                        UIButton *lastOne = [self.leftActionButtons lastObject];
                        lastOne.frame = CGRectMake(0.0f, 0.0f, t_x, self.height);
                    }];
                }
                else
                {
                    // 位移量超过0像素才移动，这是保证只有右边的区域会出现
                    [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                        CGFloat t_x = CurrentXIndex;
                        self.contentView.frame = CGRectMake(t_x, self.contentView.top, self.contentView.width, self.contentView.height);
                        UIButton *lastOne = [self.leftActionButtons lastObject];
                        lastOne.frame = CGRectMake(0.0f, 0.0f,t_x, self.height);
                    }];
                }
            }
            else
            {
                CGFloat t_delta = (delta - (ScreenWidth / 3.0f))/ self.leftActionButtons.count;
                [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                    self.contentView.frame = CGRectMake(delta, self.contentView.top, self.contentView.width, self.contentView.height);
                    
                    for(UIButton *button in self.leftActionButtons)
                    {
                        NSInteger index = [self.leftActionButtons indexOfObject:button];
                        button.frame = CGRectMake((self.buttonWidth + t_delta) * (self.leftActionButtons.count - 1 -index), 0.0f, self.buttonWidth + t_delta, self.height);
                    }
                }];
            }
        }
        else
        {
            // 位移量超过0像素才移动，这是保证只有右边的区域会出现
            [UIView animateWithDuration:self.dragAnimationDuration animations:^{
                self.contentView.frame = CGRectMake(delta, self.contentView.top, self.contentView.width, self.contentView.height);
                
                CGFloat t_delta = 0.0f;
                for(UIButton *button in self.leftActionButtons)
                {
                    t_delta = delta * (self.leftActionButtons.count - [self.leftActionButtons indexOfObject:button]) / self.leftActionButtons.count;
                    button.frame = CGRectMake( - self.buttonWidth + t_delta, 0.0f, self.buttonWidth, self.height);
                }
            }];
        }
    }
}
@end
