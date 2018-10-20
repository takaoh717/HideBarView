//
//  HideBarScrollView.swift
//  HideBarViewSample
//
//  Created by Takao Horiguchi on 2018/10/17.
//  Copyright © 2018 Takao Horiguchi. All rights reserved.
//

import UIKit

public protocol HideBarScrollView: class {
    var isBarHidden: Bool { get set }
    var isBarAnimating: Bool { get set }
    var tabBarFrameOrigin: CGRect! { get set }
    var scrollBeginingPoint: CGPoint? { get set }
}

extension HideBarScrollView where Self: UIViewController, Self: UIScrollViewDelegate {
    
    public func hiddenBar(_ isHidden: Bool) {
        guard !isBarAnimating else { return }
        isBarAnimating = true
        isBarHidden = isHidden
        
        // hide status bar
        self.setNeedsStatusBarAppearanceUpdate()
        
        // hide navigation bar
        self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        
        // tab bar frame for animate
        guard var tabBarFrame = self.tabBarFrameOrigin else { return }
        
        // calculate tab bar frame
        if isHidden {
            tabBarFrame.origin.y = self.tabBarFrameOrigin.origin.y + self.tabBarFrameOrigin.size.height + self.navigationController!.navigationBar.frame.height
        }
        
        UIView.animate(withDuration: Double(UINavigationController.hideShowBarDuration), animations: { [weak self] in
            guard let `self` = self else { return }
            
            // hide tab bar
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: tabBarFrame.minX, y: tabBarFrame.minY)
            
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.isBarAnimating = false
        })
    }
    
    public func willBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginingPoint = scrollView.contentOffset
    }
    
    public func didScroll(_ scrollView: UIScrollView) {
        guard let scrollBeginingPoint = self.scrollBeginingPoint else { return }
        let currentPoint = scrollView.contentOffset
        // バーが現在表示されている, 下にスクロールした場合, topではない場合
        if !isBarHidden, scrollBeginingPoint.y < currentPoint.y, currentPoint.y > 0, scrollView.isDragging {
            self.hiddenBar(true)
        }
        // バーが現在非表示, 上にスクロールした場合, 最下部ではない場合
        if isBarHidden, scrollBeginingPoint.y > currentPoint.y, currentPoint.y < scrollView.contentSize.height, scrollView.isDragging {
            self.hiddenBar(false)
        }
    }
    
}
