//
//  ImageCell.m
//  HNRuMi
//
//  Created by 韩亚周 on 15/11/3.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        self.imageCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_imageCollectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"imageCell"];
        _imageCollectionView.delegate=self;
        _imageCollectionView.dataSource=self;
        _imageCollectionView.scrollsToTop = NO;
        _imageCollectionView.showsHorizontalScrollIndicator=NO;
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageCollectionView.allowsMultipleSelection = NO;
        [self.contentView addSubview:_imageCollectionView];
        
        [self.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_imageCollectionView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                         constant:8]];
        [self.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_imageCollectionView
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeLeft
                                         multiplier:1.0
                                         constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_imageCollectionView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:1.0
                                         constant:-20]];
        _collectionViewHeight = [NSLayoutConstraint
                                 constraintWithItem:_imageCollectionView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.contentView
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:-16];
        [self.contentView addConstraint:_collectionViewHeight];
        
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [_imageCollectionView reloadData];
}

#pragma mark -
#pragma mark UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    if ([_imageArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        cell.backgroundImageView.image = _imageArray[indexPath.row];
        cell.hiddenDeleteButton = YES;
    }else{
        cell.hiddenDeleteButton = NO;
        ALAsset *result = _imageArray[indexPath.row];
        cell.backgroundImageView.image = [UIImage imageWithCGImage: result.thumbnail];
    }
    cell.deleteButtonHandle = ^(ImageCollectionCell *imageCell,UIButton *sender){
        dispatch_async(dispatch_get_main_queue(), ^{
            _deleteImageHandle(self, collectionView, imageCell, indexPath);
            
        });
    };
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionCell *cell = (ImageCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row == [_imageArray count]-1 &&
        [_imageArray.lastObject isKindOfClass:[UIImage class]]) {
        _itemClickedHandler(self,collectionView,cell);
    }
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width-20-14)/3, ([[UIScreen mainScreen] bounds].size.width-20-14)/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 7.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7.0f;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    CGFloat imageHeight = ([[UIScreen mainScreen] bounds].size.width-20-14)/3;
    if (self.imageArray.count==0) {
        totalHeight += 0;
    }else if (self.imageArray.count<4){
        totalHeight += imageHeight;
    }else if (4 <= self.imageArray.count && self.imageArray.count <7){
        totalHeight += imageHeight*2+7;
    }else if (7 <= self.imageArray.count && self.imageArray.count <10){
        totalHeight += imageHeight*3+14;
    }else{
        NSAssert(self.imageArray, @"CircleCell.imageArray数组中最多允许有九个符合规格的元素");
    }
    totalHeight += 8+8;
    return CGSizeMake(size.width, totalHeight);
}
@end
