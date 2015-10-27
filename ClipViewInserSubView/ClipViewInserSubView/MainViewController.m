//
//  MainViewController.m
//  ClipViewInserSubView
//
//  Created by zt on 15/10/26.
//  Copyright © 2015年 justzt. All rights reserved.
//

#import "MainViewController.h"
#import "SCScreenSnapshotSpliter.h"

@interface MainViewController ()
@property (nonatomic, assign) BOOL isSplit;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *spaseView;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIImageView *bottomImageView;
@property (nonatomic,assign) CGPoint splitPoint;
@end

@implementation MainViewController


- (IBAction)buttonAction:(id)sender {
    
    CGPoint center = [(UIButton*)sender center];
    center.y += 18;
    UIView *view = [[SCScreenSnapshotSpliter sharedSpliter] splitScreenWithPointer:center currentView:self.view spaseHeight:130];
    
    CGFloat marginLeft = 22;
    for (int row=0; row<3; row++) {
        for (int column=0; column<4; column++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(marginLeft+column*marginLeft+column*50, 10+row*10+row*30, 50, 30);
            button.backgroundColor = [UIColor blueColor];
            [view addSubview:button];
        }
    }
}
@end
