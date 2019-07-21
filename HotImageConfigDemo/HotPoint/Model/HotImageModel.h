//
//  HotImageModel.h
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/25.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class HotAdvertismentModel, HotActivityAreaModel, HotImageUpdateModel;
@interface HotImageModel : NSObject

@property (nonatomic, strong) NSNumber *appVersion;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSArray<HotAdvertismentModel *> *imageList;
//@property (nonatomic, strong) NSArray<HotAdvertismentModel *> *updatelList;

@end

@interface HotAdvertismentModel : NSObject

@property (nonatomic, strong) NSNumber *picHeight;
@property (nonatomic, strong) NSNumber *picWidth;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSNumber *picId;
@property (nonatomic, strong) NSArray<HotActivityAreaModel *> *activityAreas;

@end

@interface HotActivityAreaModel : NSObject

//触发区域x轴起点/图片宽度
@property (nonatomic, strong) NSNumber *xStart;
//触发区域x轴终点/图片宽度
@property (nonatomic, strong) NSNumber *xEnd;
//触发区域y轴起点/图片高度
@property (nonatomic, strong) NSNumber *yStart;
//触发区域y轴终点/图片高度
@property (nonatomic, strong) NSNumber *yEnd;
//app端获取的跳转链接
@property (nonatomic, strong) NSString *jumpUrl;
//是跳转还是更新数据 0 无操作 1直接更新数据 2 连带更新数据 3 跳转操作
@property (nonatomic, strong) NSNumber *handleType;
//更新数据源
@property (nonatomic, strong) NSArray<HotImageUpdateModel *> *updatePicVO;

@end

@interface HotImageUpdateModel : NSObject

//1 直接  2 连带
@property (nonatomic, strong) NSNumber *replaceType;
@property (nonatomic, strong) NSNumber *replaceIndex;
@property (nonatomic, strong) NSNumber *replacePicId;
@property (nonatomic, strong) NSString *selectText;

@end



NS_ASSUME_NONNULL_END
