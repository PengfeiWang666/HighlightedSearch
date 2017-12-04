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

@interface WPFViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

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
    NSLog(@"开始解析数据了，数据条数：%ld", (unsigned long)personArray.count);
    
    /** 耗时 0.0862秒
     2017-12-04 16:26:55.133029+0800 HighlightedSearch[87833:10581129] 开始解析数据了，数据条数：547
     2017-12-04 16:26:55.219175+0800 HighlightedSearch[87833:10581129] 数据解析完毕！
     */
//    for (NSInteger i = 0; i < personArray.count; ++i) {
    
    /** 耗时0.088秒
     2017-12-04 16:24:33.293051+0800 HighlightedSearch[87790:10577240] 开始解析数据了，数据条数：547
     2017-12-04 16:24:33.381268+0800 HighlightedSearch[87790:10577240] 数据解析完毕！
     */
//    for (NSString *name in personArray) {
    
    /** 耗时 0.046秒
     2017-12-04 16:21:13.108658+0800 HighlightedSearch[87755:10572526] 开始解析数据了，数据条数：547
     2017-12-04 16:21:13.154809+0800 HighlightedSearch[87755:10572526] 数据解析完毕！
     */
    [personArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            //            NSString *name = personArray[i];
            WPFPerson *person = [WPFPerson personWithName:obj hanyuPinyinOutputFormat:pinyinFormat];
            [tempArray addObject:person];
        }
    }];
    
    NSLog(@"数据解析完毕！");
    self.dataSource = tempArray;
}

- (void)_setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.titleView = self.searchVC.searchBar;
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchVC.searchBar setShowsCancelButton:YES animated:NO];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self settingNavigationItemBarButtons:NO];
}

- (void)settingNavigationItemBarButtons:(BOOL)searchBarIsExpand {
    if (searchBarIsExpand) {
        
        
    } else {
       
    }
}

#pragma mark - UISearchResultsUpdating
// 更新搜索结果
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%@", searchController.searchBar.text);
    
    [self.searchResultVC.resultDataSource removeAllObjects];
    
    // 遍历数据源，查看是否匹配，刷新结果列表
    // 后期考虑优化遍历效率
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        WPFPerson *person = self.dataSource[i];
        
        WPFSearchResultModel *resultModel = [WPFPinYinTools
                                             searchEffectiveResultWithSearchString:searchController.searchBar.text.lowercaseString
                                                   nameString:person.name
                                             completeSpelling:person.completeSpelling
                                                initialString:person.initialString
                                         pinyinLocationString:person.pinyinLocationString
                                        initialLocationString:person.initialLocationString];
        
        if (resultModel.highlightRang.length) {
            person.highlightLoaction = resultModel.highlightRang.location;
            person.textRange = resultModel.highlightRang;
            person.matchType = resultModel.matchType;
            [self.searchResultVC.resultDataSource addObject:person];
        }
    }
    
    [self.searchResultVC.resultDataSource sortUsingDescriptors:[WPFPinYinTools sortingRules]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultVC.tableView reloadData];
    });
    
    
}

#pragma mark  UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    UITableView *resultTableView = self.searchResultVC.tableView;
    
    CGRect rect = resultTableView.frame;
    rect.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height +self.navigationController.navigationBar.frame.size.height;
    rect.size.height = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    resultTableView.frame = rect;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    WPFPerson *person = self.dataSource[indexPath.row];
    cell.textLabel.text = person.name;
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
        // 是否添加半透明遮罩；默认为YES
        _searchVC.dimsBackgroundDuringPresentation = NO;
        // NO表示UISearchController在present时，可以覆盖当前controller，默认为NO
        _searchVC.definesPresentationContext = NO;
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.delegate = self;
        _searchVC.delegate = self;
    }
    return _searchVC;
}

@end
