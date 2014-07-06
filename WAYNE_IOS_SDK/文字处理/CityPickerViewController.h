//
//  CityPickerViewController.h
//  YaoJiRewards
//
//  Created by YaoJi on 14-5-7.
//  Copyright (c) 2014年 YaoJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPickerViewController : UIViewController<UITabBarControllerDelegate,UITabBarDelegate,UITableViewDataSource,UITabBarDelegate,UICollectionViewDataSource,UIBarPositioningDelegate>{
    __weak IBOutlet UISearchBar *_searchBar;
}
@property (nonatomic, strong) NSMutableDictionary *citiesDic;
@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *citiesArray;//城市数据
@property (nonatomic, strong) NSMutableArray *hotCitiesArray;
@property (nonatomic, strong) NSMutableArray *citiesPinyinArray;
@property (nonatomic, strong) NSMutableArray *citiesInitialsArray;
@end
