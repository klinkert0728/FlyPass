//
//  NavigationHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import  UIKit


class NavigationHelper {
    //MARK: SignIn
    class func signInNavigationViewController() -> UINavigationController {
        return UIStoryboard(name: "SingIn", bundle: nil).instantiateViewController(withIdentifier: "singInNavigationController") as! UINavigationController
        
    }
    
}
