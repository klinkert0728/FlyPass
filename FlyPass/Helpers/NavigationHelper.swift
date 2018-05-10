//
//  NavigationHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import  UIKit

fileprivate enum storyboardsName {
    static let signIn = "SingIn"
}

fileprivate enum controllersIndentifiers {
    static let signInNavigationController = "singInNavigationController"
}

class NavigationHelper {
    //MARK: SignIn
    class func signInNavigationViewController() -> UINavigationController {
        return UIStoryboard(name: storyboardsName.signIn, bundle: nil).instantiateViewController(withIdentifier: controllersIndentifiers.signInNavigationController) as! UINavigationController
    }
    
}
