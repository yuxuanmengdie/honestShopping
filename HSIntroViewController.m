//
//  HSIntroViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-26.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSIntroViewController.h"
#import "EAIntroView.h"

@interface HSIntroViewController ()<
EAIntroDelegate>


@property (strong, nonatomic) IBOutlet EAIntroView *introView;

@end

@implementation HSIntroViewController

static NSString *const kIntroViewToMainBar = @"IntroViewToMainTabBar";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showIntroWithSeparatePagesInitAndPageCallback];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)showIntroWithSeparatePagesInitAndPageCallback {
    
    
    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"Hello world";
//    page1.desc = @"1";
    page1.bgImage = [UIImage imageNamed:@"start_first"];
//    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
//    page1.bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start_first"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"This is page 2";
//    page2.desc = @"2";
    page2.bgImage = [UIImage imageNamed:@"start_second"];
//    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
//    page2.bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start_second"]];
    page2.onPageDidAppear = ^{
        NSLog(@"Page 2 did appear block");
    };
    
    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"This is page 3";
//    page3.desc = @"3";
    page3.bgImage = [UIImage imageNamed:@"start_third"];
//    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
//    page3.bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start_third"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
//    page4.title = @"This is page 4";
//    page4.desc = @"4";
    page4.bgImage = [UIImage imageNamed:@"start_fourth"];
//    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
//    page4.bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"start_fourth"]];
    
    _introView = [[EAIntroView alloc] initWithFrame:self.view.bounds];
    [_introView setDelegate:self];
//    [_introView layoutIfNeeded];
    [_introView setSkipButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    _introView.skipButton.contentEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 8);
    [_introView.skipButton setTitle:@"体验新版" forState:UIControlStateNormal];
    [_introView.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_introView.skipButton setBackgroundImage:[public ImageWithColor:kAPPTintColor] forState:UIControlStateNormal];
    _introView.skipButton.layer.masksToBounds = YES;
    _introView.skipButton.layer.cornerRadius = 5.0;
//    CGPoint center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, _introView.pageControlY - 40);
    [_introView.skipButton sizeToFit];
//    _introView.center = center;
     _introView.skipButtonAlignment = EAViewAlignmentCenter;
//    _introView.backgroundColor = [UIColor blueColor];
    
    // show skipButton only on 3rd page + animation
//    _introView.skipButton.alpha = 0.f; // 0.f;
//    _introView.skipButton.enabled = NO; // NO
    _introView.showSkipButtonOnlyOnLastPage = YES;
    _introView.useMotionEffects = NO;
    _introView.backgroundColor = [UIColor whiteColor];
    
//    [_introView.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
//    page4.onPageDidAppear = ^{
//        _introView.skipButton.enabled = YES;
//        [UIView animateWithDuration:0.3f animations:^{
//            _introView.skipButton.alpha = 1.f;
//        }];
//    };
//    page4.onPageDidDisappear = ^{
//        _introView.skipButton.enabled = NO;
//        [UIView animateWithDuration:0.3f animations:^{
//            _introView.skipButton.alpha = 0.f;
//        }];
//    };
    
    
    
    [_introView setPages:@[page1,page2,page3,page4]];
    
    [_introView showInView:self.view animateDuration:0.3];
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
//    [self performSegueWithIdentifier:kIntroViewToMainBar sender:self];
    if (self.introViewFinishedBlock) {
        self.introViewFinishedBlock();
    }
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
