//
//  CityPickerViewController.m
//  YaoJiRewards
//
//  Created by YaoJi on 14-5-7.
//  Copyright (c) 2014年 YaoJi. All rights reserved.
//

#import "CityPickerViewController.h"
#import "CommonEx.h"
#import "StringEx.h"
@interface CityPickerViewController (){
    NSMutableArray *_searchResults;
}
@end

@implementation CityPickerViewController

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
    // Do any additional setup after loading the view.
    self.hotCitiesArray = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
    self.keys = [NSMutableArray array];
    self.citiesArray = [NSMutableArray array];
    _searchResults = [[NSMutableArray alloc]init];
    self.citiesInitialsArray = [NSMutableArray array];
    self.citiesPinyinArray = [NSMutableArray array];
    [self loadCitiesData];
    
//    NSMutableString *ms = [[NSMutableString alloc] initWithString:@"我是中喆ren"];
//    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
//        NSLog(@"Pingying: %@", ms); // wǒ shì zhōng guó rén
//    }
//    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
//        NSLog(@"Pingying: %@", ms); // wo shi zhong guo ren
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.hotCitiesArray = NULL;
    self.keys = NULL;
    self.citiesArray = NULL;
    // Dispose of any resources that can be recreated.
}

#pragma mark- 获取城市数据
-(void)loadCitiesData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    self.citiesDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
//    NSLog(@"%@",_citiesArray);
    for (NSArray*cities in self.citiesDic.allValues) {
        [self.citiesArray addObjectsFromArray:cities];
    }
//    for (NSString* cityName in _citiesArray) {
//        NSLog(@"%@",cityName);
//    }
    [self.keys addObjectsFromArray:[self.citiesDic.allKeys sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.citiesDic setObject:_hotCitiesArray forKey:strHot];
    NSLog(@"sss");
    NSBlockOperation* bo = [NSBlockOperation blockOperationWithBlock:^{
        for (NSString* cityName in self.citiesArray) {
            NSString *cityPinyin,*cityInitial;
            [NSString convertHanzi:cityName toPinyin:&cityPinyin andPinyinInitials:&cityInitial];
            [self.citiesPinyinArray addObject:cityPinyin];
            [self.citiesInitialsArray addObject:cityInitial];
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
    NSLog(@"kmmm");
}
#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        return self.citiesArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = _searchResults[indexPath.row];
    }
    else {
        cell.textLabel.text = self.citiesArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_searchResults removeAllObjects];
    if (self.citiesPinyinArray.count<self.citiesArray.count) {
        return;
    }
    if (_searchBar.text.length>0) {
        //通过拼音字母搜索：有两种情况，一种是全拼，一种是首字母
        if (![_searchBar.text containsChineseCharacter]) {
            
            //遍历所有城市名
            NSMutableArray* citiesTemp = [NSMutableArray array];
            NSMutableArray* citiesPinyinTemp = [NSMutableArray array];
            NSString *pinyin,*pinyinIntitals;
            for (NSString *cityName in _citiesArray) {
                NSUInteger index = [_citiesArray indexOfObject:cityName];
                pinyin = [self.citiesPinyinArray objectAtIndex:index];
                pinyinIntitals = [self.citiesInitialsArray objectAtIndex:index];
                //如果不是首字母，则通过拼音进行匹配
                if (_searchBar.text.length>cityName.length) {
                    
                    //通过拼音全拼匹配
//                    NSLog(@"%@,%@",pinyin,_searchBar.text);
                    if ([pinyinIntitals hasPrefix:_searchBar.text]) {
                        [_searchResults addObject:cityName];
                        //把已经匹配的去掉。
                    }else{
                        //保存未匹配城市名
                        [citiesTemp addObject:cityName];
                        //如果未匹配则保留一份，这样不用再
                        [citiesPinyinTemp addObject:pinyin];
                    }
                }else{
                //如果可能是首字母？先通过首字母来匹配？再通过拼音匹配
                    
                    //避免重复添加
                    BOOL resultIsAdded = NO;
                    BOOL leftIsAdded = NO;
                    //通过首字母匹配
                    if ([pinyinIntitals hasPrefix:_searchBar.text]) {
                        if(!resultIsAdded){
                            resultIsAdded = YES;
                            [_searchResults insertObject:cityName atIndex:0];
//                            NSLog(@"pinyinIntitals cityname=%@",cityName);
                        }
                    }else{
                        if(!leftIsAdded){
                            leftIsAdded = YES;
                            [citiesTemp addObject:cityName];
                            [citiesPinyinTemp addObject:pinyin];
                        }
                    }
                    //通过拼音全拼匹配
                    if ([pinyin hasPrefix:_searchBar.text]) {
                        if(!resultIsAdded){
                            resultIsAdded = YES;
                            [_searchResults addObject:cityName];
//                            NSLog(@"pinyin cityname=%@",cityName);
                            [citiesTemp removeObject:cityName];
                            [citiesPinyinTemp removeObject:pinyin];
                        }
                    }else{
                        if(!leftIsAdded){
                            leftIsAdded = YES;
                            [citiesTemp addObject:cityName];
                            [citiesPinyinTemp addObject:pinyin];
                        }
                    }
                    
                }
            }
            for (NSString *cityName in citiesTemp) {
                NSUInteger index = [citiesTemp indexOfObject:cityName];
                NSString* cityNamePinyin = [citiesPinyinTemp objectAtIndex:index];
                NSRange titleResult = [cityNamePinyin rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_searchResults addObject:cityName];
//                    NSLog(@"titleResult cityname=%@",cityName);
                }
            }
        //通过汉字搜索，直接查找
        }else{
            NSMutableArray* citiesTemp = [NSMutableArray arrayWithArray:_citiesArray];
            //遍历所有城市名
            for (NSString *cityName in _citiesArray) {
                if ([cityName hasPrefix:_searchBar.text]) {
                    [citiesTemp removeObject:cityName];
                    [_searchResults addObject:cityName];
                }
            }
            for (NSString *cityName in citiesTemp) {
                NSRange titleResult = [cityName rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [_searchResults addObject:cityName];
                }
            }
        }
        
        
    }
    
    return;
//    if (_searchBar.text.length>0&&![_searchBar.text containsChineseCharacter]) {
//        for (int i=0; i<_citiesArray.count; i++) {
//            if ([_citiesArray[i] containsChineseCharacter]) {
//                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:_citiesArray[i]];
//                NSRange titleResult=[tempPinYinStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
//                if (titleResult.length>0) {
//                    [_searchResults addObject:_citiesArray[i]];
//                }
//                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:_citiesArray[i]];
//                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
//                if (titleHeadResult.length>0) {
//                    [_searchResults addObject:_citiesArray[i]];
//                }
//            }
//            else {
//                NSRange titleResult=[_citiesArray[i] rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
//                if (titleResult.length>0) {
//                    [_searchResults addObject:_citiesArray[i]];
//                }
//            }
//        }
//    } else if (_searchBar.text.length>0&&[_searchBar.text containsChineseCharacter]) {
//        for (NSString *tempStr in _citiesArray) {
//            NSRange titleResult=[tempStr rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
//            if (titleResult.length>0) {
//                [_searchResults addObject:tempStr];
//            }
//        }
//    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.citiesDic.allValues objectAtIndex:section]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cid" forIndexPath:indexPath];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.citiesDic.allValues.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
