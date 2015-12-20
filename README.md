# SCTableViewCell

[![CI Status](http://img.shields.io/travis/Sergio Chan/SCTableViewCell.svg?style=flat)](https://travis-ci.org/Sergio Chan/SCTableViewCell)
[![Version](https://img.shields.io/cocoapods/v/SCTableViewCell.svg?style=flat)](http://cocoapods.org/pods/SCTableViewCell)
[![License](https://img.shields.io/cocoapods/l/SCTableViewCell.svg?style=flat)](http://cocoapods.org/pods/SCTableViewCell)
[![Platform](https://img.shields.io/cocoapods/p/SCTableViewCell.svg?style=flat)](http://cocoapods.org/pods/SCTableViewCell)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 效果 Visual Effects

这是一个模仿iOS8中的邮箱里面的cell删除动效以及滑动右侧菜单按钮效果的开源库。

This is a custom table view cell from iOS Native Mail App, including the special Swipe-to-Delete Effects and Swipe-to-Show menu.

![图片高能](https://raw.githubusercontent.com/SergioChan/SCTableViewCell/master/intro1.gif)

![图片高能](https://raw.githubusercontent.com/SergioChan/SCTableViewCell/master/introv0.2.gif)

## 说明 Introduction
由于iOS 8 提供了`- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath` 这个API，因此例如微信和QQ的滑动菜单都是用系统自带的效果实现的，这个实现出来的效果和邮箱的有一些不一样，除了按钮在出现的动画上的区别，还有删除的交互和动效。我也比较欣赏苹果自己设计的这套交互，使用起来十分的爽，因此尝试着模仿实现了一下。

## 使用 How to use

继承SCTableViewCell，根据和系统类似的委托方法来控制编辑菜单和事件。在你的TableView中初始化你的cell:

```Objective-C
cell = [[SCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier" inTableView:self.tableView withSCStyle:SCTableViewCellStyleRight];
cell.delegate = self;
```

你需要在你的tableViewController中声明遵循`SCTableViewCellDelegate`，并且实现几个委托方法:

```Objective-C
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
```

其中定义了四种cell的编辑样式：

```Objective-C
typedef NS_ENUM(NSInteger, SCTableViewCellStyle) {
SCTableViewCellStyleDefault = 0,    // default table view cell style, just like UITableViewCell
SCTableViewCellStyleRight,  // table view cell with right button menu
SCTableViewCellStyleLeft,   // table view cell with left button menu
SCTableViewCellStyleBoth    // table view cell with both side button menu
};
```
### 样式 Style
**SCTableViewCellStyleDefault**是和其他的cell没有区别的cell，不会触发菜单的动画，你也可以自己定义cell上的手势操作，这个库不会做其他操作。**SCTableViewCellStyleRight**和**SCTableViewCellStyleLeft**就代表着只开放右侧或左侧滑动菜单，在邮箱中你也可以看到不管是左侧还是右侧你都能滑出一个自定义的菜单，如果你想要实现左右都能滑出菜单，则使用**SCTableViewCellStyleBoth**。

> 目前只实现了`SCTableViewCellStyleRight`。(2015-09-21)

样式需要在
`- (SCTableViewCellStyle)SCTableView:(UITableView *)tableView editStyleForRowAtIndexPath:(NSIndexPath *)indexPath;`这个委托方法中为每一行来指定。`SCTableViewCell`会在每次layout的时候调用这个委托来获取当前行的样式。

### 定义菜单结构 Custom your menu buttons
菜单的结构则是在`- (NSArray *)SCTableView:(UITableView *)tableView rightEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath;`和`- (NSArray *)SCTableView:(UITableView *)tableView leftEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath;`这两个委托方法中定义，现在是返回一个UIButton的数组即可，之后会做一个ActionButton的基类，名字叫做`SCTableViewCellRowActionButton`。具体定义方法可以参考demo。

### 操作的回调 Action Callback
获取菜单操作的委托方法是`- (void)SCTableView:(UITableView *)tableView commitActionIndex:(NSInteger)index forIndexPath:(NSIndexPath *)indexPath;`，滑动到底会触发`actions`中的最后一个`UIButton`的事件。记住你在定义菜单结构的时候，你数组中的button顺序就是在界面上呈现出来的顺序。

### 参数的调控 Available Variables

```Objective-C
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
```

`dragAnimationDuration`其实就是移动的时候动画执行的速率，值越小你所看到的动画就越快。`resetAnimationDuration`是你在拖拽超过了应有范围（现在是屏幕宽度的一半）之后松开手指会执行复原动画以及你没有拖拽到足够位置松开手指之后复原到消失的动画长度，值越大用户看到的效果越平滑，当然不能太大……否则就不够流畅了。至于最后的`dragAcceleration`，这是一个加速度，它可以放大你的移动，合适值在我简单调试后设置的是1.2，在这个值上，在速率，位移等方面都和邮箱的原生效果更相近。

## Requirements

## Installation

SCTableViewCell is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SCTableViewCell"
```

## Author

Sergio Chan, yuheng9211@qq.com

## License

SCTableViewCell is available under the MIT license. See the LICENSE file for more info.
