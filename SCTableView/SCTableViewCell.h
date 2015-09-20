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

@property (nonatomic) CGFloat touchBeganPointX;
@property (nonatomic) CGFloat buttonWidth;

@property (nonatomic) CGFloat dragAnimationDuration;
@property (nonatomic) CGFloat resetAnimationDuration;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *actionButton_1;
@property (nonatomic, strong) UIButton *actionButton_2;
@property (nonatomic, strong) UIButton *actionButton_3;

@property (nonatomic, copy) void (^deleteRowHandler)(void);

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView withSCStyle:(SCTableViewCellStyle)sc_style;
@end
