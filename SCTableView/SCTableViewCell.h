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
#import "SCTableViewCellRowActionButton.h"

typedef NS_ENUM(NSInteger, SCTableViewCellStyle) {
    SCTableViewCellStyleDefault = 0,    // default table view cell style, just like UITableViewCell
    SCTableViewCellStyleRight,  // table view cell with right button menu
    SCTableViewCellStyleLeft,   // table view cell with left button menu
    SCTableViewCellStyleBoth    // table view cell with both side button menu
};

@class SCTableViewCell;
@protocol SCTableViewCellDelegate <NSObject>

@required
/**
 *  获取每一行cell对应的编辑样式
 *
 *  @param tableView 父级tableview
 *  @param indexPath 索引
 *
 *  @return
 */
- (SCTableViewCellStyle)SCTableView:(UITableView *)tableView editStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取每一行cell对应的按钮集合的委托方法，在layoutsubview的时候调用
 *
 *  @param tableView 父级tableview
 *  @param indexPath 索引
 *
 *  @return SCTableViewCellRowActionButton的数组
 */
- (NSArray *)SCTableView:(UITableView *)tableView rightEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)SCTableView:(UITableView *)tableView leftEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

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

/**
 *  滑动的时候的加速度，这个可以放大你手指位移的距离，默认值是1.2，就可以和系统实现的效果差不多了
 *  Acceleration when dragging, set higher to make movement wider, default is 1.2, which is similar to the effect of system implementation
 */
@property (nonatomic) CGFloat dragAcceleration;

/**
 *  是否正在编辑状态
 *  Bool variable indicated the state whether you are editing your cell or not
 */
@property (nonatomic) BOOL isEditing;

@property (nonatomic, weak) id<SCTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView;

+ (void)endEditing;
@end
