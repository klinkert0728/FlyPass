//
//  KeychainHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 7/9/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import KeychainAccess

public enum KeychainServices:String {
    case tokenKeychain
    case defaultKeyChain
    
    
    fileprivate func serviceTitle() -> String {
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
    
    class func saveString(param:String,forKeychainService:KeychainServices,completionHandler:@escaping ()->()) {
        let tokenKeyChain = Keychain(service: KeychainServices.tokenKeychain.rawValue)
        tokenKeyChain["token"] = param
        completionHandler()
    }
    
    class func getUserToken() -> String?  {
        let tokenKeyChain = Keychain(service: KeychainServices.tokenKeychain.rawValue)
        return tokenKeyChain["token"]
    }
    
    class func removeUserToken() {
        let tokenKeyChain = Keychain(service: KeychainServices.tokenKeychain.rawValue)
        tokenKeyChain["token"] = nil
    }
    
}
