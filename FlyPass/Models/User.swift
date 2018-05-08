//
//  User.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

@objcMembers
class User: Object,Mappable {
    
    dynamic var fullname                    = ""
    dynamic var token                       = ""
    dynamic var documentType                = ""
    dynamic var documentId                  = ""
    dynamic var availableAmount             = 0.0
    dynamic var limitAmountLow              = 0.0
    dynamic var minimumRechargeAmount       = 0.0
    dynamic var monthlyAverageConsumption   = 0.0
    var userMovements                       = List<UserMovements>()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "documentId"
    }
    
    func mapping(map: Map) {
        
        fullname                    <- map["body.secureUser.person.fullName"]
        token                       <- map[""]
        documentType                <- map["body.secureUser.person.documentType"]
        documentId                  <- map["body.secureUser.person.document"]
        availableAmount             <- map["body.availableAmount"]
        limitAmountLow              <- map["body.limitAmountLow"]
        minimumRechargeAmount       <- map["body.minimumRechargeAmount"]
        monthlyAverageConsumption   <- map["body.monthlyAverageConsumption"]
    }
    
    
    class func getUserInformation(successCallback:@escaping (_ user:User)->(),errorCallback:@escaping (_ error:Error)->()) {
        APIClient.sharedClient.requestObject(endpoint: flypassEndpoint.userInformation(), completionHandler: { (user:User) in
            Realm.update(updateClosure: { (realm) in
                realm.add(user, update: true)
            })
            successCallback(user)
        }, errorClosure: {error in
            errorCallback(error)
        })
    }
}

@objcMembers
class UserMovements:Object,Mappable {
    
    dynamic var amount              = 0.0
    dynamic var lisencePlate        = ""
    dynamic var date                = Date()
    dynamic var movementDescription = ""
    dynamic var movementId          = ""
    
    override static func primaryKey() -> String? {
        return "movementId"
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        amount              <- map["amount"]
        lisencePlate        <- map["licensePlate"]
        date                <- (map["date"],DateTransform())
        movementDescription <- map["description"]
        movementId          <- map["movemnentId"]
    }
    
    class func getUserMovements(successCallback:@escaping (_ user:[UserMovements])->(),errorCallback:@escaping (_ error:Error)->()) {
        
        APIClient.sharedClient.requestArrayOfObject(endpoint: flypassEndpoint.getUserMovements(page: 1), keyPath: "body.content", completionHandler: { (movements:[UserMovements]) in
            successCallback(movements)
        }, errorClosure: {error in
            errorCallback(error)
        })
    }
}
