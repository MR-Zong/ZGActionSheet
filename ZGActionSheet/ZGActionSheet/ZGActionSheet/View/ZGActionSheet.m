//
//  ZGActionSheet.m
//  ZGActionSheet
//
//  Created by Zong on 15/12/30.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGActionSheet.h"

#define kUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define kUIScreenWidth [UIScreen mainScreen].bounds.size.width

static const CGFloat kMargin = 10;
static const CGFloat kButtonHeight = 64;
static const CGFloat KTitleHeight = 64;

@interface ZGActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,weak) NSString *title;

@property (nonatomic,weak) UIButton *cancelButton;

@property (nonatomic,weak) UIButton *destructiveButton;

@property (nonatomic,strong) NSArray *otherButtons;

@property (nonatomic,strong) NSArray *buttonsAry;

@property (nonatomic,strong) NSArray *argsArray;

@property (nonatomic,assign) BOOL isShow;

@property (nonatomic,assign) CGFloat offsetY;



@end

@implementation ZGActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<ZGActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    NSMutableArray *buttonsAry = [NSMutableArray array];
    NSMutableArray *argsArray = [NSMutableArray array];
    UIButton *cancelButton;
    UIButton *destructiveButton;
    
    
    if (destructiveButtonTitle) {
        destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
        [destructiveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [buttonsAry addObject:destructiveButton];
    }
    
    // 获取可变参数
    if (otherButtonTitles) {
        
        va_list params; //定义一个指向个数可变的参数列表指针;
        va_start(params,otherButtonTitles);//va_start 得到第一个可变参数地址,
        id arg;
        if (otherButtonTitles) {
            //将第一个参数添加到array
            id prev = otherButtonTitles;
            [argsArray addObject:prev];
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setTitle:prev forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonsAry addObject:btn1];
            
            //va_arg 指向下一个参数地址
            //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
            while( (arg = va_arg(params,id)) )
            {
                if ( arg ){
                    [argsArray addObject:arg];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitle:arg forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [buttonsAry addObject:btn];
                }
            }
            //置空
            va_end(params);
        }
    }
    
    
    
    if (cancelButtonTitle) {
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [buttonsAry addObject:cancelButton];
    }
    
    CGFloat height = kButtonHeight * buttonsAry.count;
    if (title) {
        height += KTitleHeight;
    }
    CGRect frame = CGRectMake(kMargin, kUIScreenHeight, kUIScreenWidth - 2*kMargin, height);
    
    return  [[self class] actionSheetTitleLabel:title delegate:delegate cancelButton:cancelButton destructiveButton:destructiveButton buttonsAry:[buttonsAry copy] argsAry:[argsArray copy] Frame:frame];

}


+ (instancetype)actionSheetTitleLabel:(NSString *)title delegate:(id <ZGActionSheetDelegate>)delegate cancelButton:(UIButton *)cancelButton destructiveButton:(UIButton *)destructiveButton buttonsAry:(NSArray *)buttonsAry argsAry:(NSArray *)argsAry Frame:(CGRect)frame
{
 
    ZGActionSheet *actionSheet = [[self alloc] initWithFrame:frame];

    if (title) {
        actionSheet.title = title;
    }
    
    if (delegate) {
        actionSheet.delegate = delegate;
    }
    
    if (cancelButton) {
        actionSheet.cancelButton = cancelButton;
    }
    
    if (destructiveButton) {
        actionSheet.destructiveButton = destructiveButton;
    }
    
    if (buttonsAry) {
        actionSheet.buttonsAry = buttonsAry;
        for (UIButton *btn in actionSheet.buttonsAry) {
            [btn addTarget:actionSheet action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (argsAry) {
        actionSheet.argsArray =  argsAry;
    }
    return actionSheet;
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
        if( [subView isKindOfClass:[ZGActionSheet class]] )
        {
            return;
        }
        
    }
    
    [view addSubview:self];
    self.isShow = YES;
    [self setOffsetYWithView:view];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect tmpFrame = self.frame;
        tmpFrame.origin.y -= self.frame.size.height;
        self.frame = tmpFrame;
        
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (self.isShow == NO) return;

    self.isShow = NO;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect tmpFrame = self.frame;
            tmpFrame.origin.y += self.frame.size.height;
            self.frame = tmpFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
          
        }];
        
    }else {
        
        [self removeFromSuperview];
    }
    
}


- (NSInteger)numberOfButtons
{
    return self.buttonsAry.count;
}

- (NSString *)title
{
    return _title;
}

- (void)setOffsetYWithView:(UIView *)view
{
    if (!_offsetY) {
        CGPoint point = [view convertPoint:view.frame.origin toView:view.window];
        self.offsetY = point.y;
    }
}

- (void)setOffsetY:(CGFloat)offsetY
{
    if (!_offsetY) {
        CGRect tmpFrame = self.frame;
        tmpFrame.origin.y -= offsetY;
        self.frame = tmpFrame;
    }
    
    _offsetY = offsetY;
}

#pragma mark - buttonClick:
- (void)buttonClick:(UIButton *)btn
{
    NSInteger index  = [self.buttonsAry indexOfObject:btn];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:button:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:index button:self.buttonsAry[index]];
    }
    [self dismissWithClickedButtonIndex:index animated:YES];
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
