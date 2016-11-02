//
//  RPTSearchView.m
//  RIPTA
//
//  Created by Brian Olencki on 10/31/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTSearchView.h"

@implementation RPTSearchView
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
    
    _open = NO;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:(CGSize){10.0, 10.}].CGPath;
    self.layer.mask = maskLayer;
    
    _aryContent = [NSArray new];
    
    _blurView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    [self addSubview:_blurView];
    
    UIView *grabber = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-60)/2, 5, 60, 5)];
    grabber.backgroundColor = [UIColor grayColor];
    grabber.layer.cornerRadius = CGRectGetHeight(grabber.frame)/2;
    [self addSubview:grabber];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.frame), 50)];
    [self addSubview:_contentView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(_contentView.frame)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    UIPanGestureRecognizer *pgrMovement = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pgrMovement];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _blurView.frame = self.bounds;
    
    _contentView.frame = CGRectMake(0, 10, CGRectGetWidth(self.frame), 50);
    _tableView.frame = CGRectMake(0, 60, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(_contentView.frame));
}

#pragma mark - UIGestureRecognizer 
- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (!_open) origFrame = self.frame;
        } break;
            
        case UIGestureRecognizerStateChanged: {
            if (CGRectGetMinY(self.frame) <= CGRectGetMinY(origFrame)) {
                CGRect frame = self.frame;
                frame.origin.y = [recognizer locationInView:self.superview].y;
                self.frame = frame;
            }
        } break;
        
        case UIGestureRecognizerStateEnded: {
            if (_open) {
                [self closeAnimated:YES];
            }
            else {
                [self openAnimated:YES];
            }
        } break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        default: {
            
        } break;
    }
}
- (void)openAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = CGRectGetMinY(origFrame)-CGRectGetHeight(self.frame)-10;
            self.frame = frame;
        }];
    }
    else {
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetMinY(origFrame)-CGRectGetHeight(self.frame)-10;
        self.frame = frame;
    }
    _open = YES;
}
- (void)closeAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = CGRectGetMinY(origFrame);
            self.frame = frame;
        }];
    }
    else {
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetMinY(origFrame);
        self.frame = frame;
    }
    _open = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_aryContent count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"ripta.cell.search";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_aryContent objectAtIndex:indexPath.row];
    
    return cell;
}
@end
