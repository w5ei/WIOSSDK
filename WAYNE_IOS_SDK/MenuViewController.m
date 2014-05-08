//
//  MenuViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "MenuViewController.h"
#import "FacebookViewController.h"
#import "LifeManagerViewController.h"
#import "NotificationViewController.h"
#import "NumberView.h"
#import "文字处理/StringUtil.h"

@interface MenuViewController (){
    NSArray* _menuItemNames;
}
@end

@implementation MenuViewController

-(void)test{
    NSString *hanzi = @"我的天空多么的清晰";
    NSLog(@"%@",[StringUtil convertHanziToPinyin:hanzi]);
    NSLog(@"%@",[StringUtil convertHanziToPinyinInitials:hanzi]);
    NSString *py,*pyi;
    [StringUtil convertHanzi:hanzi toPinyin:&py andPinyinInitials:&pyi];
    NSLog(@"%@  %@",py, pyi);
}

#pragma mark- TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menuItemNames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellId = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NumberView* nv = (NumberView*)[cell viewWithTag:100];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIImage* bgImage = [UIImage imageNamed:@"button.jpg"];
        nv = [[NumberView alloc]initWithFrame:CGRectMake(cell.frame.size.width-20, 0, 20, 20)];
        [nv setBackgroundImage:bgImage marginTop:0 marginLeft:0];
        nv.tag = 100;
        nv.numberLabel.textColor = [UIColor whiteColor];
        nv.numberLabel.font = [UIFont boldSystemFontOfSize:18];
        [cell addSubview:nv];
    }
    [nv setNumber:indexPath.row+1000];
    cell.textLabel.text = [_menuItemNames objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark- TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
//            FacebookViewController* vc = [[FacebookViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 1:{
            LifeManagerViewController* vc = [[LifeManagerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 2:{
            NotificationViewController* vc = [[NotificationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        default:
            break;
    }
}

#pragma mark- Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"MainMenu";
    if (_menuItemNames==nil) {
        _menuItemNames = @[
                           @"FacebookSDK"
                           ,@"LifeManager"
                           ,@"Notification"
                           ];
    }
    [self test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
