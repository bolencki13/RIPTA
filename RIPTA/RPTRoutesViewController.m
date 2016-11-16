//
//  RPTRoutesViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRoutesViewController.h"
#import "RESideMenu.h"


@interface RPTRoutesViewController () <MKMapViewDelegate, UITableViewDataSource, UITabBarDelegate, RPTRequestHandlerDelegate, UISearchBarDelegate> {
    MKPolyline *polyline;
}



@end

@implementation RPTRoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self SetUpMapView];
    [[RPTRequestHandler sharedHandler] setDelegate:self];
    [[RPTRequestHandler sharedHandler] getBusses];
    [[RPTRequestHandler sharedHandler] getSiteInfo:@"3"];
    [[RPTLocationManager sharedManager] getUserLocation:^(CLLocation *location){
        [self centerOnLocation:location];
    }error:^(NSError *error){
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SetUpMapView{
    
   /* _TopHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)/2 ))];
    [self.view addSubview:_TopHolderView];
    _Map = [[MKMapView alloc]init];
    _Map.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _Map.delegate = self;
    [_TopHolderView addSubview:_Map];
    
    _BottomHolderView = [[UIView alloc] init];
    _BottomHolderView.translatesAutoresizingMaskIntoConstraints = false;*/
    
    UIImage *BGImage = [UIImage imageNamed:@"GradientPlanner.jpg"];
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    ImageView.image = BGImage;
    ImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    ImageView.layer.masksToBounds = TRUE;
    [self.view addSubview:ImageView];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(handleMenu:)];
    
    
    _TopHolderView =[[UIView alloc]init];
    _TopHolderView.translatesAutoresizingMaskIntoConstraints = false;
    _TopHolderView.backgroundColor = [UIColor clearColor];
    _TopHolderView.layer.masksToBounds = TRUE;
    [self.view addSubview:_TopHolderView];
    
    [_TopHolderView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    [_TopHolderView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = TRUE;
    [_TopHolderView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = TRUE;
    [_TopHolderView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:.55].active =TRUE;
    
    _Map = [[MKMapView alloc ]init];
    _Map.translatesAutoresizingMaskIntoConstraints  = false;
    _Map.layer.masksToBounds = YES;
    _Map.delegate = self;
    _Map.showsUserLocation = TRUE;
    [_TopHolderView addSubview:_Map];
    
    [_Map.widthAnchor constraintEqualToAnchor:_TopHolderView.widthAnchor].active =TRUE;
    [_Map.heightAnchor constraintEqualToAnchor:_TopHolderView.heightAnchor].active = TRUE;
    [_Map.topAnchor constraintEqualToAnchor:_TopHolderView.topAnchor].active = TRUE;
    [_Map.centerXAnchor constraintEqualToAnchor:_TopHolderView.centerXAnchor].active = TRUE;
    
    _BottomHolderView = [[UIView alloc]init];
    _BottomHolderView.translatesAutoresizingMaskIntoConstraints = false;
    //_BottomHolderView.layer.masksToBounds = TRUE;
    _BottomHolderView.backgroundColor = [UIColor blueColor];
    _BottomHolderView.alpha = .25;
    _BottomHolderView.layer.cornerRadius = 5;
    _BottomHolderView.layer.masksToBounds = NO;
    _BottomHolderView.layer.shadowOffset = CGSizeMake(-15, 20);
    _BottomHolderView.layer.shadowRadius = 5;
    _BottomHolderView.layer.shadowOpacity = 1;
    [self.view addSubview:_BottomHolderView];
    
    [_BottomHolderView.centerXAnchor constraintEqualToAnchor:_TopHolderView.centerXAnchor].active =TRUE;
    [_BottomHolderView.widthAnchor constraintEqualToAnchor:_TopHolderView.widthAnchor constant:-20].active = TRUE;
    [_BottomHolderView.topAnchor constraintEqualToAnchor:_TopHolderView.bottomAnchor constant:10].active = TRUE;
    [_BottomHolderView.heightAnchor constraintEqualToAnchor:_TopHolderView.heightAnchor constant:-20].active = TRUE;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
     //   UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 1.5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
      //  UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (_BottomHolderView.frame.origin.y), _BottomHolderView.frame.size.width, _BottomHolderView.frame.size.height) style:UITableViewStylePlain];
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        
        //tableView.style = UITableViewStylePlain;
       // _tableView.translatesAutoresizingMaskIntoConstraints = false;
        //_tableView.layer.masksToBounds = TRUE;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    [_BottomHolderView addSubview:_tableView];
    
    
    [_tableView.centerXAnchor constraintEqualToAnchor:_BottomHolderView.centerXAnchor].active =TRUE;
    [_tableView.widthAnchor constraintEqualToAnchor:_BottomHolderView.widthAnchor].active = TRUE;
    [_tableView.topAnchor constraintEqualToAnchor:_BottomHolderView.topAnchor].active = TRUE;
    [_tableView.heightAnchor constraintEqualToAnchor:_BottomHolderView.heightAnchor].active = TRUE;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.navigationController.navigationBar.bounds))];
    _searchBar.placeholder = @"Search for Routes";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    

    
}
- (void)handleMenu:(UIBarButtonItem*)sender {
    
    
      
    [self.sideMenuViewController presentLeftMenuViewController];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_Names count];
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
    cell.textLabel.text = [_Names objectAtIndex:indexPath.row];
    
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
- (void)requestHandler:(RPTRequestHandler *)request didScrapeSite:(NSArray *)siteInfo{
    
    _Names = [siteInfo lastObject];
    //NSLog(@"Names : %@", _Names);
    _Times = [siteInfo mutableCopy];
    [_Times removeLastObject];
    _Locations = [siteInfo objectAtIndex:0];
    NSLog(@"Locations : %@", _Locations);
    
    
    
    [_tableView reloadData];
    
    CLLocationCoordinate2D coordinates[[_Locations count]];
    
    NSInteger count = 0;
    for (int x = 0 ; x < [_Locations count]; x++) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[[_Locations objectAtIndex:x]objectForKey:@"latitude"] doubleValue], [[[_Locations objectAtIndex:x]objectForKey:@"longitude"] doubleValue]);
        if (!CLLocationCoordinate2DIsValid(coordinate) || !(coordinate.longitude != 0 && coordinate.latitude != 0)) continue;
        NSLog(@"Long : %f", coordinate.longitude);
        NSLog(@"Lat : %f", coordinate.latitude);

        
        
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
        
    [annotation setTitle:[[_Locations objectAtIndex:x] objectForKey:@"name"]];
    [_Map addAnnotation:annotation];

        coordinates[count] = coordinate;
        count++;
    }
    
    polyline = [MKPolyline polylineWithCoordinates:coordinates count:count];
  //[_Map addOverlay:polyline];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    if (annotation == _Map.userLocation) {
        return nil;
    }
    return pin;
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc]initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [[RPTRequestHandler sharedHandler] getSiteInfo:searchBar.text];
    
    
}
- (void)centerOnLocation:(CLLocation*)location {
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_Map setRegion:region animated:YES];
}




@end
