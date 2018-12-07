//
//  UIScrollViewExt.swift
//  Record
//
//  Created by Maple on 2018/9/13.
//  Copyright © 2018年 TanKe. All rights reserved.
//

import UIKit

private var dirctionKey = "scrollDirction"
extension UIScrollView {
    enum ScrollDirction {
        case none
        case right(CGFloat, CGPoint)
        case left(CGFloat, CGPoint)
        case up(CGFloat, CGPoint)
        case down(CGFloat, CGPoint)
    }
    
    typealias ScrollCallBack = (ScrollDirction) -> Void
    
    // MARK: - !!! 注意要清理通知 !!!
    // 这样写还有个弊端是在scrollView 在顶部时, 下拉回弹也会触发该事件
    // 可能造成不可控的问题 (bounces 可以控制该情况, 但动画效果不太友好), !!! 慎用 !!!
    var scrollDirction: ScrollCallBack? {
        set {
            addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
            objc_setAssociatedObject(self, &dirctionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &dirctionKey) as? ScrollCallBack
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
        var dirction: ScrollDirction = .none
        if keyPath == "contentOffset",
            let change = change,
            let newOffset = change[NSKeyValueChangeKey.newKey] as? CGPoint,
            let oldOffset = change[NSKeyValueChangeKey.oldKey] as? CGPoint {
            
            let distanceX = newOffset.x - oldOffset.x,
            distanceY = newOffset.y - oldOffset.y
            
            if distanceX > 0 {
                dirction = .left(abs(distanceX), newOffset)
            } else if distanceX < 0 {
                dirction = .right(abs(distanceX), newOffset)
            } else if distanceY > 0 {
                dirction = .up(abs(distanceY), newOffset)
            } else if distanceY < 0 {
                dirction = .down(abs(distanceY), newOffset)
            } else {
                dirction = .none
            }
        }
        scrollDirction?(dirction)
    }
}


