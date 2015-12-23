//
//  NTESBirthPickerView.h
//  RCS
//
//  Created by zyq on 15/12/23.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completionHandler)(NSString *birth);

@protocol NTESBirthPickerViewDelegate <NSObject>

- (void)didSelectBirth:(NSString *)birth;

@end
@interface NTESBirthPickerView : UIView
@property (nonatomic,weak) id<NTESBirthPickerViewDelegate> delegate;

- (void)refreshWithBirth:(NSString *)birth;

- (void)showInView:(UIView *)view onCompletion:(completionHandler) handler;
@end
