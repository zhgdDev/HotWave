//
//  HotPointViewController.m
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/24.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import "HotPointViewController.h"

#import "MJHotImageCell.h"
#import "HotImageModel.h"
#import "MJPickerView.h"
#import "AppDelegate.h"

#define kCellList @"cellList"

@interface HotPointViewController ()<UITableViewDelegate, UITableViewDataSource, HotActivityViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listSourceData;
@property (nonatomic, strong) HotImageModel *hotImageModel;
@property (nullable, nonatomic, strong) NSArray *showListData;

@end

@implementation HotPointViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"热浪";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self hw_creatUI];
}

- (void)hw_creatUI
{
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kHWWidth, kHWHeight -  Height_TabBar) style:(UITableViewStylePlain)];
                     self.listView.delegate = self;
                     self.listView.dataSource = self;
    
    if (@available(iOS 11.0, *))
    {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.edgesForExtendedLayout =UIRectEdgeNone;
    [self.listView registerClass:[MJHotImageCell class] forCellReuseIdentifier:kCellList];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listView];
}


/**
 装载数据
 */
- (void)hw_renderData:(NSDictionary *)sourceData
{
    NSDictionary *listData = sourceData;
    NSCAssert([listData isKindOfClass:[NSDictionary class]]  && listData != nil, @"sourceData must be NSDictionary class and does not nil");

    HotImageModel *imageListModel = [self hw_parseData:listData];
    NSArray *list  = imageListModel.imageList;
    self.showListData = list;
    [self.listSourceData removeAllObjects];
    [self.listSourceData addObjectsFromArray:list];
    [self.listView reloadData];
}


/**
 跳转操作
 */
- (void)hw_jumpActionWithUrl:(NSString *)jumpUrl
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"跳转信息" message:jumpUrl delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

/**
 更新操作处理   1 直接更新数据 2 连带更新数据
 */
- (void)hw_updateListWithVO:(HotActivityAreaModel *)selectVO
{
    NSNumber *updateType = selectVO.handleType;
    NSArray *replaceIndexPaths = [self hw_replacePicIndexArraySource:selectVO replaceType:1];
    NSArray *replacePicIdArray = [self hw_replacePicIdArraySource:selectVO replaceType:1];
    
    if ([updateType integerValue] == 1)
    {
        NSArray *dataList = [self hw_updateSource];
        NSMutableArray *replaceData = [NSMutableArray new];
        for (int i = 0; i < replacePicIdArray.count; i++)
        {
            NSNumber *replaceId = [replacePicIdArray objectAtIndex:i];
            for (HotAdvertismentModel *model in dataList)
            {
                NSNumber *picId = model.picId;
                if ([picId integerValue] == [replaceId integerValue])
                {
                    [replaceData addObject:model];
                }
            }
        }
        
        [self hw_reloadListSource:replaceData indexPaths:replaceIndexPaths];
    }
    else if ([updateType integerValue] == 2)
    {
        //先筛选出选直接更新的类型备用,选择完一起更新
//        NSArray *replaceIndexPaths = [self hw_replacePicIndexArraySource:selectVO replaceType:1];
//        NSArray *replacePicIdArray = [self hw_replacePicIdArraySource:selectVO replaceType:1];
        NSArray *selectListArray = [self hw_selectDataSource:selectVO];
        [self hw_selectData:selectListArray replaceIdData:replacePicIdArray replaceIndexData:replaceIndexPaths sourceVO:selectVO];
    }
}


- (void)hw_selectData:(NSArray *)pickerList replaceIdData:(NSArray *)directPicIdArray replaceIndexData:(NSArray *)directIndexArray sourceVO:(HotActivityAreaModel *)selectVO
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MJPickerView *picker = [[MJPickerView alloc] init];
        picker.backgroundColor = [UIColor clearColor];
        picker.titleLabel.text = @"请选择";
        NSDictionary *dict = @{kHaveLine:[NSNumber numberWithBool:true],kHaveLeftBtn:[NSNumber numberWithBool:true],kPickerTextFont:[UIFont systemFontOfSize:25],kPickerTextColor:[UIColor blueColor]};
        [picker hw_renderList:pickerList configSource:dict];
        
        __weak typeof(self) weakSelf = self;
        [picker setCustomBlock:^(id  _Nonnull pickObject, NSInteger index)
         {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            NSMutableArray *replacePidId = [[NSMutableArray alloc] init];
            [replacePidId addObjectsFromArray:directPicIdArray];
            
            NSMutableArray *replaceIndex = [[NSMutableArray alloc] init];
            [replaceIndex addObjectsFromArray:directIndexArray];
            
            NSArray *updateVOlist = selectVO.updatePicVO;
            HotImageUpdateModel *vo = pickObject;
            NSNumber *selectPicId = vo.replacePicId;
            
            for (int i = 0; i < updateVOlist.count; i++)
            {
                HotImageUpdateModel *vo = [updateVOlist objectAtIndex:i];
                if ([vo.replacePicId integerValue] == [selectPicId integerValue])
                {
                    [replacePidId addObject:vo.replacePicId];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[vo.replaceIndex integerValue] inSection:0];
                    [replaceIndex addObject:indexPath];
                }
            }
             
             NSArray *dataList = [strongSelf hw_updateSource];
            NSMutableArray *replaceData = [NSMutableArray new];
            for (int i = 0; i < replacePidId.count; i++)
            {
                NSNumber *replaceId = [replacePidId objectAtIndex:i];
                for (HotAdvertismentModel *model in dataList)
                {
                    NSNumber *picId = model.picId;
                    if ([picId integerValue] == [replaceId integerValue])
                    {
                        [replaceData addObject:model];
                    }
                }
            }
            
            [strongSelf hw_reloadListSource:replaceData indexPaths:replaceIndex];
        }];
        
        [HW_Window addSubview:picker];
    });
}


