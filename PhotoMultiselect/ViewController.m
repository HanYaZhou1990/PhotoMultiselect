//
//  ViewController.m
//  PhotoMultiselect
//
//  Created by 韩亚周 on 16/1/26.
//  Copyright (c) 2016年 韩亚周. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentImageArray = [@[[UIImage imageNamed:@"addImage.png"]] mutableCopy];
    
    
    _pictureTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_pictureTableView registerClass:[ImageCell class ] forCellReuseIdentifier:@"image"];
    _pictureTableView.dataSource = self;
    _pictureTableView.delegate = self;
    _pictureTableView.tableFooterView = [UIView new];
    _pictureTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_pictureTableView];
    
    _currentImageArray = [@[[UIImage imageNamed:@"addImage.png"]] mutableCopy];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_pictureTableView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_pictureTableView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_pictureTableView
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeft
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_pictureTableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0]];
}
#pragma mark -
#pragma mark UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"image" forIndexPath:indexPath];
    [self settingImageCell:imageCell];
    return imageCell;
}

- (void)settingImageCell:(ImageCell *)imageCell{
    imageCell.imageArray = _currentImageArray;
    __block ViewController *myViewController = self;
    imageCell.itemClickedHandler = ^(ImageCell *cell, UICollectionView *collectionView, ImageCollectionCell *collectionCell){
        YYPhotoAlbumViewController *photoAblum = [[YYPhotoAlbumViewController alloc]init];
        photoAblum.dissmissHandle = ^(YYPhotoAlbumViewController *viewController,NSArray *imageResults){
            [myViewController.currentImageArray insertObjects:imageResults atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [imageResults count])]];
            if ([myViewController.currentImageArray count] == 10) {
                [myViewController.currentImageArray removeLastObject];
            }else{
                /*如果已经有添加图片的item，就不再追加，如果没有继续追加*/
                [self hasAddImage:myViewController.currentImageArray]?:[myViewController.currentImageArray addObject:[UIImage imageNamed:@"addImage.png"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_pictureTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        };
        photoAblum.maxCount = 9;
        photoAblum.currentCount = [_currentImageArray count];
        [self yyPresentViewController:photoAblum animated:YES completion:nil];
    };
    imageCell.deleteImageHandle = ^(ImageCell *cell, UICollectionView *collectionView, ImageCollectionCell *imageCCell, NSIndexPath *myIndexPath){
        [_currentImageArray removeObjectAtIndex:myIndexPath.row];
        [collectionView deleteItemsAtIndexPaths:@[myIndexPath]];
        for ( int i = (int)myIndexPath.row; i < [_currentImageArray count]; i ++) {
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
        }
        [self hasAddImage:myViewController.currentImageArray]?:[myViewController.currentImageArray addObject:[UIImage imageNamed:@"addImage.png"]];
        [cell sizeThatFits:CGSizeMake(MAIN_WIDTH, 0)];
        cell.userInteractionEnabled = NO;
        /*为了保留删除图片的时候的动画，所以设置延迟刷新TableView,时间设置为1/24，为了让用户能看到删除的这个特效,这个时间大于1/24就可以看到特效
         调整userInteractionEnabled，为了防止在刷新之前又做删除操作*/
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1/24), dispatch_get_main_queue(), ^{
            cell.userInteractionEnabled = YES;
            [_pictureTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"image" configuration:^(UITableViewCell *cell) {
        [self settingImageCell:(ImageCell *)cell];
    } enforceFrameLayout:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
#pragma mark -
#pragma mark UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)hasAddImage:(NSMutableArray *)array{
    __block BOOL hasAddImage = YES;
    /*更快捷的删除数组里面的内容以及修改数组里面的内容*/
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            hasAddImage = YES;
            *stop = YES;
        }else{
            hasAddImage = NO;
        }
    }];
    return hasAddImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
