//
//  SCTableViewCell.h
//  SCTableView
//
//  Created by chen Yuheng on 15/9/13.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCTableViewCellStyle) {
    SCTableViewCellStyleDefault = 0,    // default table view cell style, just like UITableViewCell
    SCTableViewCellStyleRight,  // table view cell with right button menu
    SCTableViewCellStyleLeft,   // table view cell with left button menu
    SCTableViewCellStyleBoth    // table view cell with both side button menu
};

@interface SCTableViewCell : UITableViewCell

/**
 *  滑动过程中的动画刷新间隔，减小这个值会加速滑动的动效，默认值是0.2s
 *  Duration of dragging animation, set it lower to increase the speed of dragging, default is 0.2s
 */
@property (nonatomic) CGFloat dragAnimationDuration;

/**
 *  重置动画的时长，设置的更大能够获得更好的用户体验，默认值是0.4s
 *  Duration of reset animation of buttons, set it higher to get better user experience, default is 0.4s
 */
@property (nonatomic) CGFloat resetAnimationDuration;

@property (nonatomic, copy) void (^deleteRowHandler)(void);

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView withSCStyle:(SCTableViewCellStyle)sc_style;
@end
