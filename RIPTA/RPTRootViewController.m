//
//  ViewController.m
//  RIPTA
//
//  Created by Brian Olencki on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRootViewController.h"

@interface RPTRootViewController ()

@end

@implementation RPTRootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(handleMenu:)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    _searchBar.placeholder = @"Search";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = _searchBar;
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _detailsView = [[RPTDetailsView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40-20, CGRectGetHeight(self.view.frame)-100-30, (800/17), 100) withDelegate:self];
    [self.view addSubview:_detailsView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBarButtonItems
- (void)handleMenu:(UIBarButtonItem*)sender {
    
}

#pragma mark - MKMapViewDelegate

#pragma mark - RPTDetailsViewDelegate
- (void)detailsViewDidSelectInfoButton:(RPTDetailsView*)view {
    
}
- (void)detailsViewDidSelectCurrentLocationButton:(RPTDetailsView*)view {
    
}
@end
