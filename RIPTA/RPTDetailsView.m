//
//  MPODetailsView.m
//  MapOut
//
//  Created by Brian Olencki on 10/10/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTDetailsView.h"

@implementation RPTDetailsView
- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<RPTDetailsViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        [self sharedInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (void)sharedInit {
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 10;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    _blurView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    [_blurView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [_blurView.layer setCornerRadius:10];
    [_blurView.layer setMasksToBounds:YES];
    [self addSubview:_blurView];
    
    btnInfo = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btnInfo addTarget:self action:@selector(handleInfo:) forControlEvents:UIControlEventTouchUpInside];
    [btnInfo setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2)];
    [self addSubview:btnInfo];
    
    btnCurrentLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCurrentLocation setImage:[UIImage imageNamed:@"CurrentLocation"] forState:UIControlStateNormal];
    [btnCurrentLocation setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [btnCurrentLocation addTarget:self action:@selector(handleCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [btnCurrentLocation setFrame:CGRectMake(0, CGRectGetMaxY(btnInfo.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2)];
    [self addSubview:btnCurrentLocation];
    
    viewDivider = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnInfo.frame)-0.5, CGRectGetWidth(self.frame), 2)];
    viewDivider.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self addSubview:viewDivider];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_blurView setFrame:self.bounds];
    [btnInfo setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2)];
    [btnCurrentLocation setFrame:CGRectMake(0, CGRectGetMaxY(btnInfo.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)/2)];
    [viewDivider setFrame:CGRectMake(0, CGRectGetMaxY(btnInfo.frame)-0.5, CGRectGetWidth(self.frame), 1)];
}
- (void)handleInfo:(UIButton*)sender {
    if ([_delegate respondsToSelector:@selector(detailsViewDidSelectInfoButton:)]) [_delegate detailsViewDidSelectInfoButton:self];
}
- (void)handleCurrentLocation:(UIButton*)sender {
    if ([_delegate respondsToSelector:@selector(detailsViewDidSelectCurrentLocationButton:)]) [_delegate detailsViewDidSelectCurrentLocationButton:self];
}
@end
