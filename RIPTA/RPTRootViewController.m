//
//  ViewController.m
//  RIPTA
//
//  Created by Brian Olencki on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRootViewController.h"
#import "RIPTA.h"
#import "RPTSearchView.h"

@interface RPTRootViewController () <RPTRequestHandlerDelegate, RPTSearchViewDelegate, UISearchBarDelegate> {
    RPTSearchView *_searchView;
    UISegmentedControl *sgcMapType;
}
@end

@implementation RPTRootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(handleMenu:)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    _searchBar.placeholder = @"Search";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    _searchView = [[RPTSearchView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-60, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.navigationController.navigationBar.frame)-120)];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    
    sgcMapType = [[UISegmentedControl alloc] initWithItems:@[
                                                             @"Standard",
                                                             @"Hybrid",
                                                             @"Satellite",
                                                             ]];
    sgcMapType.frame = CGRectMake(15, 7.5, CGRectGetWidth(_searchView.frame)-30, 30);
    [sgcMapType addTarget:self action:@selector(handleMapType:) forControlEvents: UIControlEventValueChanged];
    sgcMapType.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"mapType"];
    [_searchView.contentView addSubview:sgcMapType];
    [self handleMapType:sgcMapType];
    
    _detailsView = [[RPTDetailsView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40-20, CGRectGetMinY(_searchView.frame)-100-5, (800/17), 100) withDelegate:self];
    [self.view addSubview:_detailsView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RPTRequestHandler sharedHandler] setDelegate:self];
    [[RPTRequestHandler sharedHandler] getBusses];
    [self detailsViewDidSelectCurrentLocationButton:nil];
    
    
    [[RPTRequestHandler sharedHandler] getSiteInfo:@"3"];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)handleMenu:(UIBarButtonItem*)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (void)handleMapType:(UISegmentedControl*)sender {
    switch (sender.selectedSegmentIndex) {
        case 2:
            _mapView.mapType = MKMapTypeSatellite;
            break;
        case 1:
            _mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            _mapView.mapType = MKMapTypeStandard;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegmentIndex forKey:@"mapType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Other
- (void)centerOnLocation:(CLLocation*)location {
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
//        search
    }];
    
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"ripta.pin.bus";
    
    MKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    if (annotation == _mapView.userLocation) {
        return nil;
    }
    else {
        annotationView.image = [UIImage imageNamed:@"Bus"];
    }
    
    return annotationView;
}

#pragma mark - RPTDetailsViewDelegate
- (void)detailsViewDidSelectInfoButton:(RPTDetailsView*)view {
    
}
- (void)detailsViewDidSelectCurrentLocationButton:(RPTDetailsView*)view {
    [[RPTLocationManager sharedManager] getUserLocation:^(CLLocation *location) {
        [self centerOnLocation:location];
    } error:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RIPTA" message:@"Whoops, we are unable to get your current location at this time. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - RPTSearchViewDelegate
- (void)searchView:(RPTSearchView *)searchView didMoveFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    [_detailsView setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40-20, CGRectGetMinY(_searchView.frame)-100-5, (800/17), 100)];
}
- (void)searchView:(RPTSearchView *)searchView didOpenToPoint:(CGPoint)point animated:(BOOL)animated {
    [_detailsView setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40-20, point.y-100-5, (800/17), 100)];
}
- (void)searchView:(RPTSearchView *)searchView didCloseToPoint:(CGPoint)point animated:(BOOL)animated {
    [_detailsView setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40-20, point.y-100-5, (800/17), 100)];
}

#pragma mark - RPTRequestHandlerDelegate
- (void)requestHandler:(RPTRequestHandler *)request didFindBusses:(NSArray<RPTBus *> *)busses {
    [_mapView removeAnnotations:_mapView.annotations];
    
    NSMutableArray *arySearchView = [NSMutableArray new];
    for (RPTBus *bus in busses) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:bus.position.coordinate];
        [_mapView addAnnotation:annotation];
        
        [arySearchView addObject:[NSString stringWithFormat:@"%@",bus.identifer
                                  ]];
    }
    
    _searchView.dictTableView = @{
                                  @"Busses" : arySearchView,
                                  };
    _searchView.shouldShowTitles = NO;
    [_searchView.tableView reloadData];
}
- (void)requestHandler:(RPTRequestHandler *)request didNotFindBussesWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RIPTA" message:@"Whoops, we are unable to connect to our netowrk at this time. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)requestHandler:(RPTRequestHandler *)request didScrapeSite:(NSArray *)siteInfo{
    
    
    
}
@end
