/*
 Copyright 2017-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <MotionAnimator/MotionAnimator.h>
#import <MotionTransitioning/MotionTransitioning.h>

#import "MaterialBottomSheet.h"
#import "supplemental/BottomSheetDummyCollectionViewController.h"
#import "supplemental/BottomSheetSupplemental.h"

@interface BottomSheetAnimationSyncExample (AnimationDelegate)
    <MDCBottomSheetTransitionAnimationDelegate, UICollectionViewDelegate>
@end

@implementation BottomSheetAnimationSyncExample

- (void)presentBottomSheet {
  BottomSheetDummyCollectionViewController *viewController =
      [[BottomSheetDummyCollectionViewController alloc] initWithNumItems:100];
  viewController.collectionView.delegate = self;

  MDCBottomSheetTransition *transition = [[MDCBottomSheetTransition alloc] init];
  transition.trackingScrollView = viewController.collectionView;
  transition.animationDelegate = self;

  viewController.mdm_transitionController.transition = transition;
  [self presentViewController:viewController animated:YES completion:nil];

  // Sync presentation/dismissal
  // MDCBottomSheetTransition -> MDCBottomSheetPresentationController -> startWithContext

  // Sync changing between half-height and full-height
  // MDCBottomSheetTransition -> MDCBottomSheetPresentationController -> MDCSheetContainerView
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"Scrolled %.2f", scrollView.contentOffset.y);
}

- (void)bottomSheetTransition:(MDCBottomSheetTransition *)transition
                syncAnimation:(MDMMotionAnimator *)animator
                   presenting:(BOOL)presenting
                     duration:(CGFloat)duration {
  NSLog(@"Transition to %@ over %.2f seconds", presenting ? @"presented" : @"dismissed", duration);
}

@end
