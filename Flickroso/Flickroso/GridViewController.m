//
//  GridViewController.m
//  Flickroso
//
//  Created by Sahil Chaddha on 08/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "GridViewController.h"
#import "GridCollectionViewCell.h"
#import "WebServiceClient.h"
#import "AppHelper.h"
#import "FeedPhotoModel.h"
#import "DetailViewController.h"
#import "GridToDetailTransition.h"

@interface GridViewController ()
{
    NSMutableArray *photosData;
}

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self fetchPhotos];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)initView {
    photosData = [[NSMutableArray alloc]init];
    [self.gridView setHidden:YES];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPhotos {
    [WebServiceClient getPhotosWithSuccess:^(NSArray *photos) {
        [self photosDidLoaded:photos];
    } failure:^(NSError *error) {
        NSLog(@"Error Occured : %@",[error description]);
        [self fetchPhotos];
    }];
}

- (void)photosDidLoaded:(NSArray *)pics {
    [photosData addObjectsFromArray:pics];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gridView reloadData];
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.gridView setHidden:NO];

    });
}

#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [photosData count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridCell" forIndexPath:indexPath];
    
    [AppHelper animateImageView:cell.imgView withUrl:[(FeedPhotoModel*)[photosData objectAtIndex:indexPath.row] imageUrl]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
        NSIndexPath *selectedIndexPath = [[self.gridView indexPathsForSelectedItems] firstObject];
        
        if (selectedIndexPath != nil) {
            DetailViewController *secondViewController = segue.destinationViewController;
            secondViewController.selectedIndex = (int)selectedIndexPath.row;
            secondViewController.photosArray = [[NSArray alloc] initWithArray:photosData];
            secondViewController.delegate = self;
        }
    }

}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[DetailViewController class]]) {
        return [[GridToDetailTransition alloc] init];
    }
    else {
        return nil;
    }
}

#pragma mark - DetailViewControllerDelegate

- (void)selectedIndexChanged:(int)selectedIndex
{
    [self.gridView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}
@end
