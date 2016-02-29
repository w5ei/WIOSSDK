//
//  IndexNamesViewController.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-6-26.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "IndexNamesViewController.h"
#import "StringEx.h"
@interface IndexNamesViewController (){
    NSMutableArray* _nameGroups;
    NSMutableArray* _indexTitles;
}

@end

@implementation IndexNamesViewController
-(void)indexFriends:(NSArray*)friends{
    if (_indexTitles) {
        [_indexTitles removeAllObjects];
    }else{
        _indexTitles = [NSMutableArray array];
    }
    
    NSBlockOperation* bo = [NSBlockOperation blockOperationWithBlock:^{
        for (NSString* nickname in friends) {
            NSString *cityPinyin,*cityInitial;
            [NSString convertHanzi:nickname toPinyin:&cityPinyin andPinyinInitials:&cityInitial];
//            [self.citiesPinyinArray addObject:cityPinyin];
//            [self.citiesInitialsArray addObject:cityInitial];
        }
        for (int i=0; i<1000000000; i++) {
            float j = i/50;
            j+=j;
        }
    }];
    [bo setCompletionBlock:^{
        NSLog(@"fff");
    }];
    NSOperationQueue* aQueue = [[NSOperationQueue alloc] init];
    [aQueue addOperation:bo];
}

#pragma mark-  TableView

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexTitles;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%d",section];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [_indexTitles indexOfObject:title];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _nameGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_nameGroups objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StateCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int cnum = [[[_nameGroups objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]intValue];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",cnum+1000];
    return cell;
}

#pragma mark- LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    _tableView.sectionIndexColor = [UIColor grayColor];
    //    _tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
