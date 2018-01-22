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
#import "MaterialProgressView.h"
#import "supplemental/BottomSheetDummyCollectionViewController.h"
#import "supplemental/BottomSheetSupplemental.h"

@interface BottomSheetAnimationSyncExample (AnimationDelegate)
    <MDCBottomSheetPresentationControllerDelegate, UICollectionViewDelegate>
@end

@implementation BottomSheetAnimationSyncExample {
  MDCProgressView *_presentationProgressView;
  MDCProgressView *_stateProgressView;
  MDCProgressView *_scrollProgressView;
}

- (void)presentBottomSheet {

  BottomSheetDummyCollectionViewController *viewController =
      [[BottomSheetDummyCollectionViewController alloc] initWithNumItems:100];
  viewController.collectionView.delegate = self;

  _presentationProgressView = [[MDCProgressView alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
  [viewController.view addSubview:_presentationProgressView];

  _stateProgressView = [[MDCProgressView alloc] initWithFrame:CGRectMake(100, 130, 200, 20)];
  [viewController.view addSubview:_stateProgressView];

  _scrollProgressView = [[MDCProgressView alloc] initWithFrame:CGRectMake(100, 160, 200, 20)];
  [viewController.view addSubview:_scrollProgressView];

  MDCBottomSheetTransition *transition = [[MDCBottomSheetTransition alloc] init];
  transition.trackingScrollView = viewController.collectionView;
  transition.bottomSheetPresentationDelegate = self;

  viewController.mdm_transitionController.transition = transition;
  [self presentViewController:viewController animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat scrollHeight = scrollView.contentSize.height - scrollView.frame.size.height;
  scrollHeight = MAX(1.0f, scrollHeight);

  _scrollProgressView.progress = (float)(scrollView.contentOffset.y / scrollHeight);
}

- (void)bottomSheetPresentationController:(nonnull MDCBottomSheetPresentationController *)bottomSheet
               syncAnimationForTransition:(nonnull MDMMotionAnimator *)animator
                               presenting:(BOOL)presenting
                                 duration:(CGFloat)duration {
  NSLog(@"Transition to %@ over %.2f seconds", presenting ? @"presented" : @"dismissed", duration);
  _presentationProgressView.progress = presenting ? 1.f : 0.f;
}

- (void)bottomSheetPresentationController:(MDCBottomSheetPresentationController *)bottomSheet
              syncAnimationForStateChange:(MDMMotionAnimator *)animator
                                     from:(MDCBottomSheetState)from
                                       to:(MDCBottomSheetState)to
                                 duration:(CGFloat)duration {
  NSLog(@"Transition from %lud to %lud over %.2f seconds", (unsigned long)from, (unsigned long)to, duration);
  _stateProgressView.progress = to / 2.f;
}

@end
