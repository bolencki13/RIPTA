//
//  RPTTripPlannerViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/29/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTTripPlannerViewController.h"

#import <ChameleonFramework/Chameleon.h>

@interface RPTTripPlannerViewController () {
    UISearchBar *sbrFrom;
    UISearchBar *sbrTo;
}
@end

@implementation RPTTripPlannerViewController
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ecf0f1"];
    
    sbrFrom = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    sbrFrom.placeholder = @"Address, Intersection, Landmark";
    [self.view addSubview:sbrFrom];
}
@end
