//
//  WPFSearchResultViewController.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WPFSearchResultViewController.h"
#import "WPFPerson.h"

@interface WPFSearchResultViewController ()

@end

static NSString *kResultCellIdentifier = @"kResultCellIdentifier";

@implementation WPFSearchResultViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kResultCellIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResultCellIdentifier];
    WPFPerson *person = self.resultDataSource[indexPath.row];
    cell.textLabel.text = person.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setters && Getters
- (NSMutableArray *)resultDataSource {
    if (!_resultDataSource) {
        _resultDataSource = [NSMutableArray array];
    }
    return _resultDataSource;
}

@end
