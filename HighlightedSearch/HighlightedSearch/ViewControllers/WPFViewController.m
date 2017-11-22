//
//  WPFViewController.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/21.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFViewController.h"
#import "WPFSearchResultViewController.h"
#import "WPFPerson.h"

@interface WPFViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchVC;
@property (nonatomic, strong) WPFSearchResultViewController *searchResultVC;

@end

static NSString *kCellIdentifier = @"kCellIdentifier";

@implementation WPFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initializeData];
    
    [self _setupUI];
}

#pragma mark - Private Method
- (void)_initializeData {
    // 解析 json 假数据
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"PersonList" ofType:@".json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:jsonPath]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *personArray = jsonDict[@"data"];
    
    // 将假数据按字母进行排序
    
    // 赋值
    HanyuPinyinOutputFormat *pinyinFormat = [WPFPinYinTools getOutputFormat];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < personArray.count; ++i) {
        @autoreleasepool {
            NSString *name = personArray[i];
            WPFPerson *person = [WPFPerson personWithName:name hanyuPinyinOutputFormat:pinyinFormat];
            [tempArray addObject:person];
        }
    }
    
    
    self.dataSource = personArray;
}

- (void)_setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.searchVC.searchBar;
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setters && Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (WPFSearchResultViewController *)searchResultVC {
    if (!_searchResultVC) {
        _searchResultVC = [[WPFSearchResultViewController alloc] init];
    }
    return _searchResultVC;
}

- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
//        self.searchController.searchResultsUpdater = self;
//        self.searchController.searchBar.delegate = self;
//        self.searchController.delegate = self;
    }
    return _searchVC;
}

@end
