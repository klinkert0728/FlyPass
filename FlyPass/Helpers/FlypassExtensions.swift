//
//  FlypassExtensions.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
extension Int {
    func formatInt() -> String? {
        let numberFormatter         = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber         = numberFormatter.string(from: NSNumber(value:self))
        return formattedNumber
    }
}

extension UIView {
    
    
    var height : CGFloat {
        get{return self.frame.size.height}
        set{frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:self.frame.size.width, height:newValue)}
    }
    
    var width : CGFloat {
        get{return self.frame.size.width}
        set{frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width:newValue, height:self.frame.size.height)}
    }
    
    var x : CGFloat {
        get{return self.frame.origin.x}
        set{frame = CGRect(x:newValue, y:self.frame.origin.y, width:self.frame.size.width, height:self.frame.size.height)}
    }
    
    var y : CGFloat {
        get{return self.frame.origin.y}
        set{frame = CGRect(x:self.frame.origin.x, y:newValue, width:self.frame.size.width, height:self.frame.size.height)}
    }
    
    var yCenter : CGFloat {
        get{return self.y + self.height/2.0}
        set{self.y = yCenter - self.height/2.0}
    }
    
    var xCenter : CGFloat {
        get{return self.x + self.width/2.0}
        set{self.x = newValue - self.width/2.0}
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius =  newValue
        }
        get { return layer.cornerRadius}
    }
    
    @IBInspectable var borderWidth : CGFloat {
        set {layer.borderWidth = newValue}
        get { return layer.borderWidth}
    }
    
    @IBInspectable var borderColor : UIColor {
        set { layer.borderColor =  newValue.cgColor }
        get { return UIColor(cgColor: layer.borderColor!)}
    }
    
    /**
     Convert curretn view to image
     
     :returns: return the image
     */
    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size);
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return viewImage!
    }
}

//MARK: - UIImage
extension UIImage {
    
    class func imageFromColor(color: UIColor) -> UIImage {
        return imageFromColor(color: color, size: CGSize(width:10, height:10))
    }
    
    class func imageFromColor(color: UIColor, size: CGSize) -> UIImage {
        let imageView = UIView(frame: CGRect(x:0, y:0,width:size.width, height:size.height))
        imageView.backgroundColor = color
        return imageView.convertToImage()
    }
    
    
    func imageScaledToSize(sizeA:CGSize) -> UIImage {
        
        let size = sizeA
        
        let maxLong = max(self.size.width, self.size.height)
        let relation = size.width/maxLong
        let newSize:CGSize = CGSize(width: self.size.width*relation, height: self.size.height*relation)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    
    func imageWithTintColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        let rect: CGRect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect);
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
        
    }
    
    
    class func image(named name:String, tintColor: UIColor) -> UIImage {
        let image: UIImage = UIImage(named: name)!
        return image.imageWithTintColor(color: tintColor)
    }
    
    
    func crop(rect: CGRect) -> UIImage {
        /*rect.origin.x*=self.scale
         rect.origin.y*=self.scale
         rect.size.width*=self.scale
         rect.size.height*=self.scale
         */
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    
    func imageWithCornerRadius(radius:CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: radius).addClip()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
