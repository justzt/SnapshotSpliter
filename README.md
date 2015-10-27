# SnapshotSpliter
ios屏幕截屏分割器

### 如何使用
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

MIT License
