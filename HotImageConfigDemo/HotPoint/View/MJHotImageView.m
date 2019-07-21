//
//  MJHotImageView.m
//  Demo_image_Bundle
//
//  Created by Dubai on 2019/4/25.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import "MJHotImageView.h"
#import "HotImageModel.h"


@interface MJHotImageView ()
{
    HotAdvertismentModel *_imageModel;
}

@property (nonatomic, strong) UIImageView *activityImageView;

@end

@implementation MJHotImageView

- (instancetype)init;
{
    self = [super init];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgActivityAreaTapped:)];
    [self.activityImageView addGestureRecognizer:tapGR];
    [self addSubview:self.activityImageView];
}

- (void)renderData:(HotAdvertismentModel *)model
{
    _imageModel = model;
    
    [self layoutIfNeeded];
}

- (void)imgActivityAreaTapped:(UITapGestureRecognizer *)recognizer
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
                if (_delegate && [_delegate respondsToSelector:@selector(advertisementTappedAtArea:)])
                {
                    [_delegate advertisementTappedAtArea:area];
                }
                break;
            }
        }
    }
}

- (void)layoutSubviews
{
    if (_imageModel)
    {
        if (_imageModel.picWidth && _imageModel.picWidth.floatValue > 0 && _imageModel.picHeight && _imageModel.picHeight.floatValue > 0) {
            self.activityImageView.frame  = CGRectMake(0, 0, kHWWidth, ceil(kHWWidth * _imageModel.picHeight.floatValue / _imageModel.picWidth.floatValue));
            self.activityImageView.contentMode     = UIViewContentModeScaleToFill;
            //      [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:_imgData.picUrl] placeholderImage:[UIImage imageNamed:@""]];
            self.activityImageView.image = [UIImage imageNamed:_imageModel.picUrl];
            [self setFrame:self.activityImageView.bounds];
            [self addSubview:self.activityImageView];
        }
    }
}

- (UIImageView *)activityImageView
{
    if (!_activityImageView)
    {
        _activityImageView = [[UIImageView alloc] init];
        _activityImageView.userInteractionEnabled = YES;
    }
    return _activityImageView;
}

@end
