//
//  MJPickerView.m
//  HotImageConfigDemo
//
//  Created by Dubai on 2019/4/28.
//  Copyright © 2019 Dubai. All rights reserved.
//

#import "MJPickerView.h"
#import "HotImageModel.h"


#define  kPickerViewHeight   (kHWHeight*0.7/2)

@interface MJPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView   *backView;
@property (nonatomic, strong) UIView   *pickBackView;
@property (nonatomic, strong) NSArray  *rowArray;
@property (nonatomic, strong) UIView  *lineView;

@property (nonatomic, strong) UIFont  *pickerListFont;
@property (nonatomic, strong) UIColor *pickerListColor;
@property (nonatomic, strong) UIColor *pickerLineColor;
@property (nonatomic, assign) CGFloat pickerRowHeight;

@end

@implementation MJPickerView


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, kHWWidth, kHWHeight);
        [self hw_creatUI];
    }
    return self;
}

- (void)hw_creatUI
{
    self.backView.frame = CGRectMake(0, 0, kHWWidth, kHWHeight);
    self.backView.alpha = 0.6;
    [self addSubview:self.backView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hw_removeSelfView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.backView addGestureRecognizer:tapGesture];
    
    self.pickBackView.frame = CGRectMake(0, kHWHeight, kHWWidth, kPickerViewHeight);
    [self addSubview:self.pickBackView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, kHWWidth, 0.5);
    layer.backgroundColor = MJ_UIColorFromHEX(0xe5e5e5).CGColor;
    [self.pickBackView.layer addSublayer:layer];
    
    self.titleLabel.frame = CGRectMake(60, 0, kHWWidth - 120, 40);
    [self.pickBackView addSubview:self.titleLabel];
    
    self.leftBtn.frame = CGRectMake(0, 0, 60, 40);
    [self.pickBackView addSubview:self.leftBtn];
    
    self.rightBtn.frame = CGRectMake(kHWWidth - 60, 0, 60, 40);
    [self.pickBackView addSubview:self.rightBtn];
    
    self.lineView.frame = CGRectMake(0, 40, kHWWidth, 1);
    [self.pickBackView addSubview:self.lineView];
    
    self.pickerView.frame = CGRectMake(0, 41, kHWWidth, kPickerViewHeight);
    [self.pickBackView addSubview:self.pickerView];
}


- (void)hw_renderList:(NSArray *)list configSource:(NSDictionary *)config
{
    NSNumber *isHaveLine = config[kHaveLine];
    self.lineView.hidden = ![isHaveLine boolValue];
    
    NSNumber *isHaveLeft = config[kHaveLeftBtn];
    self.leftBtn.hidden = ![isHaveLeft boolValue];
    
    self.pickerListFont = config[kPickerTextFont];
    self.pickerListColor = config[kPickerTextColor];
    self.pickerLineColor = config[kPickerLineColor];
    self.pickerRowHeight = [config[kPickerRowHeight] floatValue];

    self.rowArray = list;
    [self.pickerView reloadAllComponents];
}

- (void)setSelectRow:(NSInteger)selectRow
{
    _selectRow = selectRow;
    _indexPath = selectRow;
    [self performSelector:@selector(hw_selctRow) withObject:nil afterDelay:0.1];
}

- (void)hw_selctRow
{
    [self.pickerView selectRow:_selectRow inComponent:0 animated:NO];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self->_pickBackView.frame;
        rect.origin.y -= kPickerViewHeight;
        self->_pickBackView.frame = rect;
    }];
}

- (void)hw_nextAction:(UIButton *)sender
{
    [self hw_removeSelfView];
    
    if (sender.tag == 1 && self.rowArray .count > 0)
    {
        id returenObject = [self.rowArray  objectAtIndex:_indexPath];
        if (self.customBlock)
        {
            self.customBlock(returenObject, _indexPath);
        }
    }
}

- (void)hw_removeSelfView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self->_pickBackView.frame;
        rect.origin.y += kPickerViewHeight;
        self->_pickBackView.frame = rect;
    } completion:^(BOOL finished)
    {
        [self removeFromSuperview];
        
        if (self.removeBlock)
        {
            self.removeBlock();
        }
    }];
}

#pragma mark-- UIPickerViewDataSource -- UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.rowArray  count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HotImageUpdateModel *vo = [self.rowArray  objectAtIndex:row];
    return vo.selectText;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kHWWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (self.pickerRowHeight > 0)
    {
        return self.pickerRowHeight;
    }
    return 36.0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _indexPath = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        if (self.pickerListColor)
        {
            [pickerLabel setTextColor:self.pickerListColor];
        }
        
        if (self.pickerListFont)
        {
            [pickerLabel setFont:self.pickerListFont];
        }
        else
        {
            [pickerLabel setFont:[UIFont systemFontOfSize:28]];
        }
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    if (self.pickerLineColor)
    {
        [self changeSpearatorLineColor];
    }
    
    return pickerLabel;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)
        {
            speartorView.backgroundColor = self.pickerLineColor;
        }
    }
}

- (UIView *)backView
{
    if (!_backView)
    {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}


- (UIView *)pickBackView
{
    if (!_pickBackView)
    {
        _pickBackView = [[UIView alloc] init];
        _pickBackView.backgroundColor = [UIColor whiteColor];
    }
    return _pickBackView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = MJ_UIColorFromHEX(0x1b1b1b);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_leftBtn setTitleColor:MJ_UIColorFromHEX(0xFE4632) forState:(UIControlStateNormal)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftBtn.tag = 0;
        [_leftBtn addTarget:self action:@selector(hw_nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:MJ_UIColorFromHEX(0xFE4632) forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _rightBtn.tag = 1;
        [_rightBtn addTarget:self action:@selector(hw_nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MJ_UIColorFromHEX(0xe2e2e2);
    }
    return _lineView;
}


- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
