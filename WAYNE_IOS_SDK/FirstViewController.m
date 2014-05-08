//
//  FirstViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-22.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "FirstViewController.h"
#import "CommonEx.h"
@interface FirstViewController ()

@end

@implementation FirstViewController
-(void)testRegularExpression{
    NSString* str = @"abc@efg.org.cn";
    NSLog(@"%@ %@ email adress",str,[str isValidEmailAdress]?@"is":@"is not");
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id_"];
    cell.textLabel.text = @"555";
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self testRegularExpression];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
