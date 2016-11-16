//
//  RPTTripPlannerViewController.m
//  RIPTA
//
//  Created by Preston Perriott on 10/29/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTTripPlannerViewController.h"

#import <WebKit/WebKit.h>
#import <ChameleonFramework/Chameleon.h>
#import <ActionSheetPicker.h>
#import <AFNetworking/afnetworking.h>

@interface RPTTripPlannerViewController () {
    UISearchBar *sbrFrom;
    UISearchBar *sbrTo;
    WKWebView *webView;
    
    NSString *strDirection;
    NSString *strDate;
    NSString *strTime;
}
@end

@implementation RPTTripPlannerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ecf0f1"];
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 150)];
    [self.view addSubview:viewHeader];
    
    UILabel *lblFrom = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY([[UIApplication sharedApplication] statusBarFrame]), 65, 40)];
    lblFrom.text = @"From";
    lblFrom.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:lblFrom];
    
    sbrFrom = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblFrom.frame), CGRectGetMinY(lblFrom.frame), CGRectGetWidth(self.view.frame)-CGRectGetMaxX(lblFrom.frame), 40)];
    sbrFrom.searchBarStyle = UISearchBarStyleMinimal;
    sbrFrom.placeholder = @"Address, Intersection, Landmark";
    [viewHeader addSubview:sbrFrom];
    
    UILabel *lblTo = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sbrFrom.frame), 65, 40)];
    lblTo.text = @"To";
    lblTo.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:lblTo];
    
    sbrTo = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblTo.frame), CGRectGetMinY(lblTo.frame), CGRectGetWidth(self.view.frame)-CGRectGetMaxX(lblTo.frame), 40)];
    sbrTo.searchBarStyle = UISearchBarStyleMinimal;
    sbrTo.placeholder = @"Address, Intersection, Landmark";
    [viewHeader addSubview:sbrTo];
    
    strDirection = @"Leave Now";
    UIButton *btnDeparture = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDeparture addTarget:self action:@selector(handleDeparture:) forControlEvents:UIControlEventTouchUpInside];
    [btnDeparture setTitle:strDirection forState:UIControlStateNormal];
    [btnDeparture setFrame:CGRectMake(0, CGRectGetMaxY(sbrTo.frame)+5, CGRectGetWidth(viewHeader.frame)/3, 40)];
    [viewHeader addSubview:btnDeparture];
    
    strDate = @"Select";
    UIButton *btnDate = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDate addTarget:self action:@selector(handleDate:) forControlEvents:UIControlEventTouchUpInside];
    [btnDate setTitle:[NSString stringWithFormat:@"Date: %@",strDate] forState:UIControlStateNormal];
    [btnDate setFrame:CGRectMake(CGRectGetWidth(viewHeader.frame)/3, CGRectGetMaxY(sbrTo.frame)+5, CGRectGetWidth(viewHeader.frame)/3, 40)];
    [viewHeader addSubview:btnDate];
    
    strTime = @"Select";
    UIButton *btnTime = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnTime addTarget:self action:@selector(handleTime:) forControlEvents:UIControlEventTouchUpInside];
    [btnTime setTitle:[NSString stringWithFormat:@"Time: %@",strTime] forState:UIControlStateNormal];
    [btnTime setFrame:CGRectMake(CGRectGetWidth(viewHeader.frame)/3*2, CGRectGetMaxY(sbrTo.frame)+5, CGRectGetWidth(viewHeader.frame)/3, 40)];
    [viewHeader addSubview:btnTime];
    
    UIButton *btnGo = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnGo addTarget:self action:@selector(executeAPI) forControlEvents:UIControlEventTouchUpInside];
    [btnGo setTitle:@"Get Directions" forState:UIControlStateNormal];
    [btnGo setFrame:CGRectMake(0, CGRectGetMaxY(btnTime.frame)+5, CGRectGetWidth(viewHeader.frame), 40)];
    [viewHeader addSubview:btnGo];
    
    [viewHeader setFrame:CGRectMake(CGRectGetMinX(viewHeader.frame), CGRectGetMinY(viewHeader.frame), CGRectGetWidth(viewHeader.frame), CGRectGetMaxY(btnGo.frame))];
    
    UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    lblInfo.textAlignment = NSTextAlignmentCenter;
    lblInfo.text = @"Please fill in\nthe above fields";
    lblInfo.numberOfLines = 2;
    lblInfo.center = self.view.center;
    [self.view addSubview:lblInfo];
    
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewHeader.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(viewHeader.frame)) configuration:[WKWebViewConfiguration new]];
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [self.view addSubview:webView];
}

