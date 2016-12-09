//
//  DetailToGridTransition.m
//  Flickroso
//
//  Created by Sahil Chaddha on 09/12/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "DetailToGridTransition.h"
#import "GridViewController.h"
#import "DetailViewController.h"
#import "GridCollectionViewCell.h"
#import "DetailCollectionViewCell.h"

@implementation DetailToGridTransition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    GridViewController *toViewController = (GridViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    DetailViewController *fromViewController = (DetailViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [fromViewController hideDetails];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    DetailCollectionViewCell *cell = (DetailCollectionViewCell*)[fromViewController.detailCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.selectedIndex inSection:0]];
    
    
    UIImageView *cellImageSnapshot = [[UIImageView alloc]init];
    cellImageSnapshot.image = cell.imgView.image;
    cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
    cellImageSnapshot.frame = [containerView convertRect:cell.imgView.frame fromView:cell.imgView.superview];
    
    cell.imgView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];
    
    GridCollectionViewCell *gridCell = (GridCollectionViewCell*)[toViewController.gridView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromViewController.selectedIndex inSection:0]];
    
    CGRect frame = [containerView convertRect:gridCell.imgView.frame fromView:gridCell.imgView.superview];
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        cellImageSnapshot.frame = frame
        ;
    } completion:^(BOOL finished) {
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
