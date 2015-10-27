//
//  SCScreenSnapshotSpliter.h
//  ClipViewInserSubView
//
//  Created by zt on 15/10/27.
//  Copyright © 2015年 justzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCScreenSnapshotSpliter : NSObject
+(instancetype)sharedSpliter;
/**
 *  分割当前屏幕，创建一个新的操作区域并且返回这个操作区域的view
 *
 *  @param pointer 分割点
 *  @param view    分割点所在的view
 *  @param height  新的操作区域高度
 *
 *  @return 操作区域view
 */
- (UIView*)splitScreenWithPointer:(CGPoint)pointer currentView:(UIView*)view spaseHeight:(CGFloat)height;

/**
 *  隐藏屏幕分割器
 */
- (void)hideScreenSpliter;
@end
