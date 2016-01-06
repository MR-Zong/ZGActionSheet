//
//  ViewController.m
//  ZGActionSheet
//
//  Created by Zong on 15/12/30.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGActionSheet.h"
#import "ZGSelectActionSheet.h"

@interface ViewController () <ZGActionSheetDelegate,ZGSelectActionSheetDelegate>

@property (nonatomic,strong) ZGActionSheet *actionSheet;

@property (nonnull,strong) ZGSelectActionSheet *reportActionSheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    ZGActionSheet *actionSheet = [[ZGActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"other1",@"other2",@"other3" ,nil];
//    self.actionSheet = actionSheet;
    
    ZGSelectActionSheet *reportActionSheet = [[ZGSelectActionSheet alloc] initWithTitle:@"选择举报的原因" delegate:self selectedType:ZGSelectActionSheetSelectedTypeDefault cancelButtonTitle:@"取消" confirmButtonTitle:@"举报" itemButtonTitles:@"选择一",@"选择二",@"选择三",@"选择四", nil];
    self.reportActionSheet = reportActionSheet;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.actionSheet showInView:self.view];
    [self.reportActionSheet showInView:self.view];
}

#pragma mark - <ZGSelectActionSheetDelegate>
- (void)selectActionSheet:(ZGSelectActionSheet *)actionSheet selectItemTitle:(NSString *)selectTitle selectIndex:(NSInteger)selectIndex
{
    NSLog(@"selectTitle %@,selectIndex %zd",selectTitle,selectIndex);
}

#pragma mark - <ZGActionSheetDelegate>
- (void)actionSheet:(ZGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex button:(UIButton *)button
{
    NSLog(@"buttonIndex %zd",buttonIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
