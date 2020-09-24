//
//  ExampleDragDropCollectionViewsViewController.h
//  Example
//
//  Created by Jose Manuel Sánchez Peñarroja on 25/08/14.
//  Copyright (c) 2014 José Manuel Sánchez. All rights reserved.
//

#import <BMF/BMFViewController.h>

@interface ExampleDragDropCollectionViewsViewController : BMFViewController

@property (weak, nonatomic) IBOutlet UICollectionView *leftCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;

@end