#pragma mark - Actions
- (void)handleDeparture:(UIButton*)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select a departure type" rows:@[@"Leave Now", @"Depart At",@"Arrive By"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        strDirection = selectedValue;
        [sender setTitle:strDirection forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}
- (void)handleDate:(UIButton*)sender {
    [ActionSheetDatePicker showPickerWithTitle:@"Select a date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:[NSDate date] maximumDate:nil doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/mm/yyyy"];
        strDate = [dateFormatter stringFromDate:selectedDate];
        [sender setTitle:strDate forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:sender];
}
- (void)handleTime:(UIButton*)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select a departure type" rows:@[@"5:00am",@"5:15am",@"5:30am",@"5:45am",@"6:00am",@"6:15am",@"6:30am",@"6:45am",@"7:00am",@"7:15am",@"7:30am",@"7:45am",@"8:00am",@"8:15am",@"8:30am",@"8:45am",@"9:00am",@"9:15am",@"9:30am",@"9:45am",@"10:00am",@"10:15am",@"10:30am",@"10:45am",@"11:00am",@"11:15am",@"11:30am",@"11:45am",@"12:00pm",@"12:15pm",@"12:30pm",@"12:45pm",@"1:00pm",@"1:15pm",@"1:30pm",@"1:45pm",@"2:00pm",@"2:15pm",@"2:30pm",@"2:45pm",@"3:00pm",@"3:15pm",@"3:30pm",@"3:45pm",@"4:00pm",@"4:15pm",@"4:30pm",@"4:45pm",@"5:00pm",@"5:15pm",@"5:30pm",@"5:45pm",@"6:00pm",@"6:15pm",@"6:30pm",@"6:45pm",@"7:00pm",@"7:15pm",@"7:30pm",@"7:45pm",@"8:00pm",@"8:15pm",@"8:30pm",@"8:45pm",@"9:00pm",@"9:15pm",@"9:30pm",@"9:45pm",@"10:00pm",@"10:15pm",@"10:30pm",@"10:45pm",@"11:00pm",@"11:15pm",@"11:30pm",@"11:45pm",@"12:00am",@"12:15am",@"12:30am",@"12:45am"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        strTime = selectedValue;
        [sender setTitle:strTime forState:UIControlStateNormal];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
}
- (void)executeAPI {
    if (![sbrFrom.text isEqualToString:@""] || ![sbrTo.text isEqualToString:@""] || ![strDate isEqualToString:@"Select"] || ![strTime isEqualToString:@"Select"]) {
        
        NSString *directionCode = @"dep";
        if ([strDirection isEqualToString:@"Arrive By"]) directionCode = @"arr";
        else if ([strDirection isEqualToString:@"Depart At"]) directionCode = @"dep";
        
        [webView loadRequest:[[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://www.ripta.com/site/get_directions.php" parameters:@{
                                                                                                                                                                    @"from" : sbrFrom.text,
                                                                                                                                                                    @"to" : sbrTo.text,
                                                                                                                                                                @"direction" : directionCode,                                                                                                                                                                    @"date" : strDate,
                                                                                                                                                                    @"time" : strTime,
                                                                                                                                                                    } error:nil]];
    }
}
@end
