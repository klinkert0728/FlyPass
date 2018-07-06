//
//  RechargeAccount.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 6/6/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

@objcMembers
class RechargeAccount: Object,Mappable {

    dynamic var accountNumber               = 0
    dynamic var customName                  = ""
    dynamic var accountUuid                 = 0
    dynamic var productUuid                 = ""
    dynamic var registationDate             = Date()
    dynamic var userId                      = 0
    dynamic var suffixAccount               = ""
    dynamic var productType:ProductType?
    dynamic var signature:Signature?
    dynamic var secureUser:SecureUser?
    
    override static func primaryKey() -> String? {
        return "accountUuid"
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        accountNumber               <- map["accountNumber"]
        customName                  <- map["customName"]
        productUuid                 <- map["idProductFlypass"]
        productType                 <- map["productType"]
        suffixAccount               <- map["suffixAccount"]
        accountUuid                 <- map["id"]
        registationDate             <- (map["registrationDate"],FlypassDateTransform())
        signature                   <- map["signature"]
        userId                      <- map["user.id"]
        secureUser                  <- map["user.secureUser"]
    }
    
    
    class func getRechargeOptions(endPoint:flypassEndpoint,successClosure:@escaping (_ rechargeDetails:[RechargeAccount])->(), errorClosure:@escaping (_ error:Error)->()) {
        APIClient.sharedClient.requestArrayOfObject(endpoint: endPoint, keyPath: "body", completionHandler: { (rechargeDetails:[RechargeAccount]) in
            successClosure(rechargeDetails)
        }, errorClosure: errorClosure)
        
    }
    
    static func rechargeAccount(endPoint:flypassEndpoint,successClosure:@escaping ()->(), errorClosure:@escaping (_ error:Error)->()) {
        APIClient.sharedClient.requestJSONObject(endpoint: endPoint, completionHandler: { (responseData) in
            if let responseDict = responseData as? [String:Any], let responseCode = responseDict["code"] as? String {
                if responseCode == "000" {
                    successClosure()
                }
            }
        }, errorClosure: errorClosure)
    }
}

@objcMembers
class ProductType:Object,Mappable {
    
    dynamic var name                = ""
    dynamic var productDescription  = ""
    dynamic var productId           = 0
    
    override static func primaryKey() -> String? {
        return "productId"
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        name                <- map["name"]
        productDescription  <- map["description"]
        productId           <- map["id"]
    }
}

@objcMembers
class Signature:Object,Mappable {
    
    dynamic var accept                  = false
    dynamic var id                      = 0
    dynamic var signature               = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        accept          <- map["accept"]
        id              <- map["id"]
        signature       <- map["signature"]
    }
}
