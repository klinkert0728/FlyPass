//
//  Person.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 6/6/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

@objcMembers
class Person:Object,Mappable {
    
    dynamic var fullname        = ""
    dynamic var id              = 0
    dynamic var documentId      = ""
    dynamic var documentType    = 0
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "documentId"
    }
    
    func mapping(map: Map) {
        
        fullname                    <- map["fullName"]
        documentType                <- map["documentType"]
        documentId                  <- map["document"]
        id                          <- map["id"]
    }
    
}