//获取更新数据源列表
- (NSArray *)hw_updateSource
{
    NSDictionary *jsonData = [self hw_readLocalFileWithName:@"updateSource"];
    HotImageModel *imageListModel = [self hw_parseData:jsonData];
    NSArray *dataList = imageListModel.imageList;
    return dataList;
}

#pragma mark-- CLActivityViewDelegate

- (void)hw_advertisementTappedAtArea:(HotActivityAreaModel *)area
{
    if (area)
    {
        NSNumber *handleType = area.handleType;
        if ([handleType integerValue] == 0)
        {
            
        }
        else if ([handleType integerValue] == 1 || [handleType integerValue] == 2)
        {
            [self hw_updateListWithVO:area];
            
        }
        else if ([handleType integerValue] == 3)
        {
            if (area.jumpUrl && area.jumpUrl.length > 0)
            {
                [self hw_jumpActionWithUrl:area.jumpUrl];
            }
        }
    }
}


#pragma mark-- UITableViewDataSource -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listSourceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJHotImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellList];
    if (cell == nil)
    {
        cell = [[MJHotImageCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:kCellList];
    }
    
    cell.delegate = self;
    HotAdvertismentModel *imageModel = [self.listSourceData objectAtIndex: indexPath.row];
    [cell hw_configCell:imageModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotAdvertismentModel *imageModel = [self.listSourceData objectAtIndex: indexPath.row];
    CGFloat cellHeight =  [MJHotImageCell hw_fetchCellHeight:imageModel];
    
    return cellHeight;
}


/*
 获取选择列表的数据源
 **/
- (NSArray *)hw_selectDataSource:(HotActivityAreaModel *)vo
{
    NSArray *volist = vo.updatePicVO;
    NSMutableArray *selectArray = [NSMutableArray array];
    
    for (int i = 0; i < volist.count; i++)
    {
        HotImageUpdateModel *vo = [volist objectAtIndex:i];
        if (vo.selectText && vo.selectText.length > 0)
        {
            [selectArray addObject:vo];
        }
    }
    
    return selectArray;
}

/**
 更新数据
 
 @param reloadArray  更新的数据源
 @param indexPaths   更新数据的indexPath
 */
- (void)hw_reloadListSource:(NSArray *)reloadArray indexPaths:(NSArray *)indexPaths
{
    if (reloadArray.count != indexPaths.count) return;
    
    [self.listView beginUpdates];
    
    NSMutableArray *finalIndexPaths = [NSMutableArray array];
    for (NSInteger i = 0; i < reloadArray.count; ++i)
    {
        NSDictionary *dict = [reloadArray objectAtIndex:i];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:i];
        
        if (!dict || indexPath.row >= self.listSourceData.count) continue;
        
        [self.listSourceData replaceObjectAtIndex:indexPath.row withObject:dict];
        [finalIndexPaths addObject:indexPath];
    }
    
    self.showListData = self.listSourceData;
    [self.listView reloadRowsAtIndexPaths:finalIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.listView endUpdates];
}

/**
 按类型获取替换的图片id 1 直接 2 连带更新
 */
- (NSArray *)hw_replacePicIdArraySource:(HotActivityAreaModel *)vo replaceType:(NSInteger )type
{
    NSArray *volist = vo.updatePicVO;
    NSMutableArray *picIdArray = [NSMutableArray array];
    
    for (int i = 0; i< volist.count; i++)
    {
        HotImageUpdateModel *vo = [volist objectAtIndex:i];
        if ([vo.replaceType integerValue] == type)
        {
            [picIdArray addObject:vo.replacePicId];
        }
    }
    
    return picIdArray;
}

/**
 按类型获取替换的index 1 直接 2 联带更新
 */
- (NSArray *)hw_replacePicIndexArraySource:(HotActivityAreaModel *)vo replaceType:(NSInteger )type
{
    NSMutableArray *replaceIndexPaths = [NSMutableArray array];
    NSArray *volist = vo.updatePicVO;
    
    for (int i = 0; i< volist.count; i++)
    {
        HotImageUpdateModel *vo = [volist objectAtIndex:i];
        if ([vo.replaceType integerValue] == type)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[vo.replaceIndex integerValue] inSection:0];
            [replaceIndexPaths addObject:indexPath];
        }
    }
    
    return replaceIndexPaths;
}


/**
 解析数据源
 */
- (HotImageModel *)hw_parseData:(NSDictionary *)sourceData
{
    HotImageModel *imageListModel = [HotImageModel mj_objectWithKeyValues:sourceData];
    return imageListModel;
}

/**
 读取本地文件
 */
- (NSDictionary *)hw_readLocalFileWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSMutableArray *)listSourceData
{
    if (!_listSourceData)
    {
        _listSourceData = [[NSMutableArray alloc] init];
    }
    return _listSourceData;
}

@end
