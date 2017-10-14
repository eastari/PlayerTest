//
//  Extensions.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

extension Timer {
    class func schedule(repeatInterval interval: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }
}

extension Array where Element: Hashable {
    
    func next(item: Element) -> Element? {
        if let index = self.index(of: item), index + 1 <= self.count {
            return index + 1 == self.count ? self[0] : self[index + 1]
        }
        return nil
    }
    
    func prev(item: Element) -> Element? {
        if let index = self.index(of: item), index >= 0 {
            return index == 0 ? self.last : self[index - 1]
        }
        return nil
    }
}

public protocol Tappable {
    func makeTappable(target: Any?, action: Selector?)
}

public extension Tappable where Self:UIView {
    
    func makeTappable(target: Any?, action: Selector?) {
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
}

class ViewTappable: UIView, Tappable {}
class ImageViewTappable: UIImageView, Tappable {}


protocol Alertable {
    func showAlert(title: String, message: String)
}
extension Alertable {
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let controller = self as? UIViewController {
            controller.present(alert, animated: true) {}
        }
    }
}
