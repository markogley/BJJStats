//
//  MOModalSegue.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-10-23.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOModalSegue.h"
#import "UIViewController+MJPopupViewController.h"

@implementation MOModalSegue


- (void)perform {
    [self.sourceViewController presentPopupViewController:self.destinationViewController animationType:MJPopupViewAnimationFade];
}

//- (void)perform
//{
//    
//    UIViewController * sourceViewController = self.sourceViewController;
//    UIViewController * modalViewController = self.destinationViewController;
//    UINavigationController * navCon = sourceViewController.navigationController;
//    
//    UIWindow * mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
//    
//    [mainWindow addSubview:modalViewController.view];
//    
//    CGPoint modalCenter = modalViewController.view.center;
//    
//    modalCenter.y += [[UIScreen mainScreen] bounds].size.height;
//    
//    modalViewController.view.center = modalCenter;
//    
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//        modalViewController.view.center = sourceViewController.view.center;
//    
//    } completion:^(BOOL finished) {
//        
//        [modalViewController.view removeFromSuperview];
//        
//        UIModalPresentationStyle prevStyle = navCon.modalPresentationStyle;
//        
//        [navCon setModalPresentationStyle:UIModalPresentationCurrentContext];
//        
//        [sourceViewController setModalPresentationStyle:UIModalPresentationCustom];
//        
//        [sourceViewController presentViewController:modalViewController animated:YES completion:nil];
//        
//        [navCon setModalPresentationStyle:prevStyle];
//    }];
//}

@end

