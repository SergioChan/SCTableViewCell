//
//  SCTableViewCellRowActionButton.h
//  SCTableView
//
//  Created by chen Yuheng on 15/9/21.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommintActionBlock)(NSIndexPath *path);

@interface SCTableViewCellRowActionButton : UIButton

@property (nonatomic, copy) CommintActionBlock actionCallBack;

- (id)initWithTitle:(NSString *)title color:(UIColor *)color withActionBlock:(CommintActionBlock)block;
@end
