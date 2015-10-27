//
//  SCScreenSnapshotSpliter.m
//  ClipViewInserSubView
//
//  Created by zt on 15/10/27.
//  Copyright © 2015年 justzt. All rights reserved.
//

#import "SCScreenSnapshotSpliter.h"

@interface SCScreenSnapshotSpliter (){

}
@property (nonatomic, assign) BOOL isSplit;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *spaseView;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIImageView *bottomImageView;
@property (nonatomic,assign) CGPoint splitPoint;
@end

static SCScreenSnapshotSpliter *_sharedSpliter;

@implementation SCScreenSnapshotSpliter

+(instancetype)sharedSpliter{
    if (_sharedSpliter) {
        return _sharedSpliter;
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedSpliter = [[SCScreenSnapshotSpliter alloc] init];
        });
        return _sharedSpliter;
    }
    
}

+(UIWindow*)window{
    return [UIApplication sharedApplication].keyWindow;
}

+(UIImage*)snapshotForScreen{
    // 0.0确保当前分辨率
    UIView *window = [SCScreenSnapshotSpliter window];
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, window.opaque, 0.0f);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+(CGFloat)scaleWithScreenImage:(UIImage*)image{
    // 320 ， 375 ，414
    NSInteger width = image.size.width;
    switch (width) {
        case 320:
        case 375:
            return 2;
            break;
        case 414:
            return 3;
            break;
        default:
            break;
    }
    return 2;
}

- (UIView*)splitScreenWithPointer:(CGPoint)pointer currentView:(UIView*)view spaseHeight:(CGFloat)height{
    CGPoint newCenter = [[view superview] convertPoint:pointer toView:[SCScreenSnapshotSpliter window]];
    self.splitPoint = newCenter;
    CGSize size = CGSizeMake(CGRectGetWidth([SCScreenSnapshotSpliter window].bounds), CGRectGetHeight([SCScreenSnapshotSpliter window].bounds)-newCenter.y);
    UIImage *screenImage = [SCScreenSnapshotSpliter snapshotForScreen];
    CGFloat scale = [SCScreenSnapshotSpliter scaleWithScreenImage:screenImage];
    
    CGImageRef imageCG = CGImageCreateWithImageInRect(screenImage.CGImage, CGRectMake(0, 0, size.width*scale,newCenter.y*scale));
    UIImage *topIamge = [UIImage imageWithCGImage:imageCG];
    imageCG = CGImageCreateWithImageInRect(screenImage.CGImage, CGRectMake(0, newCenter.y*scale, size.width*scale,size.height*scale));
    UIImage *bottomIamge = [UIImage imageWithCGImage:imageCG];
    
    self.maskView = [[UIView alloc] initWithFrame:[SCScreenSnapshotSpliter window].bounds];
    self.maskView.backgroundColor = [UIColor grayColor];
    [[SCScreenSnapshotSpliter window] addSubview:self.maskView];
    
    self.topImageView = [[UIImageView alloc] initWithImage:topIamge];
    CGFloat offsetY = height/2;
    CGRect origin = CGRectMake(0, 0, size.width, newCenter.y);
    CGRect dest = CGRectMake(0, -offsetY, size.width, newCenter.y);
    [self animationForView:self.topImageView origin:origin destination:dest];
    [self.maskView addSubview:self.topImageView];
    
    self.bottomImageView = [[UIImageView alloc] initWithImage:bottomIamge];
    origin = CGRectMake(0, newCenter.y, size.width, size.height);
    dest = CGRectMake(0, newCenter.y+offsetY, size.width, size.height);
    [self animationForView:self.bottomImageView origin:origin destination:dest];
    [self.maskView addSubview:self.bottomImageView];
    
    self.spaseView = [[UIView alloc] init];
    self.spaseView.backgroundColor = [UIColor brownColor];
    [self.maskView insertSubview:self.spaseView belowSubview:self.topImageView];
    origin = CGRectMake(0, newCenter.y, size.width, 0);
    dest = CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), size.width, height);
    [self animationForView:self.spaseView origin:origin destination:dest];
    
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideScreenSpliter)];
    [self.maskView addGestureRecognizer:tapGuesture];
    self.maskView.userInteractionEnabled = YES;

    return self.spaseView;
}

- (void)hideScreenSpliter{
    __weak SCScreenSnapshotSpliter *weakSelf = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         CGRect frame = weakSelf.topImageView.frame;
                         frame.origin.y = 0;
                         weakSelf.topImageView.frame = frame;
                         frame = weakSelf.bottomImageView.frame;
                         frame.origin.y = weakSelf.splitPoint.y;
                         weakSelf.bottomImageView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         [weakSelf.topImageView removeFromSuperview];
                         weakSelf.topImageView = nil;
                         [weakSelf.bottomImageView removeFromSuperview];
                         weakSelf.bottomImageView = nil;
                         [weakSelf.maskView removeFromSuperview];
                         weakSelf.maskView = nil;
                     }];
}

- (void)animationForView:(UIView*)view origin:(CGRect)origin destination:(CGRect)dest{
    __weak UIView *weakView = view;
    view.frame = origin;
    [UIView animateWithDuration:0.2
                     animations:^{
                         weakView.frame = dest;
                     }
                     completion:^(BOOL finished){}];
}

@end
