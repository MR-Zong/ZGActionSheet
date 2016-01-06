//
//  ZGActionSheet.h
//  ZGActionSheet
//
//  Created by Zong on 15/12/30.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGActionSheet;

@protocol ZGActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(nonnull ZGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex button:(nullable UIButton *)button;

@end

@interface ZGActionSheet : UIView

- (nonnull instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<ZGActionSheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");

- (NSInteger)addButton:(nullable UIButton *)button;
- (nullable UIButton *)buttonAtIndex:(NSInteger)buttonIndex;

- (NSInteger)numberOfButtons;
- (nullable NSString *)title;

- (NSInteger)addView:(nonnull UIView *)view frame:(CGRect)viewFrame;
- (void)showInView:(nullable UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic,weak) id <ZGActionSheetDelegate> delegate;


@end
