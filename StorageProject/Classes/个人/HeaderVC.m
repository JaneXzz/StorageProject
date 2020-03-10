//
//  HeaderVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "HeaderVC.h"
#import "LoginPublic.h"
#import "HeaderCell.h"
#import "HorizontallyPageableFlowLayout.h"
#import "UserManager.h"
#import "UserModel.h"
#import "DBServiceUser.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

#define HCount 10//横向排列个数


@interface HeaderVC ()<HeaderCellDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *selectHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (nonatomic, strong) NSString *currentImageStr;
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation HeaderVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    self.view.backgroundColor = RGB0X(0xf1f1f1);
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.bgView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    self.bgView.hidden = YES;
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.selectHeaderView];
    self.selectHeaderView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    [self makeCollection];
    self.page.numberOfPages = 2;
    
    NSString *imageStr = [NSString isBlankString:self.userModel.iconUrl]?@"account_head_portrait5":self.userModel.iconUrl;
    
//    self.headerImageView.image = [UIImage imageNamed:imageStr];
    
    UIImage *image = [UIImage imageNamed:imageStr];
    if (image) {
       self.headerImageView.image = image;
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }
    
}

-(void)makeCollection{
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    HorizontallyPageableFlowLayout *layout = [[HorizontallyPageableFlowLayout alloc] initWithItemCountPerRow:5 maxRowCount:2];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((SCREENWIDTH-30)/5, (self.collectionView.frame.size.height)/2);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellWithReuseIdentifier:@"HeaderCell"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"HeaderCell";
    HeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    NSString *imageStr = [NSString stringWithFormat:@"account_head_portrait%ld",indexPath.row+1];
    cell.imageName = imageStr;
    [cell.imageViewButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    return cell;
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    NSString *imageStr = [NSString stringWithFormat:@"account_head_portrait%ld",indexPath.row+1];
//    NSLog(@"dsds = %@",imageStr);
//}


- (void)changePicture:(NSString *)currentImageName{
    self.currentImageStr = currentImageName;
    UIImage *image = [UIImage imageNamed:currentImageName];
    if (image) {
       self.headerImageView.image = image;
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:currentImageName]];
    }
    NSLog(@"image = %@",currentImageName);
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    //获得页码
    CGFloat doublePage = scrollView.contentOffset.x/(SCREENWIDTH-30);
    int intPage = (int)(doublePage +0.5);
    //设置页码
    self.page.currentPage= intPage;
}

- (IBAction)didClickCancel:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.selectHeaderView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
    }];
}

- (IBAction)didClickSaveButton:(id)sender {
    
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getModifyUserInformationAccessToken:self.userModel.accessToken content:self.currentImageStr type:@"icon" completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        weakself.userModel.iconUrl = weakself.currentImageStr;
        [[DBServiceUser shareInstance] updateUserModel:weakself.userModel];
        weakself.userModel = [[DBServiceUser shareInstance] getUserAlldata];
        weakself.refreshBlock();
        [[UIApplication sharedApplication].keyWindow makeToast:@"头像修改成功" duration:KDuration position:CSToastPositionCenter];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
     
    [self didClickCancel:nil];
}

- (IBAction)didClickHeader:(UIButton *)sender {
    self.bgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectHeaderView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    } completion:nil];
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

 - (IBAction)didClickGoback:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
 }

-(UserModel *)userModel{
    if (!_userModel) {
         _userModel = [[DBServiceUser shareInstance] getUserAlldata];
    }
    return _userModel;
}

@end
