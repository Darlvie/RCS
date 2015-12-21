//
//  LTRegisterViewController.h
//  RCS
//
//  Created by aUser on 12/16/15.
//  Copyright © 2015 BGXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTRegisterViewControllerDelegate <NSObject>

@optional
- (void)registerDidComplete:(NSString *)username password:(NSString *)password;

@end
@interface LTRegisterViewController : UIViewController

@property (nonatomic,assign) id<LTRegisterViewControllerDelegate> deleagte;
@end
