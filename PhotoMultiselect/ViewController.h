//
//  ViewController.h
//  PhotoMultiselect
//
//  Created by 韩亚周 on 16/1/26.
//  Copyright (c) 2016年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YYPhotoAlbumViewController.h"
#import "UIViewController+Present.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView                 *pictureTableView;
@property (nonatomic, strong) NSMutableArray              *currentImageArray;

@end

