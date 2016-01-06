//
//  ZGSelectActionSheet.m
//  ZGActionSheet
//
//  Created by Zong on 16/1/5.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGSelectActionSheet.h"



#pragma mark - ZGSelectItemButton
@interface ZGSelectItemButton : UIButton

@end

static const CGFloat margin = 10;

@implementation ZGSelectItemButton


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect tmpImageViewFrame = self.imageView.frame;
    tmpImageViewFrame.origin.x = self.frame.size.width - self.imageView.frame.size.width - margin;
    self.imageView.frame = tmpImageViewFrame;
    
    CGRect tmpTitleLabelFrame = self.titleLabel.frame;
    tmpTitleLabelFrame.origin.x = margin;
    self.titleLabel.frame = tmpTitleLabelFrame;
    
}

@end



#define kUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define kUIScreenWidth [UIScreen mainScreen].bounds.size.width

static const CGFloat kMargin = 10;
static const CGFloat kButtonHeight = 44;
static const CGFloat KTitleHeight = 64;
static const NSString *selectedIndicatorImageName = @"clinic_done";



@interface ZGSelectActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,weak) UIButton *cancelButton;

@property (nonatomic,weak) UIButton *confirmButton;

@property (nonatomic,strong) NSArray *buttonsAry;

@property (nonatomic,strong) NSArray *argsArray;

@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,assign) CGFloat offsetY;

@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,weak) ZGSelectItemButton *curSelectButton;

@end

@implementation ZGSelectActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<ZGSelectActionSheetDelegate>)delegate selectedType:(ZGSelectActionSheetSelectedType)ZGSelectActionSheetSelectedType cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle itemButtonTitles:(NSString *)itemButtonTitles, ...
{
    
    NSMutableArray *buttonsAry = [NSMutableArray array];
    NSMutableArray *argsArray = [NSMutableArray array];
    UIButton *cancelButton;
    UIButton *confirmButton;
    
    // 获取可变参数
    if (itemButtonTitles) {
        
        va_list params; //定义一个指向个数可变的参数列表指针;
        va_start(params,itemButtonTitles);//va_start 得到第一个可变参数地址,
        id arg;
        if (itemButtonTitles) {
            //将第一个参数添加到array
            id prev = itemButtonTitles;
            [argsArray addObject:prev];
            ZGSelectItemButton *itemButton = [ZGSelectItemButton buttonWithType:UIButtonTypeCustom];
            [itemButton setTitle:prev forState:UIControlStateNormal];
            [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [itemButton setImage:[UIImage imageNamed:selectedIndicatorImageName] forState:UIControlStateNormal];
            itemButton.imageView.hidden = YES;
            [buttonsAry addObject:itemButton];
            
            //va_arg 指向下一个参数地址
            //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
            while( (arg = va_arg(params,id)) )
            {
                if ( arg ){
                    [argsArray addObject:arg];
                    ZGSelectItemButton *itemButton = [ZGSelectItemButton buttonWithType:UIButtonTypeCustom];
                    [itemButton setTitle:arg forState:UIControlStateNormal];
                    [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [buttonsAry addObject:itemButton];
                }
            }
            //置空
            va_end(params);
        }
    }
    
    
    NSString *defaultConfimButtonTitle = @"确认";
    if (confirmButtonTitle) {
        defaultConfimButtonTitle = confirmButtonTitle;
    }
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:defaultConfimButtonTitle forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonsAry addObject:confirmButton];
    
    NSString *defaultCancelButtonTitle = @"取消";
    if (cancelButtonTitle) {
        defaultConfimButtonTitle = cancelButtonTitle;
    }
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:defaultCancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [buttonsAry addObject:cancelButton];
    
    CGFloat height = kButtonHeight * buttonsAry.count;
    if (title) {
        height += KTitleHeight;
    }
    CGRect frame = CGRectMake(kMargin, kUIScreenHeight, kUIScreenWidth - 2*kMargin, height);
    
    return  [[self class] selectActionSheetTitleLabel:title delegate:delegate cancelButton:cancelButton confirmButton:confirmButton buttonsAry:[buttonsAry copy] argsAry:[argsArray copy] Frame:frame];
}


+ (instancetype)selectActionSheetTitleLabel:(NSString *)title delegate:(id <ZGSelectActionSheetDelegate>)delegate cancelButton:(UIButton *)cancelButton confirmButton:(UIButton *)confirmButton buttonsAry:(NSArray *)buttonsAry argsAry:(NSArray *)argsAry Frame:(CGRect)frame
{
    
    ZGSelectActionSheet *selectActionSheet = [[self alloc] initWithFrame:frame];
    
    if (title) {
        selectActionSheet.title = title;
    }
    
    if (delegate) {
        selectActionSheet.delegate = delegate;
    }
    
    if (cancelButton) {
        selectActionSheet.cancelButton = cancelButton;
    }
    
    if (confirmButton) {
        selectActionSheet.confirmButton = confirmButton;
    }
    
    if (buttonsAry) {
        selectActionSheet.buttonsAry = buttonsAry;
        for (int i=0; i<buttonsAry.count; i++) {
            ZGSelectItemButton *btn = buttonsAry[i];
            [btn addTarget:selectActionSheet action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                selectActionSheet.curSelectButton = btn;
            }
        }
    }
    
    if (argsAry) {
        selectActionSheet.argsArray =  argsAry;
    }
    return selectActionSheet;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self initView];
    }
    return self;
}


