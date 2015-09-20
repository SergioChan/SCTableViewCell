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
    SCTableViewCellStyleDefault = 0,
    SCTableViewCellStyleRight,
    SCTableViewCellStyleLeft,
    SCTableViewCellStyleBoth
};

@interface SCTableViewCell : UITableViewCell

@property (nonatomic) CGFloat touchBeganPointX;
@property (nonatomic) CGFloat buttonWidth;

@property (nonatomic,strong) UIButton *actionButton_1;
@property (nonatomic,strong) UIButton *actionButton_2;
@property (nonatomic,strong) UIButton *actionButton_3;
@end
