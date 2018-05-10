//
//  Apearance.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation


import Foundation
import UIKit

class Appearance: NSObject {
    
    class func configureAppAppearance(){
        configureNavBarTitleFont()
    }
    
    class func configureNavBarTitleFont() {
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
    }
    
    class func colorNavigationBar(color:UIColor, navigationBar: UINavigationBar?) {
        navigationBar?.setBackgroundImage(UIImage.imageFromColor(color: color), for: UIBarMetrics.default)
        navigationBar?.isTranslucent        = false
        navigationBar?.barTintColor         = color
        
        
        let font = UIFont.systemFont(ofSize: 12)
        
        navigationBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: font]
        navigationBar?.shadowImage = UIImage()
    }
    
    
    class func barButtonWithImage(image: UIImage?, target: Any?, action: Selector, color:Bool) -> UIBarButtonItem {
        
        let but: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        but.frame = CGRect(x:0, y:0, width:70, height:30)
        but.backgroundColor = UIColor.clear
        
        if color {
            but.setImage(image?.imageWithTintColor(color: UIColor.white), for: UIControlState.normal)
        }else{
            but.setImage(image, for: UIControlState.normal)
        }
        
        but.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        but.sizeToFit()
        
        let barButton = UIBarButtonItem(customView: but)
        return barButton
        
    }
    
    class func barButtonWithImage(image: UIImage?, target: Any?, color:UIColor = UIColor.white, action: Selector) -> UIBarButtonItem {
        
        let but: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        but.frame = CGRect(x:0, y:0, width:70, height:30)
        but.backgroundColor = UIColor.clear
        but.setImage(image?.imageWithTintColor(color: color), for: UIControlState.normal)
        but.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        but.sizeToFit()
        
        let barButton = UIBarButtonItem(customView: but)
        return barButton
        
    }
    
    class func barButtonWithTitle(title: String?, target: Any?, action: Selector) -> UIBarButtonItem {
        
        let but: UIButton       = UIButton(type: UIButtonType.custom) as UIButton
        but.frame               = CGRect(x:0, y:0, width:50, height:30)
        but.backgroundColor     = UIColor.clear
        but.titleLabel?.font    = UIFont.systemFont(ofSize: 12)
        but.setTitleColor(UIColor.white, for: UIControlState.normal)
        but.setTitle(title, for: UIControlState.normal)
        but.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        but.sizeToFit()
        
        let barButton = UIBarButtonItem(customView: but)
        
        return barButton
    }
    
    class func barButtonWithTitle(title: String?, textColor: UIColor, target: Any?, action: Selector) -> UIBarButtonItem {
        
        let but: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        but.frame = CGRect(x:0, y:0, width:50, height:30)
        but.backgroundColor = UIColor.clear
        but.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        but.setTitleColor(textColor, for: UIControlState.normal)
        but.setTitle(title, for: UIControlState.normal)
        but.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        but.sizeToFit()
        
        let barButton = UIBarButtonItem(customView: but)
        
        return barButton
    }
    
    
}


