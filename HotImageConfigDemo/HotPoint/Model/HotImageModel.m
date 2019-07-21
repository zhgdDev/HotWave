//
//  HotImageModel.m
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/25.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import "HotImageModel.h"


@implementation HotImageModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"imageList": @"HotAdvertismentModel"
             };
}

@end

@implementation HotAdvertismentModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
            @"activityAreas": @"HotActivityAreaModel"
            };
}

@end

@implementation HotActivityAreaModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"updatePicVO": @"HotImageUpdateModel"
             };
}

@end

@implementation HotImageUpdateModel

@end


