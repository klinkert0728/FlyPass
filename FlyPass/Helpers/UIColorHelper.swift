//
//  UIColorHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/10/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum colorConstantsName {
    static let primary = "primary"
}

extension UIColor {
    
    enum colorConstants {
        static let primary = UIColor(hex: "#bed94d")
    }
    
    class func colorFromString(titleColor:String) -> UIColor {
        switch titleColor.lowercased() {
        case "white":
            return UIColor.white
        case "clear":
            return UIColor.clear
        case colorConstantsName.primary:
            return colorConstants.primary
        default:
            return UIColor.white
        }
    }
    
    func colorString() -> String{
        switch self {
        case UIColor.white:
            return "white"
        case UIColor.clear:
            return "clear"
        case colorConstants.primary:
            return colorConstantsName.primary
        default:
            return "clear"
        }
    }
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}
