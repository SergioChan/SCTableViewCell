//
//  SCTableViewController.m
//  SCTableView
//
//  Created by chen Yuheng on 15/9/13.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "SCTableViewController.h"
#import "SCTableViewCell.h"
#import "SCTableViewCellRowActionButton.h"

@interface SCTableViewController () <SCTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation SCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SCTableViewCell";
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    [self hideExtraCellLine];
    self.data = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void) hideExtraCellLine
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell)
    {
        cell = [[SCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier" inTableView:self.tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSString *item = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    return cell;
}

#pragma mark - SCTableViewCell Delegate
- (SCTableViewCellStyle)SCTableView:(UITableView *)tableView editStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCTableViewCellStyleRight;
}

- (NSArray *)SCTableView:(UITableView *)tableView leftEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[];
}

- (NSArray *)SCTableView:(UITableView *)tableView rightEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCTableViewCellRowActionButton *actionButton_1 = [[SCTableViewCellRowActionButton alloc]initWithTitle:@"更多" color:[UIColor lightGrayColor] withActionBlock:^(NSIndexPath *t_indexPath){
        NSLog(@"More!");
    }];
    SCTableViewCellRowActionButton *actionButton_2 = [[SCTableViewCellRowActionButton alloc]initWithTitle:@"旗标" color:[UIColor orangeColor] withActionBlock:^(NSIndexPath *t_indexPath){
        NSLog(@"Flag!");
    }];
    SCTableViewCellRowActionButton *actionButton_3 = [[SCTableViewCellRowActionButton alloc]initWithTitle:@"删除" color:[UIColor redColor] withActionBlock:^(NSIndexPath *t_indexPath){
        [self.data removeObjectAtIndex:t_indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[t_indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
    return @[actionButton_1,actionButton_2,actionButton_3];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select at %@",indexPath);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
    [SCTableViewCell endEditing];
}
/**
 *  这是系统的实现方式，无法做到邮箱的效果，但可以做到微信和QQ的左滑效果，iOS8以上才有
 *
 *  @param NSArray
 *
 *  @return
 */
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *test1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"测试1" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        
//    }];
//    test1.backgroundColor = [UIColor blueColor];
//    
//    UITableViewRowAction *test2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"测试2" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        
//    }];
//    test2.backgroundColor = [UIColor orangeColor];
//    
//    UITableViewRowAction *test3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"测试3" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        
//    }];
//    test3.backgroundColor = [UIColor redColor];
//    
//    return @[test1,test2,test3];
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
