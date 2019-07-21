//
//  MJHotImageCell.h
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/25.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HotAdvertismentModel, HotActivityAreaModel;
@protocol HotActivityViewDelegate <NSObject>

- (void)hw_advertisementTappedAtArea:(HotActivityAreaModel *)area;

@end

@interface MJHotImageCell : UITableViewCell

@property (nullable, nonatomic, weak) id<HotActivityViewDelegate> delegate;

+ (CGFloat)hw_fetchCellHeight:(HotAdvertismentModel *)vo;

- (void)hw_configCell:(HotAdvertismentModel *)vo;

@end

NS_ASSUME_NONNULL_END
