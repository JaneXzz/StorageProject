//
//  BasisViewController.m
//  PersonalCenter
//
//  Created by Jane on 2020/3/9.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasisViewController.h"
#import "LoginPublic.h"
#import "UIImage+Extension.h"
 
@interface BasisViewController ()

@property (strong, nonatomic) CAGradientLayer *colorLayer;
@property (assign, nonatomic) BOOL popWhenDismissed;

@end

@implementation BasisViewController

 

#pragma mark - Life Cycle
+ (instancetype)loadViewFromXibOrNot
{
    BasisViewController *instance = nil;
    if ([[NSBundle mainBundle] pathForResource:NSStringFromClass(self) ofType:@"nib"] != nil) {
        instance = [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
        instance.hidesBottomBarWhenPushed = YES;
    } else {
        instance = [[self alloc] init];
        instance.hidesBottomBarWhenPushed = YES;
    }
    return instance;
}
/** 是否隐藏*/
-(void)hiddenNavgation:(BOOL)isHidden{
    [self.navigationController setNavigationBarHidden:isHidden animated:NO];
}

- (void)setupNavgationItemTitleWithLocalizad:(NSString *)string {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = NSLocalizedString(string, nil);
}

- (void)setupNavgationItemTitleWithLocalizad:(NSString *)string itemcolor:(UIColor *)color{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    self.title = NSLocalizedString(string, nil);
}
- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _popWhenDismissed = NO;
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
 
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationItem setHidesBackButton:YES];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [self barButtonItemWithImageName:@"go_back_white" target:self action:@selector(backButtonPressed:)];
    }
}



/**
 创建一个UIBarButtonItem
 
 @param name imageName name规则 name_normal name_pressed
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)name target:(id)target action:(SEL)action{
    UIImage *image = [UIImage imageNamed:name];
    //    UIImage *imagePress = [UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",name]];
    CGRect buttonFrame = CGRectMake(0, 0, 40, 40);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [button setImage:image forState:UIControlStateNormal];
    //    [button setImage:imagePress forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}
- (void)backButtonPressed:(id)sender {
    [self backPreviousVC];
}
-(void)backPreviousVC {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_popWhenDismissed) {
        NSMutableArray* array = [[self.navigationController viewControllers] mutableCopy];
        [array removeObjectIdenticalTo:self];
        self.navigationController.viewControllers = array;
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)popMeWhenDismissed
{
    _popWhenDismissed = YES;
}

- (void)dealloc
{
    NSLog(@"%@-释放了",self.class);
}
#pragma mark - Private Method
#pragma mark - 支持横竖屏方法

- (BOOL)shouldAutorotate {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
//    NSString *name = [TXSakuraManager getSakuraCurrentName];
//    if ([name isEqualToString:@"simple"]||[name isEqualToString:@"default"]) {
//        return UIStatusBarStyleLightContent;
//    }
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

@end
