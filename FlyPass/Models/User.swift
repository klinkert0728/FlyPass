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
import KeychainAccess
import ReachabilitySwift

@objcMembers
class User: Object,Mappable {
    
    dynamic var documentId                  = ""
    dynamic var availableAmount             = 0.0
    dynamic var limitAmountLow              = 0.0
    dynamic var minimumRechargeAmount       = 0.0
    dynamic var monthlyAverageConsumption   = 0.0
    dynamic var personId                    = 0
    dynamic var id                          = 0
    dynamic var person:Person?
    
    class var currentUser:User? {
        var user:User? = nil
        Realm.update { (realm) in
            user = realm.objects(User.self).first
        }
        return user
    }
    
    class var isLoggedIn:Bool {
        return currentUser != nil
    }
    
    class func logOut() {
        Realm.update { (realm) in
            realm.delete(realm.objects(User.self))
        }
        Keychain.removeData(key: keychainConstants.token.rawValue, inKeychainService: KeychainServices.tokenKeychain)
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "documentId"
    }
    
    func mapping(map: Map) {
        
        availableAmount             <- map["body.availableAmount"]
        limitAmountLow              <- map["body.limitAmountLow"]
        minimumRechargeAmount       <- map["body.minimumRechargeAmount"]
        monthlyAverageConsumption   <- map["body.monthlyAverageConsumption"]
        documentId                  <- map["body.secureUser.person.documentId"]
        person                      <- map["body.secureUser.person"]
    }
    
    
    class func getUserInformation(userCompletionHandler:@escaping (_ user:User?, _ error:Error?)->()) {
        let reachibility = Reachability()!
        if !reachibility.isReachable {
            var user:User? = nil
            Realm.update { (realm) in
                user = realm.objects(User.self).last
            }
            userCompletionHandler(user,nil)
            return
        }
        
        APIClient.sharedClient.requestObject(endpoint: flypassEndpoint.userInformation(), completionHandler: { (user:User) in
            var currentUser:User? = nil
            Realm.update(updateClosure: { (realm) in
                currentUser = realm.objects(User.self).first
                currentUser = user
                currentUser?.documentId = user.person?.documentId ?? ""
                realm.add(currentUser!, update: true)
            })
            userCompletionHandler(currentUser,nil)
        }, errorClosure: { error in
            var currentUser:User? = nil
            Realm.update(updateClosure: { (realm) in
                currentUser = realm.objects(User.self).first
            })
            userCompletionHandler(currentUser,error)
        })
    }
    
    class func authenticateUser(documentId:String,password:String,successCallback:@escaping()->(),errorCallback:@escaping(_ error:Error)->()) {
        APIClient.sharedClient.requestJSONObject(endpoint: flypassEndpoint.login(userDocument: documentId, password: password), completionHandler: { (json) in
            guard let jsonDict = json as? [String:Any] else {
                errorCallback(NSError(domain: "", code: 422, userInfo: [NSLocalizedDescriptionKey:"Bad response"]))
                return
            }
            Realm.update(updateClosure: { (realm) in
                let user            = User()
                user.documentId     = documentId
                realm.add(user)
            })
            let token   = (jsonDict["access_token"] as? String) ?? ""
            Keychain.saveString(inKey: keychainConstants.token.rawValue, value: token, forKeychainService: .tokenKeychain, completionHandler: successCallback)
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
        date                <- (map["date"],FlypassDateTransform())
        movementDescription <- map["description"]
        movementId          <- map["reference"]
    }
    
    class func getMovementsFromDataBase(completitionHandler: @escaping (_ movements:[UserMovements]) -> ()) {
        var movements = [UserMovements]()
        Realm.update { (realm) in
            let movementsResult = realm.objects(UserMovements.self)
            movements           = Array(movementsResult)
        }
        completitionHandler(movements)
    }
    
    class func getUserMovements(page:Int,successCallback:@escaping (_ movements:[UserMovements])->(),errorCallback:@escaping (_ error:Error)->()) {
        let reachibility = Reachability()!
        if !reachibility.isReachable {
            UserMovements.getMovementsFromDataBase { (userMovements:[UserMovements]) in
                successCallback(userMovements)
            }
            return
        }
        
        APIClient.sharedClient.requestArrayOfObject(endpoint: flypassEndpoint.getUserMovements(page: page), keyPath: "body.content", completionHandler: { (movements:[UserMovements]) in
            Realm.update(updateClosure: { (realm) in
                realm.add(movements, update: true)
            })
            successCallback(movements)
        }, errorClosure: { error in
            errorCallback(error)
        })
    }
}
