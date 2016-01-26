//
//  ImageCollectionCell.h
//  HNRuMi
//
//  Created by 韩亚周 on 15/11/3.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class ImageCollectionCell;

typedef void (^deleteButtonClicked) (ImageCollectionCell *, UIButton *);

/*!在发布图片的页面哦，从相册选出图片，通过此cell进行展示(单个)*/
@interface ImageCollectionCell : UICollectionViewCell

/*!负责展示图片*/
@property (nonatomic, strong) UIImageView        *backgroundImageView;
/*!删除按钮*/
@property (nonatomic, strong, readonly) UIButton *deleteButton;
/*!负责删除按钮的展示和隐藏*/
@property (nonatomic, assign) BOOL               hiddenDeleteButton;
/*!删除按钮被点击的回调*/
@property (nonatomic, copy) deleteButtonClicked  deleteButtonHandle;

@end
