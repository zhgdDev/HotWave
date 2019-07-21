//
//  MJPickerView.h
//  HotImageConfigDemo
//
//  Created by Dubai on 2019/4/28.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kHaveLine         @"kHaveLine"
#define kHaveLeftBtn      @"kHaveLeftBtn"
#define kPickerTextFont   @"kPickerTextFont"
#define kPickerTextColor  @"kPickerTextColor"

//默认36 可修改
#define kPickerRowHeight  @"kPickerRowHeight"

//如果需要修改picker分割线的颜色
#define kPickerLineColor  @"kPickerLineColor"


typedef void(^MJPickerConfirmBlock)(id pickObject, NSInteger index);
typedef void(^MJPickerCancelBlock)(void);

@interface MJPickerView : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel          *titleLabel;
@property (nonatomic, strong) UIPickerView     *pickerView;

@property (nonatomic, assign) NSInteger         selectRow;
@property (nonatomic, assign) NSInteger         indexPath;

@property (nonatomic, copy) MJPickerConfirmBlock customBlock;
@property (nonatomic, copy) MJPickerCancelBlock removeBlock;

- (instancetype)init;

/**
 装载数据
 
 @param list   列表数据源
 @param config 界面配置资源(key值已开出,根据需要自行可添加)
 */
- (void)hw_renderList:(NSArray *)list configSource:(NSDictionary *)config;

@end

NS_ASSUME_NONNULL_END
