//
//  GridToDetailTransition.m
//  Flickroso
//
//  Created by Sahil Chaddha on 09/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "GridToDetailTransition.h"
#import "GridViewController.h"
#import "DetailViewController.h"
#import "GridCollectionViewCell.h"

@implementation GridToDetailTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    GridViewController *fromViewController = (GridViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DetailViewController *toViewController = (DetailViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    GridCollectionViewCell *cell = (GridCollectionViewCell*)[fromViewController.gridView cellForItemAtIndexPath:[[fromViewController.gridView indexPathsForSelectedItems] firstObject]];
    
    
    UIImageView *cellImageSnapshot = [[UIImageView alloc]init];
    cellImageSnapshot.image = cell.imgView.image;
    cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
    cellImageSnapshot.frame = [containerView convertRect:cell.imgView.frame fromView:cell.imgView.superview];
    
    cell.imgView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.detailCollectionView.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];
    
    CGRect frame = [containerView convertRect:toViewController.detailCollectionView.frame fromView:toViewController.view];
    
    frame.origin.y +=20;
    frame.size.height -=20;
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        cellImageSnapshot.frame = frame
        ;
    } completion:^(BOOL finished) {
        toViewController.detailCollectionView.hidden = NO;
        cell.hidden = NO;
        cell.imgView.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}
@end
