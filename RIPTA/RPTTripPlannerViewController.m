//
//  RPTTripPlannerViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/29/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTTripPlannerViewController.h"

@interface RPTTripPlannerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation RPTTripPlannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *BGImage = [UIImage imageNamed:@"GradientPlanner.jpg"];
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    ImageView.image = BGImage;
    ImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    ImageView.layer.masksToBounds = TRUE;
    [self.view addSubview:ImageView];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    

    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:235.0/ 255.0 green:219.0/255.0 blue:152/255.0 alpha:.7];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(handleMenu:)];
    
    _toSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) * .15, CGRectGetWidth(self.view.frame), 44)];
    _toSearchBar.placeholder = @"Where are you going";
    _toSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    //_toSearchBar.scopeButtonTitles = @[@"All", @"Near", @"FewestTransfers"];
    _toSearchBar.delegate = self;
    
    
    
    
    
    
    [self.view addSubview:_toSearchBar];
    
    _fromSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, _toSearchBar.frame.origin.y + 40, _toSearchBar.frame.size.width, 44)];
    _fromSearchBar.placeholder = @"Start Point";
    _fromSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    _fromSearchBar.delegate = self;
    
    [self.view addSubview:_fromSearchBar];
    

    _tableHolsterView = [[UIView alloc] initWithFrame:CGRectMake(0, _fromSearchBar.frame.origin.y * 2.5, self.view.frame.size.width, (CGRectGetHeight(self.view.frame) * .5))];
    
    _tableHolsterView.backgroundColor = [UIColor blueColor];
    _tableHolsterView.layer.cornerRadius = 5;
    _tableHolsterView.alpha = .45;
    
    
    [self.view addSubview:_tableHolsterView];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:_tableHolsterView.bounds];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });

    [_tableHolsterView addSubview:_tableView];
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tableHolsterView.frame  = CGRectMake(0, (_fromSearchBar.frame.origin.y * 2.5) + _fromSearchBar.frame.origin.y * 2.4, self.view.frame.size.width, (CGRectGetHeight(self.view.frame) * .5));
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    

}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tableHolsterView.frame  = CGRectMake(0, (_fromSearchBar.frame.origin.y * 2.5), self.view.frame.size.width, (CGRectGetHeight(self.view.frame) * .5));
        
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
    

}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    [_toSearchBar resignFirstResponder];
    [_fromSearchBar resignFirstResponder];
    
    
    return YES;
}
- (void)handleMenu:(UIBarButtonItem*)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString* cellIdentifier = @"ripta.cell.menu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:21];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"Trip Planning Info";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    /*
     Check if currently visible controller is equal to item selected.
     if not - fade to new UIViewController
     else close menu
     
     */
    
}


@end
