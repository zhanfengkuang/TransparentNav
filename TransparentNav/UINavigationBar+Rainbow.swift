//
//  UINavigationBar+Rainbow.swift
//  Mitures
//
//  Created by Maple on 2018/7/9.
//  Copyright © 2018年 Feng Lun Network Technology (Shang Hai) Co., Ltd. All rights reserved.
//

import UIKit

private var kRainbowAssociatedKey = "kRainbowAssociatedKey"

class Rainbow: NSObject {
    
    private var navigationBar: UINavigationBar!
    
    private var navigationView: UIImageView?
    
    var backgroundColor: UIColor? {
        get {
            return navigationView?.backgroundColor
        }
        
        set {
            guard newValue != nil else {
                navigationBar.setBackgroundImage(nil, for: .default)
                navigationView?.isHidden = true
                return
            }
            if navigationView == nil {
//                navigationBar.setBackgroundImage(UIImage(), for: .default)
//                navigationBar.shadowImage = UIImage()
                navigationView = UIImageView(frame: CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: navigationBar.bounds.width, height: navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height))
                navigationView?.isUserInteractionEnabled = false
                navigationView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                navigationBar.insertSubview(navigationView!, at: 1)
            }
            navigationView?.backgroundColor = newValue
            navigationView?.isHidden = false
        }
    }
    
    var backgroundImage: UIImage? {
        get {
            return navigationView?.image
        }
        
        set {
            backgroundColor = .clear
            navigationView?.image = newValue
        }
    }
    
    init(bar: UINavigationBar) {
        navigationBar = bar
        super.init()
    }
}

extension UINavigationBar {
    var rb: Rainbow {
        get {
            if let rainbow = objc_getAssociatedObject(self, &kRainbowAssociatedKey) as? Rainbow {
                return rainbow
            }
            let rainbow = Rainbow(bar: self)
            objc_setAssociatedObject(self, &kRainbowAssociatedKey, rainbow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return rainbow
        }
    }
}
