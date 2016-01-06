//
//  ZGSelectActionSheet.h
//  ZGActionSheet
//
//  Created by Zong on 16/1/5.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZGSelectActionSheetSelectedTypeDefault,
    ZGSelectActionSheetSelectedTypeSingle = ZGSelectActionSheetSelectedTypeDefault,
    ZGSelectActionSheetSelectedTypeMultiple,
} ZGSelectActionSheetSelectedType;

@class ZGSelectActionSheet;

@protocol ZGSelectActionSheetDelegate <NSObject>

@optional
- (void)selectActionSheet:(nonnull ZGSelectActionSheet *)actionSheet selectItemTitle:(nonnull NSString *)selectTitle selectIndex:(NSInteger) selectIndex;

@end

@interface ZGSelectActionSheet : UIView

- (nonnull instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<ZGSelectActionSheetDelegate>)delegate selectedType:(ZGSelectActionSheetSelectedType)ZGSelectActionSheetSelectedType cancelButtonTitle:(nullable NSString *)cancelButtonTitle confirmButtonTitle:(nullable NSString *)confirmButtonTitle itemButtonTitles:(nullable NSString *)itemButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");
- (void)showInView:(nullable UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic,strong,nullable) UIImage *selectedIndicatorImage;

@property (nonatomic,weak) id <ZGSelectActionSheetDelegate> delegate;

@end
