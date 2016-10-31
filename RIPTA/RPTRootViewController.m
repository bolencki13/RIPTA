//
//  ViewController.m
//  RIPTA
//
//  Created by Brian Olencki on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRootViewController.h"
#import "RIPTA.h"

@interface RPTRootViewController () <RPTRequestHandlerDelegate>

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
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    _detailsView = [[RPTDetailsView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-40-20, CGRectGetHeight(self.view.frame)-100-30, (800/17), 100) withDelegate:self];
    [self.view addSubview:_detailsView];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RPTRequestHandler sharedHandler] setDelegate:self];
    [[RPTRequestHandler sharedHandler] getBusses];
    [self detailsViewDidSelectCurrentLocationButton:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBarButtonItems
- (void)handleMenu:(UIBarButtonItem*)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
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

#pragma mark - RPTRequestHandlerDelegate
- (void)requestHandler:(RPTRequestHandler *)request didFindBusses:(NSArray<RPTBus *> *)busses {
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (RPTBus *bus in busses) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:bus.position.coordinate];
        [_mapView addAnnotation:annotation];
    }
}
- (void)requestHandler:(RPTRequestHandler *)request didNotFindBussesWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RIPTA" message:@"Whoops, we are unable to connect to our netowrk at this time. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
