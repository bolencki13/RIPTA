//
//  MPODetailsView.h
//  MapOut
//
//  Created by Brian Olencki on 10/10/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPTDetailsView;
@protocol RPTDetailsViewDelegate <NSObject>
- (void)detailsViewDidSelectInfoButton:(RPTDetailsView*)view;
- (void)detailsViewDidSelectCurrentLocationButton:(RPTDetailsView*)view;
@end

@interface RPTDetailsView : UIView {
    UIButton *btnInfo;
    UIButton *btnCurrentLocation;
    
    UIView *viewDivider;
}
@property (nonatomic, retain, readonly) UIVisualEffectView *blurView;
@property (nonatomic, retain) id<RPTDetailsViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<RPTDetailsViewDelegate>)delegate;
@end
