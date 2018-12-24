//
//  ViewController.swift
//  HideBarViewSample
//
//  Created by Takao Horiguchi on 2018/10/17.
//  Copyright © 2018 Takao Horiguchi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIScrollViewDelegate, HideBarScrollView, UIGestureRecognizerDelegate {
    
    var isBarHidden: Bool = false
    var isBarAnimating: Bool = false
    var tabBarFrameOrigin: CGRect!
    var scrollBeginingPoint: CGPoint?
    
    var webView: WKWebView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        tabBarFrameOrigin = tabBarController?.tabBar.frame
                
        // for sample
        webView = WKWebView(frame:CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height))
        let url = URL(string: "https://github.com/takaoh717/HideBarView")!
        webView.load(URLRequest(url: url))
        view.addSubview(webView)
        webView.scrollView.delegate = self  
        
        // hide when tap gesture
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tapGesture.delegate = self
        webView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            hiddenBar(!isBarHidden)
        }
    }
    
    // is hide status bar
    override var prefersStatusBarHidden: Bool {
        return hasSafeArea ? false : isBarHidden
    }
    
    // animation type of status bar hidden
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView)
    }
    
    // hide bar when scroll    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging(scrollView)
    }
    
    // don't hide status bar if device has safearea
    public var hasSafeArea: Bool {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            guard let top = topPadding, let bottom = bottomPadding else { return false }
            return top > 0 && bottom > 0
        } else {
            return false
        }
    }
}
