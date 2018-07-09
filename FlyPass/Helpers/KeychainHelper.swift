//
//  KeychainHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 7/9/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import KeychainAccess

public enum keychainConstants:String {
    case token 
}

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
    
    class func saveString(inKey key:String, value:String,forKeychainService service:KeychainServices,completionHandler:@escaping ()->()) {
        let tokenKeyChain = Keychain(service: service.rawValue)
        tokenKeyChain[key] = value
        completionHandler()
    }
    
    class func getData(for key:String,andKeychainService service:KeychainServices) -> String?  {
        let tokenKeyChain = Keychain(service: service.rawValue)
        return tokenKeyChain[key]
    }
    
    class func removeData(key:String,inKeychainService service:KeychainServices) {
        let tokenKeyChain = Keychain(service: service.rawValue)
        tokenKeyChain[key] = nil
    }
    
}
