//
//  HotPointViewController.h
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/24.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HotActivityAreaModel;
typedef void(^ClickBlock)(HotActivityAreaModel *clickModel);

//位置
typedef NS_ENUM(NSInteger, HWHandleType)
{
    HWHandleType_None = 0,         //none
    HWHandleType_DirectUpdate,    //直接更新
    HWHandleType_LinkageUpdate,   //联动更新
    HWHandleType_Jump,            //跳转
};

@interface HotPointViewController : UIViewController

@property (nonatomic, copy) ClickBlock clickBlock;
@property (nullable, nonatomic, readonly) NSArray *showListData;

/**
 装载数据
 
 @param sourceData 加载列表数据源
 */
- (void)hw_renderData:(NSDictionary *)sourceData;

/**
 更新数据
 
 @param reloadArray  更新的数据源
 @param indexPaths   更新数据的indexPath
 */
- (void)hw_reloadListSource:(NSArray *)reloadArray indexPaths:(NSArray *)indexPaths;


@end

NS_ASSUME_NONNULL_END
