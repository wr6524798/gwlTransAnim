//
//  ImageMaskTransition.swift
//  gwlTransformAnim
//
//  Created by wangrui on 16/8/30.
//  Copyright © 2016年 tools. All rights reserved.
//

import UIKit

class ImageMaskTransition: NSObject {
    var animator:ImageMaskAnimator
    
    init(fromImageView:UIImageView , toImageView:UIImageView) {
        self.animator = ImageMaskAnimator()
        animator.fromImageView = fromImageView
        animator.toImageView = toImageView
        super.init()
    }
}

extension ImageMaskTransition : UINavigationControllerDelegate,UIViewControllerTransitioningDelegate{
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Pop:
            self.animator.transitionType = ImageMaskTransitionType.Dismiss
            return self.animator
        case .Push:
            self.animator.transitionType = ImageMaskTransitionType.Present
            return self.animator
        default:
            return nil
        }
    }
    
    // 返回present的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.animator.transitionType = ImageMaskTransitionType.Present
        return self.animator
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.transitionType = ImageMaskTransitionType.Dismiss
        return self.animator
    }
}
