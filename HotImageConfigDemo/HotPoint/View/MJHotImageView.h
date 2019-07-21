//
//  MJHotImageView.h
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/25.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HotActivityAreaModel, HotAdvertismentModel;

@protocol HotActivityViewDelegate <NSObject>

- (void)advertisementTappedAtArea:(HotActivityAreaModel *)area;

@end

@interface MJHotImageView : UIView

@property (nonatomic, weak) id<HotActivityViewDelegate> delegate;

- (instancetype)init;

- (void)renderData:(HotAdvertismentModel *)model;

@end

NS_ASSUME_NONNULL_END
