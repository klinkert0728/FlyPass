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

enum flypassEndpoint {
    case login(userDocument:String,password:String)
    case userInformation()
    case getUserMovements(page:Int)
    
    
}


extension flypassEndpoint:APIEndpoint {
    
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://secure.flypass.com.co/flypass/")!
        }
    }
    
    var path: String {
        switch self {
        case .login(userDocument: _, password: _):
            return "secure/oauth/token"
        case .userInformation():
            return "user-service/userinformation"
        case .getUserMovements(page: _):
            return "report/userMovements"
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .login(userDocument: _, password: _):
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
        default:
            return nil
        }
    }
    
    var customParameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
        
    }
    
    var customHTTPHeaders: [String: String]? {
        switch self {
        case .login(userDocument: _, password: _):
            return ["Authorization":"Basic Zmx5cGFzczpSbXg1ZEdWamFDNHlNREUz"]
        default:
            //let token = KNMTCAppEngine.activeAppEngine()?.sessionManager.activeSession()?.token ?? ""
            let token = User.currentUser?.token ?? ""
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
