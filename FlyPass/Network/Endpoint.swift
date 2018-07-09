//
//  Endpoint.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import KeychainAccess

fileprivate struct requestConstants {
    fileprivate enum constantUrls {
        static let baseUrl = "https://secure.flypass.com.co/flypass/"
    }
    
    fileprivate enum constantPaths {
        static let login            =   "secure/oauth/token"
        static let userInfo         =   "user-service/userinformation"
        static let userMovements    =   "report/userMovements"
        static let accountOptions   =   "bancolombia-integration/paymentMethod/erolleds"
        static let rechargeAccount  =   "bancolombia-integration/processUrlDebitAccount/makeDebitAccount"
    }
}



enum flypassEndpoint {
    case login(userDocument:String,password:String)
    case userInformation()
    case getUserMovements(page:Int)
    case accountOptions()
    case rechargeAccount(rechargeAmount:Int,rechargeAccount:RechargeAccount)
}


extension flypassEndpoint:APIEndpoint {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: requestConstants.constantUrls.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .login(userDocument: _, password: _):
            return requestConstants.constantPaths.login
        case .userInformation():
            return requestConstants.constantPaths.userInfo
        case .getUserMovements(page: _):
            return requestConstants.constantPaths.userMovements
        case .accountOptions():
            return requestConstants.constantPaths.accountOptions
        case .rechargeAccount(rechargeAmount: _,rechargeAccount:_):
            return requestConstants.constantPaths.rechargeAccount
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login(userDocument: _, password: _),.rechargeAccount(rechargeAmount:_,rechargeAccount:_):
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(userDocument: let userDocument, password: let password):
            return ["client_id":"flypass","grant_type":"password","username":userDocument,"password":password]
        case .getUserMovements(page: let page):
            return ["page":page]
        case .rechargeAccount(rechargeAmount:let amount,rechargeAccount:let accountInfo):
            var accountDic                      = Mapper().toJSON(accountInfo)
            guard let secureUser = accountDic["user"], var signature = accountDic["signature"] as? [String:Any] else {
                return nil
            }
            
            signature["user"]                   = secureUser
            accountDic["signature"]             = signature
            accountDic["attemptOTP"]            = "0"
            accountDic["enrolled"]              = true
            accountDic["registrationDate"]      = accountInfo.registationDate.timeIntervalSince1970
            accountDic["id"]                    = accountInfo.accountUuid
            return ["paymentMethod":accountDic,"transactionValue":amount]
            
        default:
            return nil
        }
    }
    
    var customParameterEncoding: ParameterEncoding {
        switch self {
        case .rechargeAccount(rechargeAmount: _, rechargeAccount: _):
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
        
    }
    
    var customHTTPHeaders: [String: String]? {
        switch self {
        case .login(userDocument: _, password: _):
            return ["Authorization":"Basic Zmx5cGFzczpSbXg1ZEdWamFDNHlNREUz"]
        default:
            let token = Keychain.getData(for:keychainConstants.token.rawValue, andKeychainService: KeychainServices.tokenKeychain) ?? ""
            return ["Authorization": "Bearer \(token)","Content-Type":"application/json"]
        }
    }
}
