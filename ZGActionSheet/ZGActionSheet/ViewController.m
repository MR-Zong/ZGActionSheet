//
//  ViewController.m
//  ZGActionSheet
//
//  Created by Zong on 15/12/30.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGActionSheet.h"

@interface ViewController () <ZGActionSheetDelegate>

@property (nonatomic,strong) ZGActionSheet *actionSheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZGActionSheet *actionSheet = [[ZGActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"other1",@"other2",@"other3",@"other4",@"other5" ,nil];
    self.actionSheet = actionSheet;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.actionSheet showInView:self.view];
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
