//
//  ImageMaskAnimator.swift
//  gwlTransformAnim
//
//  Created by wangrui on 16/8/30.
//  Copyright © 2016年 tools. All rights reserved.
//

import UIKit

enum ImageMaskTransitionType {
    case Present
    case Dismiss
}

class ImageMaskAnimator: NSObject {
    
    var transitionType : ImageMaskTransitionType = .Present
    var imageView : UIImageView!
    
    var maskContentView : UIImageView!
    // 点击的图片
    var fromImageView : UIImageView!
    // 将要成为的图片
    var toImageView : UIImageView!
    
}

extension ImageMaskAnimator : UIViewControllerAnimatedTransitioning{
    // 动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.transitionType == .Present ? 1.6 : 1.3
    }
    
    // 实际的动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 当两个视图控制器之间的过度开始时，当前已经存在的视图将会被添加到containView上，而新的视图控制器的视图也在此时被创建，只是不可见而已，接下来就是我们的任务了，将新的视图添加到contrinerView上，默认情况下，过度动画执行完以后，旧视图会在containerView上移除
        let containView  = transitionContext.containerView()!
        print("\(fromView)" + "\(containView)" + "\(toView)" + "123213123123123")
        let frame = UIScreen.mainScreen().bounds
        
        // 动画过程中整个背景图
        maskContentView = UIImageView(frame: frame)
        maskContentView.backgroundColor = UIColor.whiteColor()
        
        if self.transitionType == .Present {
            maskContentView.frame = containView.bounds
            containView.addSubview(self.maskContentView)
            
            let currentFromImageView = self.fromImageView
            let adjustFromRect = currentFromImageView.convertRect(currentFromImageView.bounds, toView: containView)
            
            let currentToImageView = self.toImageView!
            let adjustToRect = currentToImageView.convertRect(currentToImageView.bounds, toView: containView)
            
            imageView = UIImageView(frame: adjustFromRect)
            imageView.image = currentFromImageView.image
            containView.addSubview(imageView)
            
            imageView.layer.shadowColor = UIColor.blackColor().CGColor
            imageView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
            imageView.layer.shadowRadius = 10.0
            // 给shadowOpacity一个大于默认值(0)的值，阴影就可以显示在任意图层之下
            imageView.layer.shadowOpacity = 0.8
            
            UIView.animateWithDuration(0.5 , animations: { 
                self.imageView.frame = adjustToRect
                self.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }, completion: { (finish) in
                    [UIView .animateWithDuration(0.3, animations: { 
                        self.imageView.transform = CGAffineTransformIdentity
                        self.imageView.layer.shadowOpacity = 0.0
                        }, completion: { (finished) in
                            containView.addSubview(toView)
                            containView.bringSubviewToFront(self.imageView)
                            let adjustFrame = self.imageView.convertRect(self.imageView.bounds, toView: self.maskContentView)
                            toView.maskFrom(adjustFrame, duration: 0.8 / 1.6 ,complete: {
                                self.maskContentView.removeFromSuperview()
                                self.imageView.removeFromSuperview()
                                self.maskContentView = nil
                                self.imageView = nil
                                transitionContext.completeTransition(true)
                            })
                    })]
            })
        }else{
            maskContentView.frame = containView.bounds
            containView.addSubview(self.maskContentView)
            
            let fromImageView = self.fromImageView
            let toImageView = self.toImageView!
            let adjustFromRect = fromImageView.convertRect(fromImageView.bounds, toView: containView)
            let adjustToRect = toImageView.convertRect(toImageView.bounds, toView: containView)
            imageView = UIImageView(frame:adjustToRect)
            imageView.image = fromImageView.image
            containView.addSubview(imageView)
            
            containView.bringSubviewToFront(self.imageView)
            containView.sendSubviewToBack(maskContentView)
            let adjustFrame = self.imageView.convertRect(self.imageView.bounds, toView: self.maskContentView)
            fromView.maskTo(adjustFrame, duration: 0.8 / 1.3 ,complete: {
                self.imageView.layer.shadowColor = UIColor.blackColor().CGColor
                self.imageView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
                self.imageView.layer.shadowRadius = 10.0
                self.imageView.layer.shadowOpacity = 0.8
                UIView.animateWithDuration(0.5 / 1.3, animations: {
                    self.imageView.frame = adjustFromRect
                }) { (finished) in
                    self.maskContentView.removeFromSuperview()
                    self.imageView.removeFromSuperview()
                    self.maskContentView = nil
                    self.imageView = nil
                    self.toImageView = nil
                    containView.addSubview(toView)
                    transitionContext.completeTransition(true)
                }
                
            })
        }
    }
}