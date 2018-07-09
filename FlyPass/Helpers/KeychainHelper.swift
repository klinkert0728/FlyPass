//
//  KeychainHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 7/9/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import KeychainAccess

fileprivate enum KeychainServices:String {
    case tokenKeychain
    case defaultKeyChain
    
    
    func serviceTitle() -> String {
        let bundle  = Bundle.main.bundleIdentifier!
        switch self {
        case .tokenKeychain:
            return "\(bundle)-token"
        case .defaultKeyChain:
            return bundle
        }
    }
    
}

public extension Keychain {
    
    class func saveUserToken(token:String,completitionHandler:@escaping ()->()) {
        let tokenKeyChain = Keychain(service: KeychainServices.tokenKeychain.rawValue)
        tokenKeyChain["token"] = token
        completitionHandler()
    }
    
    class func getUserToken() -> String?  {
        let tokenKeyChain = Keychain(service: KeychainServices.tokenKeychain.rawValue)
        return tokenKeyChain["token"]
    }
    
}
