//
//  UIViewControllerExt.swift
//  TransparentNav
//
//  Created by Maple on 2018/12/7.
//  Copyright © 2018 Jarmon. All rights reserved.
//

import UIKit

let StatusBarHeight = UIApplication.shared.statusBarFrame.height
let TopBarHeight = StatusBarHeight + 44

extension UIViewController {
    // 根据scroll view offset 改变导航栏item的透明度
    func dynamicTransparent(_ scrollView: UIScrollView,
                            color: UIColor = .white,
                            offset: CGFloat = TopBarHeight,
                            block: ((CGFloat) -> Void)? = nil) {
        scrollView.scrollDirction = { [weak self] _ in
            guard let weakSelf = self else { return }
            let contentOffset = scrollView.contentOffset
            weakSelf.translucentBar()
            var scale = contentOffset.y / offset
            scale = RangeValue(value: scale, max: 1, min: 0)
            block?(scale)
            let bgColor = color.withAlphaComponent(scale)
            weakSelf.setNavigationRBColor(bgColor)
        }
        
    }
    
    func cleanTransparent() {
        clearNavigationRBColor()
        translucentBarDefault()
    }
    
    /// 将导航栏设置为透明
    func translucentBar() {
        setNavigationBarBgColor(.clear)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.cleanBottomLine()
    }
    
    /// 无半透明效果 记得一定要复原
    func setNavigationRBColor(_ color: UIColor?) {
        navigationController?.navigationBar.rb.backgroundColor = color
    }
    
    /// 将透明的导航栏恢复默认
    func translucentBarDefault() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.bottomLineDefault()
    }
    
    func clearNavigationRBColor() {
        navigationController?.navigationBar.rb.backgroundColor = nil
    }
    
    /// isTranslucent = true 背景色会有半透明效果
    func setNavigationBarBgColor(_ color: UIColor) {
        guard let bar = navigationController?.navigationBar else { return }
        if bar.isTranslucent {
            bar.backgroundColor = color
        } else {
            if color == UIColor.clear { // 设置背景透明
                bar.setBackgroundImage(UIImage(), for: .default)
            } else {
                let image = UIImage.color(color, size: bar.bounds.size)
                // UIBarMetrics default: 横竖屏都显示 compact: 横屏显示
                bar.setBackgroundImage(image, for: .default)
            }
        }
    }
    
    enum Position { case left, right }
    
    func setItems(_ postion: Position, items: [UIBarButtonItem]) {
        switch postion {
        case .left:
            navigationItem.leftBarButtonItems = items
        case .right:
            navigationItem.rightBarButtonItems = items
        }
    }
    
    func adjustsInsets(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension UINavigationController {
    /// 该方式也能清除底部的黑线
    func cleanBottomLine() {
        navigationBar.shadowImage = UIImage()
    }
    
    /// 恢复底部的黑线
    func bottomLineDefault() {
        navigationBar.shadowImage = nil
    }
}

extension UIImage {
    /// 颜色绘制图片
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片大小
    /// - Returns: 所绘制图片
    static func color(_ color: UIColor, size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 { return nil }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    // 修改图片透明
    func setAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext(),
        area = Rect(point: .zero, size: size)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.size.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        guard cgImage != nil else { return self }
        context?.draw(cgImage!, in: area)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }
}

func Rect(point: CGPoint, size: CGSize) -> CGRect {
    return CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
}


/// 某个范围值
func RangeValue<Element: Comparable>(value: Element,
                                     max a: Element,
                                     min b: Element) -> Element {
    return min(a, max(b, value))
}