- (void)initView
{
    // maskView
    UIView *maskView = [[UIView alloc] init];
    self.maskView = maskView;
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
    [maskView addGestureRecognizer:tap];
    
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView =  tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)showInView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if( [subView isKindOfClass:[ZGSelectActionSheet class]] )
        {
            return;
        }
        
    }
    [view endEditing:YES];
    self.maskView.frame = view.window.bounds;
    [view.window addSubview:self.maskView];
    [view.window addSubview:self];
    self.isShow = YES;
    //    [self setOffsetYWithView:view];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect tmpFrame = self.frame;
        tmpFrame.origin.y -= self.frame.size.height;
        self.frame = tmpFrame;
        
    }];
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completedBlock:(void (^)(void))completedBlock
{
    if (self.isShow == NO) return;
    
    [self.maskView removeFromSuperview];
    self.isShow = NO;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect tmpFrame = self.frame;
            tmpFrame.origin.y += self.frame.size.height;
            self.frame = tmpFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (completedBlock) {
                completedBlock();
            }
            
        }];
        
    }else {
        
        [self removeFromSuperview];
    }
    
}



#pragma mark - buttonClick:
- (void)buttonClick:(ZGSelectItemButton *)btn
{
    NSInteger index  = [self.buttonsAry indexOfObject:btn];
    if (btn == self.confirmButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectActionSheet:selectItemTitle:selectIndex:)]) {
            [self.delegate selectActionSheet:self selectItemTitle:[self.curSelectButton titleForState:UIControlStateNormal] selectIndex:[self.buttonsAry indexOfObject:self.curSelectButton]];
        }
        
    }
    if (index > (self.buttonsAry.count - 3) ) {
        [self dismissWithClickedButtonIndex:index animated:YES completedBlock:nil];
    }else {
        [self.curSelectButton setImage:nil forState:UIControlStateNormal];
        self.curSelectButton = btn;
        [self.curSelectButton setImage:[UIImage imageNamed:selectedIndicatorImageName] forState:UIControlStateNormal];
    }
}

#pragma mark - tapMaskView
- (void)tapMaskView
{
    [self dismissWithClickedButtonIndex:0 animated:YES completedBlock:nil];
    
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.title) {
        return self.buttonsAry.count + 1;
    }
    return self.buttonsAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *KActionSheetCellID = @"ZGActionSheetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KActionSheetCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KActionSheetCellID];
    }
    
    
    CGFloat lineWidth = kButtonHeight - 1;
    
    if (indexPath.row == 0 && self.title) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, KTitleHeight);
        [cell.contentView addSubview:titleLabel];
        lineWidth = KTitleHeight - 1;
    }else {
        NSInteger index = indexPath.row;
        if (self.title) {
            index--;
        }
        UIButton *btn = self.buttonsAry[index];
        btn.frame = CGRectMake(0, 0, self.frame.size.width, kButtonHeight);
        [cell.contentView addSubview:btn];
    }
    
    // add seperatorLine
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, lineWidth, self.frame.size.width, 1);
    [cell.contentView addSubview:lineView];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 && self.title) {
        return KTitleHeight;
    }
    return kButtonHeight;
}



@end

