//
//  ViewController.h
//  RIPTA
//
//  Created by Brian Olencki on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "RPTDetailsView.h"

@interface RPTRootViewController : UIViewController <MKMapViewDelegate, RPTDetailsViewDelegate>
@property (nonatomic, retain, readonly) MKMapView *mapView;
@property (nonatomic, retain, readonly) UISearchBar *searchBar;
@property (nonatomic, retain, readonly) RPTDetailsView *detailsView;
@end

