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

/**
 *  每一行cell的动作触发回调
 *
 *  @param tableView 父级tableview
 *  @param index     动作index
 *  @param indexPath 索引
 */
- (void)SCTableView:(UITableView *)tableView commitActionIndex:(NSInteger)index forIndexPath:(NSIndexPath *)indexPath;

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

@property (nonatomic, weak) id<SCTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView withSCStyle:(SCTableViewCellStyle)sc_style;
@end
