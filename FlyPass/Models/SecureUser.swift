//
//  SecureUser.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 6/6/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

@objcMembers
class SecureUser:Object,Mappable {
    
    dynamic var login           = ""
    dynamic var secureUserId    = 0
    dynamic var person:Person?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
    func mapping(map: Map) {
        
        login           <- map["login"]
        secureUserId    <- map["id"]
        person          <- map["person"]
    }
    
}
