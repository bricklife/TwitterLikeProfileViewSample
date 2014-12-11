//
//  ProfileTableViewController.m
//  TwitterLikeProfileViewSample
//
//  Created by Shinichiro Oba on 2014/11/28.
//  Copyright (c) 2014年 Shinichiro Oba. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "ProfileHeaderViewController.h"

@interface ProfileTableViewController ()

@property (nonatomic, strong) UIView* headerView;
@property (nonatomic) CGRect initialFrame;
@property (nonatomic) CGFloat defaultViewHeight;
@property (nonatomic) CGFloat minimumHeaderViewHeight;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = self.tableView.tableHeaderView;

    _initialFrame = _headerView.frame;
    _defaultViewHeight = _initialFrame.size.height;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:_initialFrame];
    
    [self.tableView addSubview:_headerView];
    
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[ProfileHeaderViewController class]]) {
            _minimumHeaderViewHeight = ((ProfileHeaderViewController *)vc).minimumViewHeight;
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _initialFrame.size.width = self.tableView.frame.size.width;
    _headerView.frame = _initialFrame;
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_headerView.frame.size.height, 0, 0, 0);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = _headerView.frame;
    frame.size.width = self.tableView.frame.size.width;
    _headerView.frame = frame;
    
    CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
    _initialFrame.origin.y = offsetY * -1;

    CGFloat limit = _defaultViewHeight - _minimumHeaderViewHeight;
    if (scrollView.contentOffset.y < limit) {
        _initialFrame.size.height = _defaultViewHeight + offsetY;
    } else {
        _initialFrame.size.height = _defaultViewHeight - limit;
    }

    _headerView.frame = _initialFrame;
}

@end
