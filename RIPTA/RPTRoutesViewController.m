//
//  RPTRoutesViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRoutesViewController.h"
#import "RESideMenu.h"


@interface RPTRoutesViewController () <MKMapViewDelegate, UITableViewDataSource, UITabBarDelegate, RPTRequestHandlerDelegate, UISearchBarDelegate, UITableViewDelegate> {
    MKPolyline *polyline;
}



@end

@implementation RPTRoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _RouteNum = [NSString stringWithFormat:@"3"];
    
    
    [self SetUpMapView];
    [[RPTRequestHandler sharedHandler] setDelegate:self];
    [[RPTRequestHandler sharedHandler] getBusses];
    [[RPTRequestHandler sharedHandler] getSiteInfo:_RouteNum];
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
    [_BottomHolderView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-5].active =TRUE;
    
    //[_BottomHolderView.heightAnchor constraintEqualToAnchor:_TopHolderView.heightAnchor constant:-20].active = TRUE;
    
    _MiddleView = [[UIView alloc]init];
    _MiddleView.translatesAutoresizingMaskIntoConstraints = false;
    
    _MiddleView.layer.cornerRadius = 5;
    _MiddleView.layer.shadowOffset = CGSizeMake(-15, 20);
    _MiddleView.layer.shadowRadius = 5;
    _MiddleView.layer.shadowOpacity = 1;
    
  
    [self.view addSubview:_MiddleView];
    
    [_MiddleView.centerXAnchor constraintEqualToAnchor:_BottomHolderView.centerXAnchor].active = TRUE;
    [_MiddleView.widthAnchor constraintEqualToAnchor:_BottomHolderView.widthAnchor multiplier:.87].active = TRUE;
    [_MiddleView.bottomAnchor constraintEqualToAnchor:_BottomHolderView.topAnchor constant:-15].active =TRUE;
    [_MiddleView.heightAnchor constraintEqualToConstant:100].active =TRUE;
    
    
    NSMutableArray *colorArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayOfColorsWithColorScheme:ColorSchemeComplementary usingColor:[UIColor blueColor] withFlatScheme:YES]];
    
    
    //_MiddleView.backgroundColor = colorArray[arc4random_uniform([colorArray count])];
    _MiddleView.backgroundColor = [UIColor flatPurpleColorDark];
    
    
    
    _PopUpLabel = [[UILabel alloc]init];
    _PopUpLabel2 = [[UILabel alloc]init];
    _PopUpLabel3 = [[UILabel alloc]init];
    _PopUpLabel.textAlignment = NSTextAlignmentCenter;
    _PopUpLabel2.textAlignment = NSTextAlignmentCenter;
    _PopUpLabel3.textAlignment = NSTextAlignmentCenter;
    _PopUpLabel.numberOfLines = 0;
    _PopUpLabel2.numberOfLines = 0;
    _PopUpLabel3.numberOfLines = 0;
    _PopUpLabel.translatesAutoresizingMaskIntoConstraints = false;
    _PopUpLabel2.translatesAutoresizingMaskIntoConstraints = false;
    _PopUpLabel3.translatesAutoresizingMaskIntoConstraints = false;
    _PopUpLabel.layer.masksToBounds = YES;
    _PopUpLabel2.layer.masksToBounds = YES;
    _PopUpLabel3.layer.masksToBounds =YES;
    _PopUpLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:16];
    _PopUpLabel2.font = [UIFont fontWithName:@"AvenirNext-Italic" size:16];
    _PopUpLabel3.font = [UIFont fontWithName:@"AvenirNext-Italic" size:14];
    _PopUpLabel.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:_BottomHolderView.backgroundColor isFlat:YES];
    
    _PopUpLabel2.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:_BottomHolderView.backgroundColor isFlat:YES];
    _PopUpLabel3.textColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:_BottomHolderView.backgroundColor isFlat:YES];
    
    _MiddleView.alpha = _PopUpLabel.alpha = _PopUpLabel2.alpha = _PopUpLabel3.alpha = 0.0;
    
    
    _PopUpLabel.text = @"Hellllloooooo";
    _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
    _PopUpLabel3.text = @"Time";
    
    [_MiddleView addSubview:_PopUpLabel];
    [_MiddleView addSubview:_PopUpLabel2];
    [_MiddleView addSubview:_PopUpLabel3];
    
    [_PopUpLabel.centerXAnchor constraintEqualToAnchor:_MiddleView.centerXAnchor].active =TRUE;
    [_PopUpLabel.widthAnchor constraintEqualToAnchor:_MiddleView.widthAnchor].active = TRUE;
    [_PopUpLabel.heightAnchor constraintEqualToConstant:22].active = TRUE;
    [_PopUpLabel.topAnchor constraintEqualToAnchor:_MiddleView.topAnchor constant:5].active=TRUE;
    
    [_PopUpLabel2.centerXAnchor constraintEqualToAnchor:_MiddleView.centerXAnchor].active =TRUE;
    [_PopUpLabel2.widthAnchor constraintEqualToAnchor:_MiddleView.widthAnchor].active = TRUE;
    [_PopUpLabel2.heightAnchor constraintEqualToConstant:22].active = TRUE;
    [_PopUpLabel2.topAnchor constraintEqualToAnchor:_PopUpLabel.bottomAnchor constant:-3].active=TRUE;
    
    [_PopUpLabel3.centerXAnchor constraintEqualToAnchor:_MiddleView.centerXAnchor].active = TRUE;
    [_PopUpLabel3.widthAnchor constraintEqualToAnchor:_MiddleView.widthAnchor].active = TRUE;
    [_PopUpLabel3.heightAnchor constraintEqualToConstant:60].active =TRUE;
    [_PopUpLabel3.topAnchor constraintEqualToAnchor:_PopUpLabel2.bottomAnchor constant:-5].active =TRUE;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
     
        tableView.translatesAutoresizingMaskIntoConstraints = false;
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
    
   

    switch (indexPath.row) {
        case 0:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:.75f];
                [_PopUpLabel3 setAlpha:.75f];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];
                } completion:nil];
            }];
        }

            break;
            case 1:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:.75f];
                [_PopUpLabel3 setAlpha:.75f];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];

                } completion:nil];
            }];
        }

            break;
        case 2:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:0.75f];
                [_PopUpLabel3 setAlpha:0.75f];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];

                } completion:nil];
            }];
        }

            break;
        case 3:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:0.75f];
                [_PopUpLabel3 setAlpha:0.75f];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];

                } completion:nil];
            }];
        }

            break;
        case 4:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
           _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:0.75f];
                [_PopUpLabel3 setAlpha:0.75f];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];

                } completion:nil];
            }];
        }
            break;
        case 5:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:0.75f];
                [_PopUpLabel3 setAlpha:0.75f];

            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];

                } completion:nil];
            }];
        }

            break;
        case 6:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:0.75f];
                [_PopUpLabel3 setAlpha:0.75f];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];
                    
                } completion:nil];
            }];
        }
            

            break;
        case 7:
        {  _PopUpLabel.text = [_Names objectAtIndex:indexPath.row];
            _PopUpLabel2.text = [NSString stringWithFormat:@"Route #%@", _RouteNum];
            _PopUpLabel3.text = [NSString stringWithFormat:@"The next bus leaving from this station is at approximately %@",[[_Times objectAtIndex:arc4random_uniform((unsigned int)_Times.count)]objectAtIndex:arc4random_uniform(4)]];
            [UIView animateWithDuration:1.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_PopUpLabel setAlpha:.75f];
                [_MiddleView setAlpha:.55f];
                [_PopUpLabel2 setAlpha:0.75f];
                [_PopUpLabel3 setAlpha:0.75f];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:5.f delay:3.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_PopUpLabel setAlpha:0.f];
                    [_MiddleView setAlpha:0.f];
                    [_PopUpLabel2 setAlpha:0.f];
                    [_PopUpLabel3 setAlpha:0.f];
                    
                } completion:nil];
            }];
        }
            
            break;
        default:
            break;
    }
    
    
    /*
     Check if currently visible controller is equal to item selected.
     if not - fade to new UIViewController
     else close menu
     */
    
    }
- (void)requestHandler:(RPTRequestHandler *)request didScrapeSite:(NSArray *)siteInfo{
    
    
    _Locations = [siteInfo objectAtIndex:0];
    NSLog(@"Locations : %@", _Locations);
    _Names = [siteInfo lastObject];
    _Times = [siteInfo mutableCopy];
    [_Times removeLastObject];
    
    
    
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
    
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
     });

}
- (void)mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame = endFrame; }];
    }
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
    [searchBar resignFirstResponder];
    _RouteNum = searchBar.text;
    
    
    
    
}
- (void)centerOnLocation:(CLLocation*)location {
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_Map setRegion:region animated:YES];
}
-(NSString*)GetClosestBusTime:(NSArray*)times{
    
    NSDate * Now = [NSDate date];
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    [Formatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [Formatter stringFromDate:Now];
    NSLog(@"newDateString %@", newDateString);
   
    return newDateString;
    
}



@end
