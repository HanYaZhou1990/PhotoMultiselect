//
//  ImageCell.h
//  HNRuMi
//
//  Created by 韩亚周 on 15/11/3.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCollectionCell.h"

@class ImageCell;

typedef void (^CollectionItemClicke) (ImageCell *, UICollectionView *, ImageCollectionCell *);
typedef void (^DeleteImage) (ImageCell *, UICollectionView *, ImageCollectionCell *, NSIndexPath *);

/*!展示从相册取出来的所有图片*/
@interface ImageCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/*!图片展示的承载着*/
@property (nonatomic, strong) UICollectionView                  *imageCollectionView;
/*!所有的图片，实际是ALAsset类型，不可直接当做图片展示*/
@property (nonatomic, strong) NSArray                           *imageArray;
/*!imageCollectionView的高度，目前没用到，外部如果需要用到或者修改，删除readonly即可*/
@property (nonatomic, strong, readonly) NSLayoutConstraint      *collectionViewHeight;
/*!图片被点击时候的回调*/
@property (nonatomic, copy) CollectionItemClicke                itemClickedHandler;
/*!图片上删除按钮被点击的回调*/
@property (nonatomic, copy) DeleteImage                         deleteImageHandle;

@end
