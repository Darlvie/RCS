//
//  RCAnimatedImagesView.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/18.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kJSAnimatedImagesViewDefaultTimePerImage 20.0f

@protocol LTAnimatedImagesViewDelegate;

@interface LTAnimatedImagesView : UIView

@property (nonatomic, assign) id<LTAnimatedImagesViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval timePerImage;

- (void)startAnimating;
- (void)stopAnimating;

- (void)reloadData;

@end

@protocol LTAnimatedImagesViewDelegate
- (NSUInteger)animatedImagesNumberOfImages:(LTAnimatedImagesView *)animatedImagesView;
- (UIImage *)animatedImagesView:(LTAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index;
@end
