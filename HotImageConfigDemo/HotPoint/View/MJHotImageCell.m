//
//  MJHotImageCell.m
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/25.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import "MJHotImageCell.h"
#import "HotImageModel.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MJHotImageCell ()
{
    HotAdvertismentModel *_imageModel;
}

@property (nonatomic, strong) UIImageView *hotImageView;

@end

@implementation MJHotImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self hw_creatUI];
    }
    return self;
}
- (void)hw_creatUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType   = UITableViewCellAccessoryNone;
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.hotImageView];
}

- (void)hw_imgActivityAreaTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer && _imageModel.activityAreas && _imageModel.activityAreas.count > 0)
    {
        UIView *imgV      = [recognizer view];
        CGPoint tapPoint  = [recognizer locationInView:imgV];
        CGFloat tapXRatio = tapPoint.x / imgV.ct_width;
        CGFloat tapYRatio = tapPoint.y / imgV.ct_height;
        
        for (HotActivityAreaModel *area in _imageModel.activityAreas)
        {
            if (tapXRatio > area.xStart.floatValue && tapXRatio < area.xEnd.floatValue && tapYRatio > area.yStart.floatValue && tapYRatio < area.yEnd.floatValue)
            {
                if (_delegate && [_delegate respondsToSelector:@selector(hw_advertisementTappedAtArea:)])
                {
                    [_delegate hw_advertisementTappedAtArea:area];
                }
                break;
            }
        }
    }
}


+ (CGFloat)hw_fetchCellHeight:(HotAdvertismentModel *)vo
{
    CGFloat yVal         = 0;
    if (vo.picWidth && vo.picWidth.floatValue > 0 && vo.picHeight && vo.picHeight.floatValue > 0 && vo.picUrl && vo.picUrl.length > 0)
    {
        yVal = ceil(WIDTH * vo.picHeight.floatValue / vo.picWidth.floatValue);
    }
    return yVal;
}

- (void)hw_configCell:(HotAdvertismentModel *)vo
{
    _imageModel = vo;
    self.hotImageView.image = [UIImage imageNamed:vo.picUrl];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hw_imgActivityAreaTapped:)];
    tapGR.numberOfTapsRequired = 1;
    [self.hotImageView addGestureRecognizer:tapGR];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews
{
    if (_imageModel)
    {
        if (_imageModel.picWidth && _imageModel.picWidth.floatValue > 0 && _imageModel.picHeight && _imageModel.picHeight.floatValue > 0) {
            self.hotImageView.frame  = CGRectMake(0, 0, WIDTH, ceil(WIDTH * _imageModel.picHeight.floatValue / _imageModel.picWidth.floatValue));
        }
    }
}

- (UIImageView *)hotImageView
{
    if (!_hotImageView)
    {
        _hotImageView = [[UIImageView alloc] init];
        _hotImageView.contentMode     = UIViewContentModeScaleToFill;
        _hotImageView.userInteractionEnabled = YES;
    }
    return _hotImageView;
}

@end
